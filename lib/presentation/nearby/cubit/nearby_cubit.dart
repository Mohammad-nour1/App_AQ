// nearby_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:app_aq_2/core/models/route_info.dart';
import 'package:app_aq_2/core/repository/home_repository.dart';
import 'package:app_aq_2/core/utils/location_handler.dart';

import 'nearby_state.dart';
import 'package:app_aq_2/core/error/exception_mapper.dart';
import 'package:app_aq_2/core/error/failures.dart';

class NearbyCubit extends Cubit<NearbyState> {
  final HomeRepository _repo;
  final LatLng _userCords;

  NearbyCubit(this._repo, {required LatLng userCords})
    : _userCords = userCords,
      super(NearbyLoading());

  Future<void> loadPlaces(List<String> placeIds) async {
    if (placeIds.isEmpty) {
      emit(
        NearbyError(
          ValidationFailure(code: 'no-data', message: 'No places found'),
        ),
      );
      return;
    }
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final places = _repo.getPlacesByIds(placeIds);

      if (places.isEmpty) {
        emit(
          NearbyError(
            ValidationFailure(code: 'no-data', message: 'No places found'),
          ),
        );
      } else {
        emit(NearbyLoaded(places: places));
      }
    } catch (e) {
      final failure = mapExceptionToFailure(e);
      emit(NearbyError(failure));
    }
  }

  Future<void> setDestination(LatLng location) async {
    if (state is! NearbyLoaded) return;

    // Set loading & destination immediately
    emit(
      (state as NearbyLoaded).copyWith(
        isRouteLoading: true,
        destination: location,
      ),
    );

    try {
      final route = await getRoute(_userCords, location);

      // After the await, READ THE LATEST STATE again – never use a stale variable
      if (state is NearbyLoaded) {
        emit(
          (state as NearbyLoaded).copyWith(
            destination: location,
            routeInfo:
                route ?? RouteInfo(routepoints: [], distance: 0, duration: 0),
            isRouteLoading: false,
          ),
        );
      }
    } catch (e) {
      if (state is NearbyLoaded) {
        emit(
          (state as NearbyLoaded).copyWith(
            destination: location,
            routeInfo: RouteInfo(
              routepoints: [],
              distance: 0,
              duration: 0,
            ), // empty but NOT null
            isRouteLoading: false,
          ),
        );
      }
    }
  }
}
