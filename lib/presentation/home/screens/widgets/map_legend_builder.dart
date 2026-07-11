import 'package:flutter/material.dart';
import 'package:flutter_scalify/responsive_scale/responsive_extensions.dart';

import '../../cubit/home_state.dart';

Container legendBuilder(Map<String, Color> cityColors, HomeLoaded state) {
  final visibleCities = state.filteredPlaces.map((p) => p.city).toSet();

  return Container(
    decoration: BoxDecoration(borderRadius: 15.br, color: Colors.black54),

    padding: 8.p,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: visibleCities.map((visibleCity) {
        final city = visibleCity;
        final cityColor = cityColors[visibleCity] ?? Colors.grey;
        return Row(
          children: [
            Container(
              width: 10.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: cityColor,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            SizedBox(width: 10.w),
            Text(city),
          ],
        );
      }).toList(),
    ),
  );
}
