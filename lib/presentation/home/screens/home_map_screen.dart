import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:app_aq_2/core/constants/keys.dart';
import 'package:app_aq_2/core/router/router.dart';
import 'package:app_aq_2/core/theme/theme.dart';
import 'package:flutter_scalify/responsive_scale/responsive_extensions.dart';
import 'package:app_aq_2/core/widgets/loading_indicator.dart';
import 'package:app_aq_2/core/widgets/error_view.dart';
import 'package:app_aq_2/core/data/datasource.dart';
import 'package:app_aq_2/core/models/place.dart';
import 'package:app_aq_2/core/models/route_info.dart';
import 'package:app_aq_2/core/utils/location_handler.dart';
import 'package:app_aq_2/presentation/home/cubit/home_cubit.dart';
import 'package:app_aq_2/presentation/home/cubit/home_state.dart';
import 'package:app_aq_2/core/widgets/map_builder.dart';
import 'package:app_aq_2/core/widgets/markers_builder.dart';
import 'package:app_aq_2/presentation/home/screens/widgets/map_legend_builder.dart';
class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key, this.targetPlaceId});

  final String? targetPlaceId;

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  final MapController mapController = MapController();
  RouteInfo? _routeInfo;
  bool _isRouteLoading = false;
  bool _routeIsFallback = false;
  String? _pendingTargetPlaceId;
  bool _hasStartedTargetRoute = false;

  @override
  void initState() {
    super.initState();
    _pendingTargetPlaceId = widget.targetPlaceId;
    if (_pendingTargetPlaceId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _consumePendingTargetFromState();
      });
    }
  }

  @override
  void didUpdateWidget(HomeMapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetPlaceId != null &&
        widget.targetPlaceId != oldWidget.targetPlaceId) {
      _requestTargetRoute(widget.targetPlaceId!);
    }
  }

  void _consumePendingTargetFromState() {
    if (!mounted) return;
    final state = context.read<HomeCubit>().state;
    if (state is! HomeLoaded) return;

    final pendingId =
        _pendingTargetPlaceId ?? state.pendingTargetPlaceId;
    if (pendingId == null) return;

    context.read<HomeCubit>().setPendingTargetPlace(null);
    _requestTargetRoute(pendingId, state);
  }

  void _requestTargetRoute(String placeId, [HomeLoaded? state]) {
    _pendingTargetPlaceId = placeId;
    _hasStartedTargetRoute = false;
    _routeInfo = null;
    _routeIsFallback = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final currentState = state ?? context.read<HomeCubit>().state;
      if (currentState is HomeLoaded) {
        _startPendingRoute(currentState);
      }
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocConsumer<HomeCubit, HomeCubitState>(
        listener: (context, state) {
          if (state is HomeLoaded && state.pendingTargetPlaceId != null) {
            final placeId = state.pendingTargetPlaceId!;
            context.read<HomeCubit>().setPendingTargetPlace(null);
            _requestTargetRoute(placeId, state);
          }

          if (state is HomeLoaded && state.moveToFilter) {
            context.read<HomeCubit>().resetFilterCenter();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              final places = state.filteredPlaces;
              if (places.isEmpty) return;

              if (places.length == 1) {
                final p = places.first;
                mapController.move(
                  LatLng(p.location.latitude, p.location.longitude),
                  14.0,
                );
              } else {
                final List<LatLng> boundsList = minAMaxBounds(places);

                final bounds = LatLngBounds(
                  LatLng(boundsList[0].latitude, boundsList[0].longitude),
                  LatLng(boundsList[1].latitude, boundsList[1].longitude),
                );

                mapController.fitCamera(
                  CameraFit.bounds(
                    bounds: bounds,
                    padding: const EdgeInsets.all(50),
                  ),
                );
              }
            });
          }
        },
        builder: (context, state) {
          if (state is HomeLoading) return const LoadingIndicator();

          if (state is HomeLoaded) {
            if (state.filteredPlaces.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('No places found'),
                    content: const Text('Try adjusting your filters.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.read<HomeCubit>().resetMap();

                          GoRouter.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              });
            }

            final Map<String, Color> cityColors = getCityColors();
            final topInset = MediaQuery.of(context).padding.top;
            const headerHeight = 78.0;
            const headerGap = 12.0;
            final contentTop = topInset + headerGap + headerHeight + headerGap;
            final hasRouteCard = _routeInfo != null;

            return Stack(
              children: [
                mapBuilder(
                  markerLayerBuilder: () => _markerLayerBuilder(
                    context,
                    mapController: mapController,
                    places: state.filteredPlaces,
                    userLocation: state.userLocation,
                    onRouteTap: (place) => _startRouteToPlace(context, place),
                  ),
                  polyLayerBuilder: _buildRouteLayer,
                  mapController: mapController,
                  initZoomLevel: 6.0,
                  focusCords: syriaCords,
                ),
                Positioned(
                  top: contentTop + (hasRouteCard ? 118 : 0),
                  left: 16,
                  child: legendBuilder(cityColors, state),
                ),
                Positioned(
                  top: topInset + headerGap,
                  left: 16,
                  right: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        height: 78,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated.withValues(
                            alpha: 0.78,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.45),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Text(
                              'Rahhal',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            InkResponse(
                              onTap: () =>
                                  GoRouter.of(context).push(RoutePaths.filter),
                              radius: 24,
                              splashColor: AppColors.accent.withValues(
                                alpha: 0.24,
                              ),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.surface.withValues(
                                    alpha: 0.26,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.filter_list,
                                  size: 22,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            InkResponse(
                              onTap: () =>
                                  GoRouter.of(context).push(RoutePaths.search),
                              radius: 24,
                              splashColor: AppColors.accent.withValues(
                                alpha: 0.24,
                              ),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.surface.withValues(
                                    alpha: 0.26,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.search,
                                  size: 22,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (hasRouteCard)
                  Positioned(
                    top: contentTop,
                    left: 16,
                    right: 16,
                    child: _buildRouteInfoCard(),
                  ),
                if (_isRouteLoading)
                  Positioned(
                    top: contentTop - 4,
                    left: 16,
                    right: 16,
                    child: const LinearProgressIndicator(
                      color: AppColors.accent,
                    ),
                  ),
                Positioned(
                  right: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 148,
                  child: _buildMapActionButtons(context),
                ),
              ],
            );
          }

          return ErrorView(message: "Something went wrong", onRetry: () {});
        },
      ),
    );
  }

  Future<void> _startRouteToPlace(BuildContext context, Place place) async {
    setState(() {
      _isRouteLoading = true;
      _routeInfo = null;
      _routeIsFallback = false;
    });

    final messenger = ScaffoldMessenger.of(context);
    LatLng? source;
    final currentState = context.read<HomeCubit>().state;
    if (currentState is HomeLoaded && currentState.userLocation != null) {
      source = currentState.userLocation;
    } else {
      final userLocation = await getUserLocation();
      if (userLocation != null) {
        source = LatLng(userLocation.latitude!, userLocation.longitude!);
      }
    }

    if (source == null) {
      if (!mounted) return;
      setState(() {
        _isRouteLoading = false;
      });
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to get your location. Please check location permissions.',
          ),
        ),
      );
      return;
    }

    final destination = LatLng(
      place.location.latitude,
      place.location.longitude,
    );

    final route = await getRoute(source, destination);

    if (!mounted) return;

    final safeSource = source;
    setState(() {
      _routeInfo =
          route ??
          RouteInfo(
            routepoints: [safeSource, destination],
            distance: Distance().as(LengthUnit.Meter, safeSource, destination),
            duration: 0,
          );
      _routeIsFallback = route == null;
      _isRouteLoading = false;
    });

    _fitMapToRoute(_routeInfo!.routepoints);
  }

  void _fitMapToRoute(List<LatLng> points) {
    if (points.isEmpty) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final bounds = LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
    mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(32)),
    );
  }

  void _startPendingRoute(HomeLoaded state) {
    if (_hasStartedTargetRoute || _pendingTargetPlaceId == null) return;

    final matchingPlaces = state.places
        .where((place) => place.id == _pendingTargetPlaceId)
        .toList();
    if (matchingPlaces.isEmpty) return;

    _hasStartedTargetRoute = true;
    final targetPlace = matchingPlaces.first;
    _pendingTargetPlaceId = null;

    mapController.move(
      LatLng(targetPlace.location.latitude, targetPlace.location.longitude),
      14.0,
    );
    _startRouteToPlace(context, targetPlace);
  }

  Widget _buildMapActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildMapActionButton(
          icon: Icons.restart_alt,
          label: 'Reset',
          onTap: () {
            setState(() {
              _routeInfo = null;
              _routeIsFallback = false;
            });
            context.read<HomeCubit>().resetMap();
            mapController.move(syriaCords, 6.0);
          },
        ),
        const SizedBox(height: 10),
        BlocSelector<HomeCubit, HomeCubitState, bool>(
          selector: (state) =>
              state is HomeLoaded && state.isFetchingLocation,
          builder: (context, isFetchingLocation) {
            return _buildMapActionButton(
              icon: Icons.my_location,
              label: isFetchingLocation ? 'Locating...' : 'My Location',
              isLoading: isFetchingLocation,
              onTap: () async {
                final homeCubit = context.read<HomeCubit>();
                final messenger = ScaffoldMessenger.of(context);
                await homeCubit.fetchUserLocation();
                final currentState = homeCubit.state;
                if (currentState is HomeLoaded &&
                    currentState.userLocation != null) {
                  mapController.move(currentState.userLocation!, 16.0);
                } else {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Unable to get your location. Please check location permissions.',
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
        const SizedBox(height: 10),
        _buildMapActionButton(
          icon: Icons.travel_explore,
          label: 'Start Trip',
          isAccent: true,
          onTap: () => GoRouter.of(context).push(RoutePaths.tripSuggestion),
        ),
      ],
    );
  }

  Widget _buildMapActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isAccent = false,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isAccent
                ? AppColors.accent
                : AppColors.surfaceElevated.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isAccent
                  ? AppColors.accent
                  : AppColors.border.withValues(alpha: 0.45),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.16),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isAccent ? AppColors.black : AppColors.accent,
                  ),
                )
              else
                Icon(
                  icon,
                  size: 20,
                  color: isAccent ? AppColors.black : AppColors.accent,
                ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isAccent ? AppColors.black : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteInfoCard() {
    final routeInfo = _routeInfo;
    if (routeInfo == null) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated.withValues(alpha: 0.86),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.38),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _routeIsFallback ? 'Estimated Route' : 'Calculated Route',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildRouteInfoBadge(
                      icon: Icons.route,
                      label:
                          '${(routeInfo.distance / 1000).toStringAsFixed(1)} km',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildRouteInfoBadge(
                      icon: Icons.access_time,
                      label: '${(routeInfo.duration / 60).round()} min',
                    ),
                  ),
                ],
              ),
              if (_routeIsFallback)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Route service unavailable. Showing a direct estimated path.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteInfoBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.accent),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PolylineLayer _buildRouteLayer() {
    if (_routeInfo == null || _routeInfo!.routepoints.isEmpty) {
      return PolylineLayer(polylines: []);
    }

    return PolylineLayer(
      polylines: [
        Polyline(
          points: _routeInfo!.routepoints,
          strokeWidth: 5.0,
          color: AppColors.accent,
        ),
      ],
    );
  }
}

List<LatLng> minAMaxBounds(List<Place> places) {
  double minLat = places.first.location.latitude;
  double maxLat = minLat;
  double minLng = places.first.location.longitude;
  double maxLng = minLng;

  for (final p in places) {
    final lat = p.location.latitude;
    final lng = p.location.longitude;
    if (lat < minLat) minLat = lat;
    if (lat > maxLat) maxLat = lat;
    if (lng < minLng) minLng = lng;
    if (lng > maxLng) maxLng = lng;
  }

  return [LatLng(minLat, minLng), LatLng(maxLat, maxLng)];
}

MarkerLayer _markerLayerBuilder(
  BuildContext context, {
  required List<Place> places,
  required mapController,
  required Future<void> Function(Place) onRouteTap,
  LatLng? userLocation,
}) {
  final Map<String, Color> cityColors = getCityColors();

  return MarkerLayer(
    markers: [
      ...places.map((place) {
        final Color placeColor = cityColors[place.city] ?? Colors.grey;
        final placeLL = LatLng(
          place.location.latitude,
          place.location.longitude,
        );

        return Marker(
          point: placeLL,
          child: GestureDetector(
            onTap: () async {
              mapController.move(placeLL, 18.0);

              await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                barrierColor: Colors.black26,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (ctx) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          MediaQuery.of(ctx).viewInsets.bottom +
                          MediaQuery.of(ctx).padding.bottom +
                          80,
                    ),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated.withValues(
                          alpha: 0.96,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        border: Border.all(
                          color: AppColors.border.withValues(alpha: 0.45),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          // Compact header row with title and close
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Place Info',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => Navigator.of(ctx).pop(),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Icon(
                                      Icons.close,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Container(
                              width: 48,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.18,
                                ),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            child: Image.asset(
                              place.image,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            place.city,
                                            style: AppTextStyles.labelLarge
                                                .copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            place.name,
                                            style: AppTextStyles.headlineSmall
                                                .copyWith(
                                                  color: AppColors.textPrimary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withValues(
                                          alpha: 0.16,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        place.category.label,
                                        style: const TextStyle(
                                          color: AppColors.accent,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (index) => Padding(
                                          padding: const EdgeInsets.only(
                                            right: 4.0,
                                          ),
                                          child: Icon(
                                            index < place.rating.round()
                                                ? Icons.star_rounded
                                                : Icons.star_border_rounded,
                                            color: AppColors.accent,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  place.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          GoRouter.of(context).pushNamed(
                                            RouteNames.placeDetails,
                                            pathParameters: {'id': place.id},
                                          );
                                        },
                                        icon: Icon(
                                          Icons.info_outline,
                                          color: AppColors.textPrimary,
                                          size: 18,
                                        ),
                                        label: const Text('View Details'),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: AppColors.border.withValues(
                                              alpha: 0.28,
                                            ),
                                          ),
                                          foregroundColor:
                                              AppColors.textPrimary,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          onRouteTap(place);
                                        },
                                        icon: const Icon(
                                          Icons.directions_car,
                                          size: 18,
                                        ),
                                        label: const Text('Start Journey'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.accent,
                                          foregroundColor: AppColors.black,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.location_on, color: placeColor),
          ),
        );
      }),
      if (userLocation != null) MarkersBuilder.locationMarker(userLocation),
    ],
  );
}
