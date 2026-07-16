import 'package:flutter_bloc/flutter_bloc.dart';
import 'trip_plan_state.dart';

class TripPlanCubit extends Cubit<TripPlanState> {
  TripPlanCubit() : super(TripPlanInitial());

  Future<void> loadPlan() async {
    emit(TripPlanLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    // Placeholder plan steps
    final steps = [
      'Start at Damascus Citadel',
      'Visit National Museum',
      'Lunch at local restaurant',
      'Afternoon hike at nearby viewpoint',
    ];
    emit(TripPlanLoaded(steps: steps));
  }
}
