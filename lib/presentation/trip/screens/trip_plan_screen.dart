import 'package:app_aq_2/presentation/trip/cubit/trip_plan_cubit.dart';
import 'package:app_aq_2/presentation/trip/cubit/trip_plan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme.dart';

class TripPlanScreen extends StatelessWidget {
  const TripPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripPlanCubit()..loadPlan(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Trip Plan')),
        body: BlocBuilder<TripPlanCubit, TripPlanState>(
          builder: (context, state) {
            if (state is TripPlanLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TripPlanLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.steps.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final step = state.steps[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(step, style: AppTextStyles.bodyLarge),
                  );
                },
              );
            }
            if (state is TripPlanError) {
              return Center(child: Text(state.failure.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
