import 'package:app_aq_2/core/error/failures.dart';
import 'package:app_aq_2/core/models/map/route_info.dart';
import 'package:app_aq_2/core/models/place/place.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

abstract class NearbyState extends Equatable {}

class NearbyLoading extends NearbyState {
  @override
  List<Object?> get props => [];
}

class NearbyLoaded extends NearbyState {
  final List<Place> places;
  final LatLng? destination; // null until user taps "Show on Map"
  final RouteInfo? routeInfo; // null until route is fetched
  final bool isRouteLoading; // true while fetching the route

  NearbyLoaded({
    required this.places,
    this.destination,
    this.routeInfo,
    this.isRouteLoading = false,
  });

  NearbyLoaded copyWith({
    List<Place>? places,
    LatLng? destination,
    RouteInfo? routeInfo,
    bool? isRouteLoading,
    bool clearDestination = false,
    bool clearRoute = false,
  }) {
    return NearbyLoaded(
      places: places ?? this.places,
      destination: clearDestination ? null : (destination ?? this.destination),
      routeInfo: clearRoute ? null : (routeInfo ?? this.routeInfo),
      isRouteLoading: isRouteLoading ?? this.isRouteLoading,
    );
  }

  @override
  List<Object?> get props => [places, destination, routeInfo, isRouteLoading];
}

class NearbyError extends NearbyState {
  final Failure failure;
  NearbyError(this.failure);

  @override
  List<Object?> get props => [failure];
}
