import 'package:app_aq_2/core/widgets/markers_builder.dart';
import 'package:app_aq_2/presentation/nearby/cubit/nearby_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/constants/app_spacing.dart';
import 'package:app_aq_2/core/constants/app_radius.dart';
import 'package:app_aq_2/core/di/injector.dart';
import 'package:app_aq_2/core/repository/home_repository.dart';
import 'package:app_aq_2/core/utils/location_handler.dart';
import 'package:app_aq_2/core/widgets/map_builder.dart';
import 'package:app_aq_2/core/widgets/search&nearby/items_grid_builder.dart';
import '../cubit/nearby_cubit.dart';

class NearbyPlacesScreen extends StatefulWidget {
  final List<String> placeIds;
  final LatLng userCords;

  const NearbyPlacesScreen({
    super.key,
    required this.placeIds,
    required this.userCords,
  });

  @override
  State<NearbyPlacesScreen> createState() => _NearbyPlacesScreenState();
}

class _NearbyPlacesScreenState extends State<NearbyPlacesScreen> {
  final MapController mapController = MapController();
  late final NearbyCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = NearbyCubit(getIt<HomeRepository>(), userCords: widget.userCords);
    _cubit.loadPlaces(widget.placeIds);
  }

  @override
  void dispose() {
    mapController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Nearby Places'),
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
        body: BlocBuilder<NearbyCubit, NearbyState>(
          builder: (context, state) {
            if (state is NearbyLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NearbyError) {
              return Center(
                child: Text(
                  state.failure.message,
                  style: const TextStyle(color: AppColors.error),
                ),
              );
            }
            if (state is NearbyLoaded) {
              final places = state.places;
              final destination = state.destination;
              final routeInfo = state.routeInfo;
              final isRouteLoading = state.isRouteLoading;

              final screenHeight = MediaQuery.of(context).size.height;
              final bottomPadding = MediaQuery.of(context).padding.bottom;
              final navBarHeight = kBottomNavigationBarHeight;
              final availableHeight =
                  screenHeight - bottomPadding - navBarHeight;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  children: [
                    if (destination != null && routeInfo != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: availableHeight * 0.35,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            color: AppColors.surface,
                          ),
                          child: mapBuilder(
                            markerLayerBuilder: () => MarkerLayer(
                              markers: [
                                MarkersBuilder.userMarker(widget.userCords),
                                MarkersBuilder.locationMarker(destination),
                              ],
                            ),
                            mapController: mapController,
                            polyLayerBuilder: () => PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: routeInfo.routepoints,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                            focusCords: getMiddleCords(
                              widget.userCords,
                              destination,
                            ),
                            initZoomLevel: 11.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    if (isRouteLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: LinearProgressIndicator(),
                      ),
                    itemsGridBuilder(
                      10.0,
                      places,
                      context,
                      onShowOnMap: (place) {
                        final location = LatLng(
                          place.location.latitude,
                          place.location.longitude,
                        );
                        final prevDest = (_cubit.state is NearbyLoaded)
                            ? (_cubit.state as NearbyLoaded).destination
                            : null;

                        _cubit.setDestination(location);

                        if (prevDest != null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            mapController.move(
                              getMiddleCords(widget.userCords, location),
                              12.0,
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
