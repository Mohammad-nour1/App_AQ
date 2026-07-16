import 'dart:convert';

import 'package:app_aq_2/core/constants/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../models/route_info.dart';

Future<LocationData?> getUserLocation() async {
  try {
    final location = Location();
    return await location.getLocation();
  } on Exception {
    return null;
  }
}

Future<RouteInfo?> getRoute(LatLng? source, LatLng destination) async {
  if (source == null) return null;

  final start = LatLng(source.latitude, source.longitude);
  final response = await http.get(
    Uri.parse(
      'https://api.openrouteservice.org/v2/directions/driving-car?api_key=${MapConstants.orsApiKey}&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}',
    ),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final summary = data['features'][0]['properties']['summary'];
    final distance = summary['distance'];
    final duration = summary['duration'];
    final List<dynamic> coords = data['features'][0]['geometry']['coordinates'];

    final List<LatLng> routePoints = coords
        .map((coord) => LatLng(coord[1], coord[0]))
        .toList();
    return RouteInfo(
      distance: distance,
      duration: duration,
      routepoints: routePoints,
    );
  } else {
    // Handle errors
    debugPrint('Failed to fetch route');
  }
  return null;
}

LatLng getMiddleCords(LatLng first, LatLng second) {
  return LatLng(
    (first.latitude + second.latitude) / 2,
    (first.longitude + second.longitude) / 2,
  );
}
