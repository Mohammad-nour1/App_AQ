import 'dart:async';

import 'package:app_aq_2/core/models/map/route_info.dart';
import 'package:app_aq_2/core/models/place/place.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import 'package:app_aq_2/core/repository/home_repository.dart';
import 'package:app_aq_2/core/utils/location_handler.dart';

import '../../../core/error/failures.dart';
import 'place_details_state.dart';

class PlaceDetailCubit extends Cubit<PlaceDetailState> {
  final HomeRepository _repo;

  PlaceDetailCubit(this._repo, String placeId)
      : super(PlaceDetailLoading()) {
    _load(placeId);
  }

  Future<void> _load(String placeId) async {
    try {
      // 1. Load the place
      await Future<dynamic>.delayed(
        const Duration(milliseconds: 300),
      );

      final Place? place = _repo.getPlaceById(placeId);

      if (place == null) {
        emit(
          PlaceDetailError(
            CacheFailure(
              code: 'not-found',
              message: 'Place not found',
            ),
          ),
        );
        return;
      }

      emit(
        PlaceDetailLoaded(
          place: place,
        ),
      );

      final location = await getUserLocation();

      RouteInfo? routeInfo;

      if (location != null) {
        routeInfo = await getRoute(
          LatLng(
            location.latitude!,
            location.longitude!,
          ),
          LatLng(
            place.location.latitude,
            place.location.longitude,
          ),
        );
      }

      if (isClosed) return;

      emit(
        PlaceDetailLoaded(
          place: place,
          routeInfo: routeInfo ??
              RouteInfo(
                routepoints: [],
                distance: 0,
                duration: 0,
              ),
          userLocation: location,
        ),
      );
    } catch (e) {
      emit(
        PlaceDetailError(
          UnknownFailure(),
        ),
      );
    }
  }
}