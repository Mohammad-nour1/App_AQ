import 'package:app_aq_2/core/error/failures.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/models/place/place.dart';
import '../../../core/models/place/place_categories.dart';

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
  static const Object _noChange = Object();
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
  final bool moveToFilter;
  // --
  final double maxDistanceKm;
  final List<String> nearbyPlacesIds;
  final bool moveToNearby;
  final bool isFetchingLocation;
  //  ------
  final List<String> favoritesIndecies;
  // pending target from other screens
  final String? pendingTargetPlaceId;

  HomeLoaded({
    required this.filteredPlaces,
    required this.nearbyPlacesIds,
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
    this.moveToFilter = false,
    this.isFetchingLocation = false,
    this.pendingTargetPlaceId,
  });

  HomeLoaded copyWith({
    List<Place>? places,
    List<Place>? filteredPlaces,
    List<String>? nearbyPlacesIds,
    List<String>? favoritesIndecies,
    String? selectedCity,
    String? filterMode,
    List<String>? cities,
    Set<PlaceCategories>? selectedCategories,
    int? minRating,
    double? maxDistanceKm,
    LatLng? userLocation,
    bool? moveToNearby,
    bool? moveToFilter,
    bool? isFetchingLocation,
    Object? pendingTargetPlaceId = _noChange,
  }) {
    return HomeLoaded(
      filteredPlaces: filteredPlaces ?? this.filteredPlaces,
      places: places ?? this.places,
      cities: cities ?? this.cities,
      favoritesIndecies: favoritesIndecies ?? this.favoritesIndecies,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      minRating: minRating ?? this.minRating,
      selectedCity: selectedCity ?? this.selectedCity,
      nearbyPlacesIds: nearbyPlacesIds ?? this.nearbyPlacesIds,
      moveToNearby: moveToNearby ?? this.moveToNearby,
      filterMode: filterMode ?? this.filterMode,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      userLocation: userLocation ?? this.userLocation,
      isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
      moveToFilter: moveToFilter ?? this.moveToFilter,
      pendingTargetPlaceId: identical(pendingTargetPlaceId, _noChange)
          ? this.pendingTargetPlaceId
          : pendingTargetPlaceId as String?,
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
    nearbyPlacesIds,
    userLocation,
    maxDistanceKm,
    filterMode,
    isFetchingLocation,
    moveToFilter,
    pendingTargetPlaceId,
  ];
}

class HomeError extends HomeCubitState {
  HomeError(this.errorFaliure);
  final Failure errorFaliure;

  @override
  List<Object?> get props => [errorFaliure];
}
