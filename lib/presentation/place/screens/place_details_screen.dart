import 'package:app_aq_2/core/constants/app_radius.dart';
import 'package:app_aq_2/core/extensions/context_extensions.dart';
import 'package:app_aq_2/core/models/place/place.dart';
import 'package:app_aq_2/core/theme/theme.dart';
import 'package:app_aq_2/presentation/home/cubit/home_cubit.dart';
import 'package:app_aq_2/presentation/home/cubit/home_state.dart';
import 'package:app_aq_2/presentation/home/screens/widgets/favorite_button.dart';
import 'package:app_aq_2/core/widgets/map_builder.dart';
import 'package:app_aq_2/core/widgets/markers_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_scalify/responsive_scale/responsive_extensions.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/di/injector.dart';

import '../../../core/repository/home_repository.dart';

import '../../../core/widgets/widgets.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../core/responsive/screen_type.dart';
import '../cubit/place_details_cubit.dart';
import '../cubit/place_details_state.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({super.key, required this.placeId});
  final String placeId;
  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  final MapController mapController = MapController();

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaceDetailCubit(getIt<HomeRepository>(), widget.placeId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Place Details'),
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
        body: BlocBuilder<PlaceDetailCubit, PlaceDetailState>(
          builder: (context, state) {
            if (state is PlaceDetailLoading) return const LoadingIndicator();
            if (state is PlaceDetailLoaded) {
              return ResponsiveBuilder(
                builder: (context, screenType, width) {
                  // For larger screens show side-by-side layout
                  if (screenType != ScreenType.mobile) {
                    return Padding(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildContent(
                              context,
                              context.screenHeight,
                              state,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(flex: 1, child: _buildSidePanel(state)),
                        ],
                      ),
                    );
                  }

                  return _buildContent(context, context.screenHeight, state);
                },
              );
            }
            if (state is PlaceDetailError) {
              return ErrorView(message: state.failure.message, onRetry: () {});
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  _buildContent(context, double screenHeight, PlaceDetailLoaded state) {
    final placeD = state.place;
    final placeLocation = state.place.location;
    final routeInfo = state.routeInfo;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: double.infinity),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: screenHeight * 25 / 100,
                child: topStackBuilder(placeD),
              ),

              SizedBox(height: AppSpacing.sm),
              Center(
                child: Text(
                  placeLocation.address,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(placeD.description),
              SizedBox(height: AppSpacing.sm),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: 120.h, child: placeImagesBuilder(placeD.images)),
              SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 220.h,
                child: mapSnapShotBuilder(
                  placeD.location.latitude,
                  placeD.location.longitude,
                  state.routeInfo,
                  state.userLocation,
                ),
              ),
              if (routeInfo != null) ...[
                if (routeInfo.distance != 0.0) ...[
                  SizedBox(height: 15.h),
                  Text(
                    '🛣️ Distance: ${(routeInfo.distance / 1000).toStringAsFixed(1)} km',
                  ),
                ],
                if (routeInfo.duration != 0.0) ...[
                  SizedBox(height: 15.h),
                  Text(
                    '⏱️ Estimated time: ${(routeInfo.duration / 60).toStringAsFixed(0)} min',
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidePanel(PlaceDetailLoaded state) {
    final place = state.place;
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(place.name, style: AppTextStyles.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(place.description),
            const SizedBox(height: AppSpacing.md),
            Text('Address', style: AppTextStyles.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(place.location.address),
          ],
        ),
      ),
    );
  }

  Stack topStackBuilder(Place placeD) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(placeD.image, fit: BoxFit.cover)),
        Positioned(
          child: BlocBuilder<HomeCubit, HomeCubitState>(
            builder: (context, state) {
              final isFavorite = state is HomeLoaded
                  ? (state as HomeLoaded).favoritesIndecies.contains(placeD.id)
                  : false;

              return Container(
                color: AppColors.overlayLight,
                child: Row(
                  children: [
                    const Spacer(),
                    favoriteButton(
                      () =>
                          context.read<HomeCubit>().toggleFavoriteId(placeD.id),
                      isFavorite,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  FlutterMap mapSnapShotBuilder(
    double latitude,
    double longitude,
    routeInfo,
    userLocation,
  ) {
    return mapBuilder(
      polyLayerBuilder: () => PolylineLayer(
        polylines: routeInfo != null
            ? routeInfo!.routepoints.isEmpty
                  ? <Polyline>[]
                  : [
                      Polyline(
                        points: routeInfo!.routepoints,
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ]
            : <Polyline>[],
      ),
      focusCords: LatLng(latitude, longitude),
      initZoomLevel: 12.0,
      mapController: mapController,
      markerLayerBuilder: () => MarkerLayer(
        markers: [
          MarkersBuilder.locationMarker(LatLng(latitude, longitude)),
          if (userLocation != null)
            MarkersBuilder.userMarker(
              LatLng(userLocation!.latitude!, userLocation!.longitude!),
            ),
        ],
      ),
    );
  }

  ListView placeImagesBuilder(placeImagesList) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: placeImagesList.length,
      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Image.asset(
            placeImagesList[index],
            fit: BoxFit.cover,
            width: 100.w,
            height: 120.h,
          ),
        );
      },
    );
  }
}
