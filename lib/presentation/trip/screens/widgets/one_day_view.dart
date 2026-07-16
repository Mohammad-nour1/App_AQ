import 'package:app_aq_2/core/models/place/place.dart';
import 'package:app_aq_2/core/models/trip/day_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/map_builder.dart';

Widget buildDayView(context, DayPlan day) {
  final places = day.places;
  if (places.isEmpty)
    return const Center(child: Text('No places for this day.'));

  return Padding(
    padding: const EdgeInsets.all(AppSpacing.sm),
    child: Column(
      children: [
        SizedBox(
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: mapBuilder(
              focusCords: LatLng(
                places.first.location.latitude,
                places.first.location.longitude,
              ),
              initZoomLevel: 8,
              mapController: MapController(),
              markerLayerBuilder: () => MarkerLayer(
                markers: places.asMap().entries.map((e) {
                  final index = e.key + 1;
                  return Marker(
                    point: LatLng(
                      e.value.location.latitude,
                      e.value.location.longitude,
                    ),
                    width: 36,
                    height: 36,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              polyLayerBuilder: (day.routePoints.isNotEmpty)
                  ? () => PolylineLayer(
                      polylines: [
                        Polyline(
                          points: day.routePoints,
                          color: Colors.blue,
                          strokeWidth: 4.0,
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(child: placesListBuilder(places, context)),
      ],
    ),
  );
}

ListView placesListBuilder(List<Place> places, context) {
  return ListView.separated(
    itemCount: places.length,
    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
    itemBuilder: (_, i) {
      final place = places[i];
      return Card(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.accent,
            child: Text(
              '${i + 1}',
              style: const TextStyle(color: AppColors.white),
            ),
          ),
          title: Text(place.name, style: AppTextStyles.titleMedium),
          subtitle: Text(place.city, style: AppTextStyles.bodySmall),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
          onTap: () {
            GoRouter.of(context).pushNamed(
              RouteNames.placeDetails,
              pathParameters: {'id': place.id},
            );
          },
        ),
      );
    },
  );
}
