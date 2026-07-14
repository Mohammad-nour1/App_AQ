import 'package:app_aq_2/core/widgets/search&nearby/grid_item_builder.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../models/place.dart';

GridView itemsGridBuilder(
  double spacing,
  List<Place> places,
  BuildContext context, {
  required void Function(LatLng des) showOnMap,
}) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      // crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: 0.7,
      maxCrossAxisExtent: 243,
    ),
    itemCount: places.length,
    itemBuilder: (_, index) {
      final place = places[index];
      return itemBuilder(
        place,
        () => showOnMap(
          LatLng(place.location.latitude, place.location.longitude),
        ),
      );
    },
  );
}
