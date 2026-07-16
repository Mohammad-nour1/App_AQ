import 'package:flutter/material.dart';
import 'package:flutter_scalify/responsive_scale/responsive_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../cubit/home_state.dart';

Widget legendBuilder(Map<String, Color> cityColors, HomeLoaded state) {
  final visibleCities = state.filteredPlaces.map((p) => p.city).toSet().toList()
    ..sort();

  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 160, maxHeight: 220),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: 15.br,
        color: AppColors.surfaceElevated.withValues(alpha: 0.88),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.35)),
      ),
      padding: 10.p,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cities',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11.fz,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            ...visibleCities.map((city) {
              final cityColor = cityColors[city] ?? Colors.grey;
              return Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: cityColor,
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        city,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12.fz,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    ),
  );
}
