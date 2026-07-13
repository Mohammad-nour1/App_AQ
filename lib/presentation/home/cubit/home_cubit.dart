import 'package:app_aq_2/core/utils/location_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../../../core/models/place.dart';
import '../../../core/models/place_categories.dart';
import '../../../core/repository/favorites_repository.dart';
import '../../../core/repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  HomeCubit(this._homeRepository, this._favoritesRepository)
    : super(HomeInitial());

  final HomeRepository _homeRepository;
  final FavoritesRepository _favoritesRepository;

  Future<void> load() async {
    emit(HomeLoading());
    await Future.delayed(const Duration(milliseconds: 500));

    final placesList = _homeRepository.getAllPlaces();
    final cityList = _homeRepository.getCities();
    final favoritesList = _favoritesRepository.getFavoritesList();

    emit(
      HomeLoaded(
        places: placesList,
        filteredPlaces: placesList,
        cities: cityList,
        favoritesIndecies: favoritesList,
        nearbyPlacesIds: [],
      ),
    );
  }

  void resetFilterCenter() {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(moveToFilter: false));
    }
  }

  void filter({
    String? city,
    Set<PlaceCategories>? categories,
    int? minRating,
  }) {
    if (state is HomeLoaded) {
      if (city == null && categories == null && minRating == null) return;

      final current = state as HomeLoaded;

      final List<Place>? filteredList = _homeRepository.filter(
        city,
        categories,
        minRating,
      );

      emit(
        current.copyWith(
          selectedCity: city,
          selectedCategories: categories,
          minRating: minRating,
          filteredPlaces: filteredList ?? [],
          moveToFilter: true,
        ),
      );
    }
  }

  void filterByNearPlaces({
    required LatLng? userCords,
    required double maxKilos,
    Set<PlaceCategories> categories = const {},
    int minRating = 1,
  }) {
    if (state is HomeLoaded && userCords != null) {
      final current = state as HomeLoaded;
      final nearby = _homeRepository.filterNearby(
        userCords,
        maxKilos,
        categories,
        minRating,
      );

      emit(
        current.copyWith(
          selectedCategories: categories,
          minRating: minRating,
          nearbyPlacesIds: nearby!.map((place) => place.id).toList(),
          moveToNearby: true,
        ),
      );
    }
  }

  void toggleFavoriteId(String id) async {
    if (state is HomeLoaded) {
      final favList = await _favoritesRepository.toggleFavoriteId(id);
      emit((state as HomeLoaded).copyWith(favoritesIndecies: favList));
    }
  }

  void resetMap() {
    if (state is HomeLoaded) {
      final curr = state as HomeLoaded;
      emit(
        curr.copyWith(
          filterMode: 'city',
          selectedCity: 'Damascus',
          selectedCategories: {},
          minRating: 1,
          maxDistanceKm: 10,
          userLocation: null,
          isFetchingLocation: false,
          filteredPlaces: curr.places,
          moveToFilter: true,
        ),
      );
    }
  }

  void resetNearbyNavigation() {
    emit((state as HomeLoaded).copyWith(moveToNearby: false));
  }

  void setFilterMode(String mode) => emit(
    state is HomeLoaded
        ? (state as HomeLoaded).copyWith(filterMode: mode)
        : state,
  );
  void setFilterCity(String city) => emit(
    state is HomeLoaded
        ? (state as HomeLoaded).copyWith(selectedCity: city)
        : state,
  );
  void toggleFilterCategory(PlaceCategories category) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      final updatedCategories = Set<PlaceCategories>.from(
        current.selectedCategories,
      );
      if (updatedCategories.contains(category)) {
        updatedCategories.remove(category);
      } else {
        updatedCategories.add(category);
      }
      emit(current.copyWith(selectedCategories: updatedCategories));
    }
  }

  void setFilterRate(int rate) => emit(
    state is HomeLoaded
        ? (state as HomeLoaded).copyWith(minRating: rate)
        : state,
  );
  void setMaxDistance(double km) => emit(
    state is HomeLoaded
        ? (state as HomeLoaded).copyWith(maxDistanceKm: km)
        : state,
  );

  Future<void> fetchUserLocation() async {
    if (state is HomeLoaded) {
      final curr = (state as HomeLoaded);
      if (curr.userLocation != null) return;
      emit(curr.copyWith(isFetchingLocation: true));
      final LocationData? userLoc = await getUserLocation();

      if (!isClosed) {
        final newLocation = userLoc != null
            ? LatLng(userLoc.latitude!, userLoc.longitude!)
            : null;
        emit(
          curr.copyWith(userLocation: newLocation, isFetchingLocation: false),
        );
      }
    }
  }
}
