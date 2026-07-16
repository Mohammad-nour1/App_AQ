import 'package:equatable/equatable.dart';
import 'package:app_aq_2/core/error/failures.dart';
import '../../../core/models/place.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<Place> favoritePlaces;

  const FavoritesLoaded({required this.favoritePlaces});

  @override
  List<Object?> get props => [favoritePlaces];
}

class FavoritesError extends FavoritesState {
  final Failure failure;

  const FavoritesError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
