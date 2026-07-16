import 'package:latlong2/latlong.dart';
import '../error/exceptions.dart';

import '../data/datasource.dart';
import '../models/place.dart';
import '../repository/home_repository.dart';

class HomeRepositoryImplementation extends HomeRepository {
  @override
  List<Place> getAllPlaces() {
    return getPlaces();
  }

  @override
  List<String> getCities() {
    return getAllCities();
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
    return getAllPlaces().firstWhere(
      (place) => place.id == id,
      orElse: () => throw CacheException(
        code: 'not-found',
        message: 'Place with id $id was not found',
      ),
    );
  }

  @override
  List<Place> getPlacesByIds(List<String> ids) {
    final all = getAllPlaces();
    return all.where((place) => ids.contains(place.id)).toList();
  }
}
