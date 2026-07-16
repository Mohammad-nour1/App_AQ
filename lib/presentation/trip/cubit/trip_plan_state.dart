import 'package:app_aq_2/core/error/failures.dart';
import 'package:equatable/equatable.dart';

abstract class TripPlanState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TripPlanInitial extends TripPlanState {}

class TripPlanLoading extends TripPlanState {}

class TripPlanLoaded extends TripPlanState {
  final List<String> steps;

  TripPlanLoaded({required this.steps});

  @override
  List<Object?> get props => [steps];
}

class TripPlanError extends TripPlanState {
  final Failure failure;
  TripPlanError(this.failure);

  @override
  List<Object?> get props => [failure];
}
