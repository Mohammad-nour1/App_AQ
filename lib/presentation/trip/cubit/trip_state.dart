import 'package:app_aq_2/core/error/failures.dart';
import 'package:app_aq_2/core/models/place/place.dart';
import 'package:equatable/equatable.dart';

abstract class TripState extends Equatable {
  const TripState();

  @override
  List<Object?> get props => [];
}

class TripInitial extends TripState {
  const TripInitial();
}

class TripLoading extends TripState {
  const TripLoading();
}

class TripLoaded extends TripState {
  final List<Place> historicalTrip;
  final List<Place> naturalTrip;
  final List<Place> culturalTrip;

  const TripLoaded({
    required this.historicalTrip,
    required this.naturalTrip,
    required this.culturalTrip,
  });

  @override
  List<Object?> get props => [historicalTrip, naturalTrip, culturalTrip];
}

class TripError extends TripState {
  final Failure failure;

  const TripError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
