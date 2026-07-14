import '../models/place.dart';

abstract class HomeRepository {
  //
  List<Place> getAllPlaces();
  List<String> getCities();

  //
  Place getPlaceById(String id);
  List<Place> getPlacesByIds(List<String> ids);
  //
  List<Place>? filter(city, categories, rate);
  List<Place>? filterNearby(userCords, maxDistanceKm, categories, minRating);
  //
  List<Place> search(String query);
}
