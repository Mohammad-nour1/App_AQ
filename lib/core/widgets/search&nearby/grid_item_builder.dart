import 'package:app_aq_2/core/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scalify/responsive_scale/responsive_extensions.dart';

import 'package:app_aq_2/presentation/home/cubit/home_cubit.dart';
import 'package:app_aq_2/presentation/home/cubit/home_state.dart';

import '../../models/place.dart';

itemBuilder(Place place, VoidCallback setDestination) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth.isFinite && constraints.maxWidth > 0
          ? constraints.maxWidth
          : MediaQuery.of(context).size.width * 0.45;

      final imageHeight = width * 0.5;

      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: 14.br,
          side: BorderSide(color: Colors.white24.withValues(alpha: 0.12)),
        ),
        clipBehavior: Clip.antiAlias,
        color: Colors.white.withValues(alpha: 0.04),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: imageHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      place.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surface,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.broken_image,
                              color: Colors.white54,
                              size: 28,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Image not available",
                              style: TextStyle(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<HomeCubit, HomeCubitState>(
                      builder: (context, state) {
                        final isFav =
                            state is HomeLoaded &&
                            state.favoritesIndecies.contains(place.id);
                        return InkWell(
                          onTap: () => context
                              .read<HomeCubit>()
                              .toggleFavoriteId(place.id),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.surface.withValues(alpha: 0.28),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? AppColors.error : AppColors.white,
                              size: 18,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.city,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    place.name,
                    style: AppTextStyles.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: setDestination,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.black,
                            elevation: 4,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Show on Map',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
