import 'package:latlong2/latlong.dart';

class RouteInfo {
  final List<LatLng> routepoints;
  final double distance;
  final double duration;

  RouteInfo({
    required this.routepoints,
    required this.distance,
    required this.duration,
  });
}
