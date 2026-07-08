import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/constants/app_spacing.dart';
import 'package:app_aq_2/core/constants/app_text_styles.dart';
import 'package:app_aq_2/core/router/route_paths.dart';
import 'package:app_aq_2/core/widgets/app_text_field.dart';
import 'package:app_aq_2/core/widgets/primary_button.dart';
import 'package:app_aq_2/core/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Text('Create Account', style: AppTextStyles.headlineLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Sign up to get started',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const AppTextField(label: 'Full Name', hint: 'Enter your name'),
              const SizedBox(height: AppSpacing.lg),
              const AppTextField(
                label: 'Email',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.lg),
              const AppTextField(label: 'Password', hint: 'Create a password', obscureText: true),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: 'Sign Up', onPressed: () => context.go(RoutePaths.home)),
              const SizedBox(height: AppSpacing.lg),
              SecondaryButton(
                label: 'Already have an account',
                onPressed: () => context.go(RoutePaths.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
