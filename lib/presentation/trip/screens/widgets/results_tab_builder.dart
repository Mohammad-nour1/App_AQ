import 'package:app_aq_2/presentation/trip/screens/widgets/one_day_view.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/trip/trip_suggestion.dart';
import '../../../../core/theme/theme.dart';
import '../cubit/trip_cubit.dart';

Widget buildResults(
  context,
  TripSuggestion suggestion,
  TripSuggestionCubit cubit,
) {
  final days = suggestion.days;
  if (days.isEmpty) {
    return const Center(child: Text('No places found for this plan.'));
  }

  return DefaultTabController(
    length: days.length,
    child: Column(
      children: [
        Container(
          color: AppColors.surface,
          child: TabBar(
            indicatorColor: AppColors.accent,
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: days.map((d) => Tab(text: 'Day ${d.dayNumber}')).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            children: days.map((day) => buildDayView(context, day)).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => cubit.emitLoading(),
              child: const Text('Plan New Trip'),
            ),
          ),
        ),
      ],
    ),
  );
}
