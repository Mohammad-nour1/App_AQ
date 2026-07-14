import 'dart:ui';

import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/presentation/onboarding/screens/onboarding_screen.dart';
import 'package:app_aq_2/presentation/splash/cubit/splash_cubit.dart';
import 'package:app_aq_2/presentation/splash/cubit/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashCubitState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const OnboardingScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            /// Background Image
            Image.asset(
              "assets/images/splash.jpg",
              fit: BoxFit.cover,
            ),

            /// Dark Overlay
            Container(
              color: AppColors.overlayDark.withOpacity(
                AppOpacity.high,
              ),
            ),

            /// Blur Effect
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 2,
                sigmaY: 2,
              ),
              child: Container(
                color: AppColors.transparent,
              ),
            ),

            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Logo Container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.glassBackground,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.glassBorder,
                          width: 1.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.glassShadow,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.travel_explore,
                        color: AppColors.accent,
                        size: 70,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// App Name
                    const Text(
                      "Rahhal",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Subtitle
                    const Text(
                      "Discover Syria",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 60),

                    /// Loading
                    const CircularProgressIndicator(
                      color: AppColors.accent,
                      strokeWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}