import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/constants/app_radius.dart';
import 'package:app_aq_2/core/models/place/place_categories.dart';
import 'package:app_aq_2/core/router/router.dart';
import 'package:app_aq_2/core/theme/theme.dart';
import 'package:app_aq_2/core/widgets/error_view.dart';
import 'package:app_aq_2/presentation/home/cubit/home_cubit.dart';
import 'package:app_aq_2/presentation/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.watch<HomeCubit>();
    final state = homeCubit.state;

    if (state is! HomeLoaded) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Filter'),
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
        body: ErrorView(message: "Something Went Wrong", onRetry: () {}),
      );
    }

    final cities = state.cities;
    final filterMode = state.filterMode;
    final isFetching = state.isFetchingLocation;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Filter'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Filter By', style: AppTextStyles.headlineMedium),
                      const SizedBox(height: AppSpacing.xs),

                      filterModeBuilder(filterMode, homeCubit),
                      const SizedBox(height: AppSpacing.sm),

                      if (filterMode == 'city')
                        Row(
                          children: [
                            Text('City', style: AppTextStyles.headlineMedium),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: DropdownMenu<String>(
                                inputDecorationTheme: InputDecorationTheme(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.sm,
                                    ),
                                  ),
                                ),
                                initialSelection: state.selectedCity,
                                dropdownMenuEntries: cities
                                    .map(
                                      (city) => DropdownMenuEntry(
                                        value: city,
                                        label: city,
                                      ),
                                    )
                                    .toList(),
                                onSelected: (selectedCity) {
                                  if (selectedCity != null)
                                    homeCubit.setFilterCity(selectedCity);
                                },
                              ),
                            ),
                          ],
                        ),

                      if (filterMode == 'nearby') ...[
                        if (isFetching)
                          const LinearProgressIndicator()
                        else ...[
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Text(
                                'Max distance',
                                style: AppTextStyles.headlineMedium,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: DropdownMenu<double>(
                                  initialSelection: state.maxDistanceKm,
                                  dropdownMenuEntries:
                                      [5.0, 10.0, 15.0, 20.0, 50.0]
                                          .map(
                                            (d) => DropdownMenuEntry(
                                              value: d,
                                              label: '${d.toInt()} km',
                                            ),
                                          )
                                          .toList(),
                                  onSelected: (maxDistanse) {
                                    if (maxDistanse != null)
                                      homeCubit.setMaxDistance(maxDistanse);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],

                      const SizedBox(height: AppSpacing.sm),

                      Text('Category', style: AppTextStyles.headlineMedium),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xxs,
                        children: PlaceCategories.values.map((category) {
                          final checked = state.selectedCategories.contains(
                            category,
                          );
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.xxs,
                                  ),
                                ),
                                activeColor: Colors.cyan,
                                value: checked,
                                onChanged: (_) =>
                                    homeCubit.toggleFilterCategory(category),
                              ),
                              const SizedBox(width: AppSpacing.xxs),
                              Text(
                                category.label,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // ── Rating ──
                      Row(
                        children: [
                          Text('Rate', style: AppTextStyles.headlineMedium),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: DropdownMenu<int>(
                              inputDecorationTheme: InputDecorationTheme(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.white,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.sm,
                                  ),
                                ),
                              ),
                              menuStyle: MenuStyle(),
                              initialSelection: state.minRating,
                              dropdownMenuEntries: [1, 2, 3, 4, 5]
                                  .map(
                                    (r) => DropdownMenuEntry(
                                      value: r,
                                      label: r.toString(),
                                    ),
                                  )
                                  .toList(),
                              onSelected: (rate) {
                                if (rate != null) homeCubit.setFilterRate(rate);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
              BlocListener<HomeCubit, HomeCubitState>(
                listenWhen: (_, current) =>
                    current is HomeLoaded && current.moveToNearby,
                listener: (context, currentState) {
                  final loaded = currentState as HomeLoaded;

                  homeCubit.resetNearbyNavigation();
                  GoRouter.of(context).push(
                    RoutePaths.nearbyPlaces,
                    extra: {
                      "userCords": loaded.userLocation,
                      "placeIds": loaded.nearbyPlacesIds,
                    },
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed:
                        (filterMode == 'nearby' && state.userLocation == null)
                        ? null
                        : () {
                            if (filterMode == 'nearby') {
                              homeCubit.filterByNearPlaces(
                                categories: state.selectedCategories,
                                minRating: state.minRating,
                                maxKilos: state.maxDistanceKm,
                                userCords: state.userLocation,
                              );
                            } else {
                              homeCubit.filter(
                                city: state.selectedCity,

                                categories: state.selectedCategories,
                                minRating: state.minRating,
                              );
                            }
                            if (filterMode == 'city') {
                              GoRouter.of(context).pop();
                            }
                          },
                    child: const Text('Filter'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row filterModeBuilder(String filterMode, HomeCubit homeCubit) {
    return Row(
      children: [
        Radio<String>(
          value: 'city',
          groupValue: filterMode,
          onChanged: (mode) => homeCubit.setFilterMode(mode!),
          activeColor: Colors.cyan,
        ),
        Text('City', style: AppTextStyles.bodyMedium),
        const SizedBox(width: AppSpacing.sm),
        Radio<String>(
          value: 'nearby',
          groupValue: filterMode,
          onChanged: (mode) async {
            homeCubit.setFilterMode(mode!);
            if (mode == 'nearby') await homeCubit.fetchUserLocation();
          },
          activeColor: Colors.cyan,
        ),
        Text('Nearby', style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
