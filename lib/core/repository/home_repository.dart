import 'package:app_aq_2/core/models/trip/day_plan.dart';
import 'package:latlong2/latlong.dart';

import '../models/place/place.dart';

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
  //
  Future<List<DayPlan>> suggestPlan(
    String city,
    categories,
    int days,
    LatLng startPoint,
    List<Place> planPlaces,
  );
}
