import 'package:app_aq_2/core/widgets/search&nearby/grid_item_builder.dart';
import 'package:flutter/material.dart';

import '../../models/place/place.dart';

GridView itemsGridBuilder(
  double spacing,
  List<Place> places,
  BuildContext context, {
  required void Function(Place place) onShowOnMap,
}) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: 0.82,
      maxCrossAxisExtent: 243,
    ),
    itemCount: places.length,
    itemBuilder: (_, index) {
      final place = places[index];
      return itemBuilder(
        place,
        () => onShowOnMap(place),
      );
    },
  );
}
