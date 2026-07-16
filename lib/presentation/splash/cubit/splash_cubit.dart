import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/router/route_paths.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashCubitState> {
  SplashCubit() : super(SplashInitial());

  Future<void> initialize(BuildContext context) async {
    emit(SplashLoading());
    // increased splash duration by ~2 seconds (was 1500ms)
    await Future.delayed(const Duration(milliseconds: 3500));
    emit(SplashCompleted());

    // Navigate based on auth state after splash completes
    if (AuthService.isLoggedIn) {
      if (context.mounted) {
        context.go(RoutePaths.home);
      }
    } else {
      if (context.mounted) {
        context.go(RoutePaths.onboarding);
      }
    }
  }
}
