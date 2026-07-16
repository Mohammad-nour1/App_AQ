import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/models/place.dart';
import 'package:app_aq_2/core/router/route_paths.dart';
import 'package:app_aq_2/core/widgets/search&nearby/items_grid_builder.dart';
import 'package:app_aq_2/presentation/trip/cubit/trip_cubit.dart';
import 'package:app_aq_2/presentation/trip/cubit/trip_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app_aq_2/presentation/home/cubit/home_cubit.dart';

class TripSuggestionScreen extends StatefulWidget {
  const TripSuggestionScreen({super.key});

  @override
  State<TripSuggestionScreen> createState() => _TripSuggestionScreenState();
}

class _TripSuggestionScreenState extends State<TripSuggestionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TripCubit>().loadTripSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trip Suggestions'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).push(RoutePaths.tripPlan),
            icon: const Icon(Icons.event_note_rounded),
            tooltip: 'Trip Plan',
          ),
        ],
      ),
      body: BlocBuilder<TripCubit, TripState>(
        builder: (context, state) {
          if (state is TripLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (state is TripError) {
            return Center(
              child: Text(
                state.failure.message,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            );
          }

          if (state is TripLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.historicalTrip.isNotEmpty) ...[
                    _buildTripSection(
                      title: 'Historical Tour',
                      icon: Icons.account_balance,
                      places: state.historicalTrip,
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (state.naturalTrip.isNotEmpty) ...[
                    _buildTripSection(
                      title: 'Nature & Scenery',
                      icon: Icons.landscape,
                      places: state.naturalTrip,
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (state.culturalTrip.isNotEmpty) ...[
                    _buildTripSection(
                      title: 'Cultural Experience',
                      icon: Icons.mosque,
                      places: state.culturalTrip,
                    ),
                  ],
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTripSection({
    required String title,
    required IconData icon,
    required List<Place> places,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 28),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        itemsGridBuilder(
          16,
          places,
          context,
          onShowOnMap: (place) {
            context.read<HomeCubit>().setPendingTargetPlace(place.id);
            context.go(RoutePaths.homeMap);
          },
        ),
      ],
    );
  }
}
