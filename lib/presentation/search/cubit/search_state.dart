import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/models/place/place.dart';

sealed class SearchState extends Equatable {}

class SearchInitial extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchLoading extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchLoaded extends SearchState {
  final List<Place> places;
  final LatLng? destination;

  SearchLoaded({required this.places, required this.destination});

  SearchLoaded copyWith({
    List<Place>? places,
    LatLng? destination,
    double? initialZoom,
  }) {
    return SearchLoaded(
      places: places ?? this.places,
      destination: destination ?? this.destination,
    );
  }

  @override
  List<Object?> get props => [places, destination];
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
