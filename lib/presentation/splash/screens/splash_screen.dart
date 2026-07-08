import 'package:app_aq_2/presentation/splash/cubit/splash_cubit.dart';
import 'package:app_aq_2/presentation/splash/cubit/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_paths.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..initialize(),
      child: BlocListener<SplashCubit, SplashCubitState>(
        listener: (context, state) {
          if (state is SplashCompleted) {
            context.go(RoutePaths.home);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.explore_rounded, size: 48, color: AppColors.black),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Rahhal', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
