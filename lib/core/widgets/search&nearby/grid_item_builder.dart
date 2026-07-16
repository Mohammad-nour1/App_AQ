import 'package:app_aq_2/core/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_scalify/responsive_scale/responsive_extensions.dart';

import '../../models/place/place.dart';

itemBuilder(Place place, VoidCallback setDestination) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: 20.br,
      side: BorderSide(color: Colors.white24.withValues(alpha: 0.24)),
    ),
    clipBehavior: Clip.antiAlias,
    color: Colors.white.withValues(alpha: 0.1),

    child: Column(
      children: [
        Image.asset(
          place.image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image, color: Colors.white54),
                const Text(
                  "Image not available",
                  style: TextStyle(color: AppColors.error),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5.h),

        Text(place.city),
        SizedBox(height: 5.h),
        Text(place.name),
        SizedBox(height: 5.h),
        TextButton(onPressed: setDestination, child: Text("Show On Map")),
      ],
    ),
  );
}
