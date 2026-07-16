import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repository/favorites_repository.dart';
import '../../../core/repository/home_repository.dart';
import 'package:app_aq_2/core/error/exception_mapper.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._favoritesRepository, this._homeRepository)
    : super(FavoritesInitial());

  final FavoritesRepository _favoritesRepository;
  final HomeRepository _homeRepository;

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final favoritesIds = _favoritesRepository.getFavoritesList();
      final allPlaces = _homeRepository.getAllPlaces();
      final favoritePlaces = allPlaces
          .where((place) => favoritesIds.contains(place.id))
          .toList();

      emit(FavoritesLoaded(favoritePlaces: favoritePlaces));
    } catch (e) {
      final failure = mapExceptionToFailure(e);
      emit(FavoritesError(failure: failure));
    }
  }

  Future<void> toggleFavorite(String placeId) async {
    if (state is FavoritesLoaded) {
      try {
        await _favoritesRepository.toggleFavoriteId(placeId);

        final favoritesIds = _favoritesRepository.getFavoritesList();
        final allPlaces = _homeRepository.getAllPlaces();
        final favoritePlaces = allPlaces
            .where((place) => favoritesIds.contains(place.id))
            .toList();

        emit(FavoritesLoaded(favoritePlaces: favoritePlaces));
      } catch (e) {
        final failure = mapExceptionToFailure(e);
        emit(FavoritesError(failure: failure));
      }
    }
  }
}
