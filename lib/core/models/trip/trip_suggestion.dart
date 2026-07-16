import 'package:latlong2/latlong.dart';
import 'day_plan.dart';

class TripSuggestion {
  final List<DayPlan> days;
  final LatLng? startLocation;
  const TripSuggestion({required this.days, this.startLocation});
}
