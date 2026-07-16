import 'package:app_aq_2/core/error/exceptions.dart';
import 'package:app_aq_2/core/models/trip/day_plan.dart';
import 'package:latlong2/latlong.dart';

import '../data/datasource.dart';
import '../models/map/route_info.dart';
import '../models/place/place.dart';
import '../repository/home_repository.dart';
import '../utils/location_handler.dart';

class HomeRepositoryImplementation extends HomeRepository {
  @override
  List<Place> getAllPlaces() {
    try {
      return getPlaces();
    } catch (exc) {
      throw const NetworkException(
        code: "fetch places failed",
        message: "Couldn't load places",
      );
    }
  }

  @override
  List<String> getCities() {
    try {
      return getAllCities();
    } catch (e) {
      throw const NetworkException(
        code: "fetch places failed",
        message: "Couldn't load cities",
      );
    }
  }

  @override
  List<Place>? filter(city, categories, rate) {
    final List<Place> places = getAllPlaces();

    return places.where((place) {
      if (city != null && place.city != city) {
        return false;
      }

      if (categories.isNotEmpty && !categories.contains(place.category)) {
        return false;
      }

      if (place.rating < rate) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  List<Place> search(String query) {
    if (query.trim().isEmpty) return [];
    final lower = query.toLowerCase();
    return getAllPlaces()
        .where(
          (p) =>
              p.name.toLowerCase().contains(lower) ||
              p.city.toLowerCase().contains(lower),
        )
        .toList();
  }

  @override
  List<Place>? filterNearby(userCords, maxDistanceKm, categories, minRating) {
    final Distance distance = Distance();
    return getAllPlaces().where((place) {
      if (categories.isNotEmpty && !categories.contains(place.category)) {
        return false;
      }
      if (place.rating < minRating) return false;
      final km = distance.as(
        LengthUnit.Kilometer,
        userCords,
        LatLng(place.location.latitude, place.location.longitude),
      );
      if (km > maxDistanceKm) return false;
      return true;
    }).toList();
  }

  @override
  Place getPlaceById(id) {
    try {
      return getAllPlaces().firstWhere((place) => place.id == id);
    } catch (e) {
      throw const NetworkException(
        code: "fetch places failed",
        message: "Couldn't load places",
      );
    }
  }

  @override
  List<Place> getPlacesByIds(List<String> ids) {
    final all = getAllPlaces();
    return all.where((place) => ids.contains(place.id)).toList();
  }

  @override
  Future<List<DayPlan>> suggestPlan(
    String city,
    categories,
    int days,
    LatLng startPoint,
    List<Place> planPlaces,
  ) async {
    const double maxMinutesPerDay = 360;
    final distance = const Distance();

    final remaining = List<Place>.from(planPlaces);
    final List<DayPlan> daysPlan = [];
    int dayNum = 1;

    while (remaining.isNotEmpty && dayNum <= days) {
      final dayPlaces = <Place>[];
      double totalTime = 0;
      LatLng currentPoint = startPoint;

      while (remaining.isNotEmpty) {
        Place? bestPlace;
        double bestTime = double.infinity;
        for (final p in remaining) {
          final distKm = distance.as(
            LengthUnit.Kilometer,
            currentPoint,
            LatLng(p.location.latitude, p.location.longitude),
          );
          // traveltime ( assuming 50 km/h) + visit (60‑minute)
          final timeMinutes = (distKm / 50) * 60 + 60;
          if (timeMinutes < bestTime) {
            bestTime = timeMinutes;
            bestPlace = p;
          }
        }

        if (bestPlace == null || totalTime + bestTime > maxMinutesPerDay) break;

        dayPlaces.add(bestPlace);
        remaining.remove(bestPlace);
        totalTime += bestTime;
        currentPoint = LatLng(
          bestPlace.location.latitude,
          bestPlace.location.longitude,
        );
      }

      if (dayPlaces.isNotEmpty) {
        List<LatLng> dailyRoute = [];
        LatLng routeStart = startPoint;

        for (final place in dayPlaces) {
          final destination = LatLng(
            place.location.latitude,
            place.location.longitude,
          );
          try {
            final RouteInfo? segment = await getRoute(routeStart, destination);
            if (segment != null && segment.routepoints.isNotEmpty) {
              dailyRoute.addAll(segment.routepoints);
            }
          } catch (_) {}
          routeStart = destination;
        }

        daysPlan.add(
          DayPlan(
            dayNumber: dayNum++,
            places: dayPlaces,
            routePoints: dailyRoute,
          ),
        );
      } else {
        break;
      }
    }
    return daysPlan;
  }
}
