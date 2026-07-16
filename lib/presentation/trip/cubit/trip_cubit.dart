import 'package:app_aq_2/core/error/exception_mapper.dart';
import 'package:app_aq_2/core/models/place/place_categories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repository/home_repository.dart';
import 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit(this._homeRepository) : super(TripInitial());

  final HomeRepository _homeRepository;

  Future<void> loadTripSuggestions() async {
    emit(TripLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final allPlaces = _homeRepository.getAllPlaces();

      final historicalTrip = allPlaces
          .where((place) => place.category == PlaceCategories.HistoricalPlaces)
          .take(5)
          .toList();

      final naturalTrip = allPlaces
          .where((place) => place.category == PlaceCategories.NaturalViews)
          .take(5)
          .toList();

      final culturalTrip = allPlaces
          .where((place) => place.category == PlaceCategories.ReligionistPlaces)
          .take(5)
          .toList();

      emit(
        TripLoaded(
          historicalTrip: historicalTrip,
          naturalTrip: naturalTrip,
          culturalTrip: culturalTrip,
        ),
      );
    } catch (e) {
      final failure = mapExceptionToFailure(e);
      emit(TripError(failure: failure));
    }
  }
}
