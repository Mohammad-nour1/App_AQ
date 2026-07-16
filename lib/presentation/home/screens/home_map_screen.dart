import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:app_aq_2/core/constants/keys.dart';
import 'package:app_aq_2/core/router/router.dart';
import 'package:app_aq_2/core/theme/theme.dart';
import 'package:app_aq_2/core/widgets/loading_indicator.dart';
import 'package:app_aq_2/core/widgets/error_view.dart';
import 'package:app_aq_2/core/data/datasource.dart';
import 'package:app_aq_2/core/models/place/place.dart';
import 'package:app_aq_2/presentation/home/cubit/home_cubit.dart';
import 'package:app_aq_2/presentation/home/cubit/home_state.dart';
import 'package:app_aq_2/core/widgets/map_builder.dart';
import 'package:app_aq_2/presentation/home/screens/widgets/map_legend_builder.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  _HomeMapScreenState createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  final MapController mapController = MapController();

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rahhal'),
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).push(RoutePaths.filter),
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: () => GoRouter.of(context).push(RoutePaths.search),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () =>
                GoRouter.of(context).push(RoutePaths.tripSuggestion),
            icon: const Icon(Icons.explore),
          ),
        ],
      ),
      body: BlocConsumer<HomeCubit, HomeCubitState>(
        listener: (context, state) {
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

            return Stack(
              children: [
                mapBuilder(
                  markerLayerBuilder: () => _markerLayerBuilder(
                    context,
                    mapController: mapController,
                    places: state.filteredPlaces,
                  ),
                  mapController: mapController,
                  initZoomLevel: 6.0,
                  focusCords: syriaCords,
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: legendBuilder(cityColors, state),
                ),
              ],
            );
          }
          if (state is HomeError) {
            final failure = state.errorFaliure;
            return ErrorView(
              message: failure.message,
              onRetry: () => context.read<HomeCubit>().load(),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<HomeCubit>().resetMap();
          mapController.move(syriaCords, 6.0);
        },
        child: const Icon(Icons.restart_alt),
      ),
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
  context, {
  required List<Place> places,
  required mapController,
}) {
  final Map<String, Color> cityColors = getCityColors();

  return MarkerLayer(
    markers: places.map((place) {
      final Color placeColor = cityColors[place.city] ?? Colors.grey;
      final placeLL = LatLng(place.location.latitude, place.location.longitude);

      return Marker(
        point: placeLL,
        child: GestureDetector(
          onTap: () {
            mapController.move(placeLL, 18.0);
            showModalBottomSheet(
              backgroundColor: AppColors.background,
              context: context,
              builder: (sheetContext) => Container(
                padding: EdgeInsets.only(top: AppSpacing.xs),
                height: 125,
                width: double.infinity,
                child: Column(
                  children: [
                    Text(place.city),
                    SizedBox(height: AppSpacing.sm),
                    Text(place.name, style: AppTextStyles.headlineMedium),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                        GoRouter.of(context).pushNamed(
                          RouteNames.placeDetails,
                          pathParameters: {'id': place.id},
                        );
                      },
                      child: const Text("View Details"),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Icon(Icons.location_on, color: placeColor),
        ),
      );
    }).toList(),
  );
}
