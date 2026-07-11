import 'package:app_aq_2/core/constants/keys.dart';
import 'package:app_aq_2/core/router/router.dart';
import 'package:app_aq_2/core/theme/theme.dart';
import 'package:app_aq_2/core/widgets/loading_indicator.dart';
import 'package:app_aq_2/presentation/home/cubit/home_state.dart';

import 'package:app_aq_2/presentation/home/screens/widgets/map_builder.dart';
import 'package:app_aq_2/presentation/search/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:flutter_scalify/responsive_scale/responsive_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/data/datasource.dart';
import '../../../core/models/place.dart';
import '../../../core/widgets/error_view.dart';
import '../cubit/home_cubit.dart';
import 'widgets/map_legend_builder.dart';

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
            icon: Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: () => GoRouter.of(context).push(RoutePaths.search),
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeCubitState>(
        builder: (builderContext, state) {
          if (state is HomeLoading) {
            return LoadingIndicator();
          }
          if (state is HomeLoaded) {
            final isEmpty = state.filteredPlaces.isEmpty;

            if (isEmpty) {
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
          // TODO
          return ErrorView(message: "something went wrong", onRetry: () {});
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<HomeCubit>().resetMap();
          mapController.move(syriaCords, 6.0);
        },
        child: Icon(Icons.restart_alt),
      ),
    );
  }
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
                height: 120.h,
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
                      child: Text("View Details"),
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
