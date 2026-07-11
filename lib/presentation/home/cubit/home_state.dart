import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/models/place.dart';
import '../../../core/models/place_categories.dart';

sealed class HomeCubitState extends Equatable {}

class HomeInitial extends HomeCubitState {
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeCubitState {
  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeCubitState {
  //
  final List<Place> places;
  final List<String> cities;
  // ------- filter
  final String filterMode;
  final int minRating;
  final Set<PlaceCategories> selectedCategories;
  // by city or by nearby
  final String? selectedCity;
  final List<Place> filteredPlaces;
  final LatLng? userLocation;
  // --
  final double maxDistanceKm;
  final List<Place> nearbyPlaces;
  final bool moveToNearby;
  //  ------
  final List<String> favoritesIndecies;

  HomeLoaded({
    required this.filteredPlaces,
    required this.nearbyPlaces,
    required this.cities,
    required this.places,
    required this.favoritesIndecies,
    this.userLocation,
    this.selectedCity = "Damascus",
    this.filterMode = "city",
    this.maxDistanceKm = 5,
    this.selectedCategories = const {},
    this.minRating = 1,
    this.moveToNearby = false,
  });

  HomeLoaded copyWith({
    List<Place>? places,
    List<Place>? filteredPlaces,
    List<Place>? nearbyPlaces,
    List<String>? favoritesIndecies,
    String? selectedCity,
    String? filterMode,
    List<String>? cities,
    Set<PlaceCategories>? selectedCategories,
    int? minRating,
    double? maxDistanceKm,
    LatLng? userLocation,
    bool? moveToNearby,
  }) {
    return HomeLoaded(
      filteredPlaces: filteredPlaces ?? this.filteredPlaces,
      places: places ?? this.places,
      cities: cities ?? this.cities,
      favoritesIndecies: favoritesIndecies ?? this.favoritesIndecies,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      minRating: minRating ?? this.minRating,
      selectedCity: selectedCity ?? this.selectedCity,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
      moveToNearby: moveToNearby ?? this.moveToNearby,
      filterMode: filterMode ?? this.filterMode,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      userLocation: userLocation ?? this.userLocation,
    );
  }

  @override
  List<Object?> get props => [
    favoritesIndecies,
    places,
    cities,
    minRating,
    selectedCity,
    filteredPlaces,
    selectedCategories,
    moveToNearby,
    nearbyPlaces,
    userLocation,
    maxDistanceKm,
    filterMode,
  ];
}
