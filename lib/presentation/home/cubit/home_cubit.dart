import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
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
        nearbyPlaces: [],
      ),
    );
  }

  void applyFilter() {
    if (state is HomeLoaded) {
      final curr = state as HomeLoaded;
      if (curr.filterMode == 'city') {
        _filter(
          city: curr.selectedCity,
          categories: curr.selectedCategories,
          minRating: curr.minRating,
        );
      } else {
        _filterByNearPlaces(
          userCords: curr.userLocation,
          maxKilos: curr.maxDistanceKm,
          categories: curr.selectedCategories,
          rate: curr.minRating,
        );
      }
    }
  }

  void _filter({
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
        ),
      );
    }
  }

  void _filterByNearPlaces({
    required LatLng? userCords,
    required double maxKilos,
    Set<PlaceCategories> categories = const {},
    int rate = 1,
  }) {
    if (state is HomeLoaded && userCords != null) {
      final current = state as HomeLoaded;
      final nearby = _homeRepository.filterNearby(
        userCords,
        maxKilos,
        categories,
        rate,
      );
      emit(
        current.copyWith(
          nearbyPlaces: nearby,
          moveToNearby: true,
          // Optionally keep the map's filteredPlaces unchanged?
          // Usually you'd leave the map as it was, but you can also set filteredPlaces to nearby.
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
      final curr = (state as HomeLoaded);
      emit(curr.copyWith(places: curr.places, filteredPlaces: curr.places));
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

  //  Future<void> _fetchUserLocation() async {
  //     setState(() => _isFetchingLocation = true);
  //     final loc = await getUserLocation();
  //     if (!mounted) return;
  //     setState(() {
  //       if (loc != null) {
  //         _userLocation = LatLng(loc.latitude!, loc.longitude!);
  //       }
  //       _isFetchingLocation = false;
  //     });
  //   }
}
