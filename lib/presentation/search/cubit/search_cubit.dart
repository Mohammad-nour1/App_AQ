import 'dart:async';

import 'package:app_aq_2/presentation/search/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/models/place.dart';
import '../../../core/repository/home_repository.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._homeRepository) : super(SearchInitial());

  final HomeRepository _homeRepository;

  Timer? _debounce;

  void search(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    _debounce = Timer(Duration(milliseconds: 300), () async {
      try {
        await Future.delayed(const Duration(milliseconds: 200));
        final List<Place> searchResults = _homeRepository.search(query);
        emit(SearchLoaded(places: searchResults, destination: null));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }

  void setDestination(destinationCords) {
    if (state is SearchLoaded) {
      emit(
        (state as SearchLoaded).copyWith(
          destination: LatLng(
            destinationCords.latitude,
            destinationCords.longitude,
          ),
          initialZoom: 12.0,
        ),
      );
    }
  }
}
