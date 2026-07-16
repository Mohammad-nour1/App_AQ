import 'package:equatable/equatable.dart';

import '../../../../core/models/trip/trip_suggestion.dart';

abstract class TripSuggestionState extends Equatable {}

class TripSuggestionInput extends TripSuggestionState {
  // ← idle
  @override
  List<Object?> get props => [];
}

class TripSuggestionComputing extends TripSuggestionState {
  // ← generating
  @override
  List<Object?> get props => [];
}

class TripSuggestionLoaded extends TripSuggestionState {
  final TripSuggestion suggestion;
  TripSuggestionLoaded(this.suggestion);

  @override
  List<Object?> get props => [suggestion];
}

class TripSuggestionError extends TripSuggestionState {
  final String message;
  TripSuggestionError(this.message);

  @override
  List<Object?> get props => [message];
}
