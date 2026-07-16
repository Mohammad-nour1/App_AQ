// presentation/trip_suggestion/cubit/trip_suggestion_cubit.dart
import 'dart:async';
import 'package:app_aq_2/core/models/map/route_info.dart';
import 'package:app_aq_2/presentation/trip/screens/cubit/trip_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import 'package:app_aq_2/core/repository/home_repository.dart';
import 'package:app_aq_2/core/utils/location_handler.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/place/place.dart';
import '../../../../core/models/place/place_categories.dart';
import '../../../../core/models/trip/day_plan.dart';
import '../../../../core/models/trip/trip_suggestion.dart';

class TripSuggestionCubit extends Cubit<TripSuggestionState> {
  final HomeRepository _home_repo;
  TripSuggestionCubit(this._home_repo) : super(TripSuggestionInput());

  void emitLoading() {
    emit(TripSuggestionInput());
  }

  Future<void> suggest({
    required String city,
    required Set<PlaceCategories> categories,
    required int days,
  }) async {
    emit(TripSuggestionComputing());
    try {
      final planPlaces = _home_repo.filter(city, categories, 1);
      if (planPlaces == null || planPlaces.isEmpty) {
        emit(TripSuggestionError('No places found'));
        return;
      }

      final userLoc = await getUserLocation();

      // Damascus fallback
      final start = userLoc != null
          ? LatLng(userLoc.latitude!, userLoc.longitude!)
          : LatLng(33.5138, 36.2765);

      final daysPlan = await _home_repo.suggestPlan(
        city,
        categories,
        days,
        start,
        planPlaces,
      );

      emit(
        TripSuggestionLoaded(
          TripSuggestion(days: daysPlan, startLocation: start),
        ),
      );
    } catch (e) {
      emit(TripSuggestionError(e.toString()));
    }
  }
}
