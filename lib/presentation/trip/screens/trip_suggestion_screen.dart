import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/constants/app_radius.dart';
import 'package:app_aq_2/core/constants/app_spacing.dart';
import 'package:app_aq_2/core/constants/app_text_styles.dart';
import 'package:app_aq_2/core/di/injector.dart';
import 'package:app_aq_2/core/models/place/place.dart';
import 'package:app_aq_2/core/models/place/place_categories.dart';
import 'package:app_aq_2/core/repository/home_repository.dart';
import 'package:app_aq_2/core/router/route_paths.dart';
import 'package:app_aq_2/presentation/home/cubit/home_cubit.dart';
import 'package:app_aq_2/presentation/trip/screens/cubit/trip_cubit.dart';
import 'package:app_aq_2/presentation/trip/screens/cubit/trip_state.dart';
import 'package:app_aq_2/presentation/trip/screens/widgets/results_tab_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TripSuggestionScreen extends StatefulWidget {
  const TripSuggestionScreen({super.key});

  @override
  State<TripSuggestionScreen> createState() => _TripSuggestionScreenState();
}

class _TripSuggestionScreenState extends State<TripSuggestionScreen> {
  String _selectedCity = 'Damascus';
  int _selectedDays = 1;
  final Set<PlaceCategories> _selectedCategories = <PlaceCategories>{};
  final List<String> _cities = <String>[];

  @override
  void initState() {
    super.initState();
    final repo = getIt<HomeRepository>();
    _cities.addAll(repo.getCities());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Trip Suggestion',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).push(RoutePaths.tripPlan),
            icon: const Icon(Icons.event_note_rounded),
            tooltip: 'Trip Plan',
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => TripSuggestionCubit(getIt<HomeRepository>()),
        child: BlocBuilder<TripSuggestionCubit, TripSuggestionState>(
          builder: (context, state) {
            if (state is TripSuggestionInput) {
              return _buildContent(context, showLoading: false);
            }

            if (state is TripSuggestionComputing) {
              return _buildContent(context, showLoading: true);
            }

            if (state is TripSuggestionLoaded) {
              final cubit = context.read<TripSuggestionCubit>();
              return buildResults(context, state.suggestion, cubit);
            }

            if (state is TripSuggestionError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.headlineMedium),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => context.read<TripSuggestionCubit>().emitLoading(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required bool showLoading}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Select City'),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedCity,
                dropdownColor: AppColors.surface,
                style: AppTextStyles.bodyLarge,
                items: _cities
                    .map(
                      (city) => DropdownMenuItem(value: city, child: Text(city)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCity = val!),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionTitle('Interests'),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: PlaceCategories.values.map((cat) {
              final selected = _selectedCategories.contains(cat);
              return FilterChip(
                label: Text(cat.label),
                selected: selected,
                selectedColor: AppColors.accent,
                backgroundColor: AppColors.surface,
                checkmarkColor: AppColors.white,
                labelStyle: TextStyle(
                  color: selected ? AppColors.white : AppColors.textSecondary,
                ),
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _selectedCategories.add(cat);
                    } else {
                      _selectedCategories.remove(cat);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionTitle('Number of Days'),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                value: _selectedDays,
                dropdownColor: AppColors.surface,
                style: AppTextStyles.bodyLarge,
                items: [1, 2, 3, 4, 5]
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Text('$d day${d > 1 ? 's' : ''}'),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedDays = val!),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                elevation: 4,
              ),
              onPressed: () {
                context.read<TripSuggestionCubit>().suggest(
                  city: _selectedCity,
                  categories: _selectedCategories,
                  days: _selectedDays,
                );
              },
              child: const Text(
                'Generate My Trip',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (showLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: AppTextStyles.headlineSmall.copyWith(color: AppColors.white),
    );
  }
}
