import 'package:app_aq_2/core/models/route_info.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

import '../../../core/error/failures.dart';
import '../../../core/models/place.dart';

abstract class PlaceDetailState extends Equatable {}

class PlaceDetailLoading extends PlaceDetailState {
  @override
  List<Object?> get props => [];
}

class PlaceDetailLoaded extends PlaceDetailState {
  final LocationData? userLocation;
  final RouteInfo? routeInfo;
  final Place place;
  PlaceDetailLoaded({required this.place, this.routeInfo, this.userLocation});
  @override
  List<Object?> get props => [place, userLocation, routeInfo];
}

class PlaceDetailError extends PlaceDetailState {
  final Failure failure;
  PlaceDetailError(this.failure);
  @override
  List<Object?> get props => [failure];
}
