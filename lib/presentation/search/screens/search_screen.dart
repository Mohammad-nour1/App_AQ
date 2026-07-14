import 'package:app_aq_2/core/constants/constants.dart';
import 'package:app_aq_2/core/di/injector.dart';
import 'package:app_aq_2/core/extensions/extensions.dart';
import 'package:app_aq_2/core/widgets/app_text_field.dart';
import 'package:app_aq_2/core/widgets/search&nearby/items_grid_builder.dart';
import 'package:app_aq_2/core/widgets/map_builder.dart';
import 'package:app_aq_2/presentation/search/cubit/search_cubit.dart';
import 'package:app_aq_2/presentation/search/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_scalify/responsive_scale/responsive_extensions.dart';
import 'package:latlong2/latlong.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  MapController mapController = MapController();

  LatLng? _pendingMove;

  @override
  void dispose() {
    _searchController.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(getIt.get()),
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsetsGeometry.all(AppSpacing.xs),
                child: Column(
                  children: [
                    AppTextField(
                      controller: _searchController,
                      onChanged: (value) =>
                          context.read<SearchCubit>().search(value),
                      suffixIcon: Icon(Icons.search_rounded),
                      hint: "Search",
                    ),
                    if (state is SearchLoaded && state.destination != null) ...[
                      SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: context.screenHeight * 25 / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            color: Colors.transparent,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: BlocListener<SearchCubit, SearchState>(
                            listenWhen: (previous, current) {
                              final prevDest = previous is SearchLoaded
                                  ? previous.destination
                                  : null;
                              final currDest = current is SearchLoaded
                                  ? current.destination
                                  : null;
                              return currDest != null && currDest != prevDest;
                            },
                            listener: (context, state) {
                              final destination =
                                  (state as SearchLoaded).destination!;

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                mapController.move(destination, 12.0);
                              });
                            },
                            child: mapBuilder(
                              onMapReady: () {
                                if (_pendingMove != null) {
                                  mapController.move(_pendingMove!, 12.0);
                                  _pendingMove = null;
                                }
                              },
                              markerLayerBuilder: () =>
                                  markerLayerBuilder(state.destination!),
                              mapController: mapController,
                              focusCords: LatLng(
                                state.destination!.latitude,
                                state.destination!.longitude,
                              ),
                              initZoomLevel: 13.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (state is SearchLoaded) ...[
                      ...[
                        SizedBox(height: AppSpacing.sm),
                        state.places.isEmpty
                            ? Center(child: Text("No Results Found"))
                            : Expanded(
                                child: itemsGridBuilder(
                                  10.0,
                                  state.places,
                                  context,
                                  showOnMap: (latLng) {
                                    final cubit = context.read<SearchCubit>();
                                    final wasMapOpen =
                                        (cubit.state is SearchLoaded) &&
                                        (cubit.state as SearchLoaded)
                                                .destination !=
                                            null;
                                    cubit.setDestination(latLng);

                                    if (wasMapOpen) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            mapController.move(latLng, 12.0);
                                          });
                                    } else {
                                      _pendingMove = latLng;
                                    }
                                  },
                                ),
                              ),
                      ],
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  MarkerLayer markerLayerBuilder(LatLng destinationCords) {
    return MarkerLayer(
      markers: [
        Marker(
          point: destinationCords,
          child: Icon(Icons.location_on, color: Colors.blue),
        ),
      ],
    );
  }
}
