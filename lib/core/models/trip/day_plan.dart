import 'dart:ui';

import 'package:latlong2/latlong.dart';

import '../place/place.dart';

class DayPlan {
  final int dayNumber;
  final List<Place> places;
  final List<LatLng> routePoints;

  const DayPlan({
    required this.dayNumber,
    required this.places,

    required this.routePoints,
  });
}
