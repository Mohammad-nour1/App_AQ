import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/auth_service.dart';
import '../../core/router/route_paths.dart';
import 'package:go_router/go_router.dart';

class RegisterCubit extends Cubit<String?> {
  RegisterCubit() : super(null);

  static const loadingState = '__loading__';

  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      emit('Please fill in all fields');
      return;
    }
    if (password != confirmPassword) {
      emit('Passwords do not match');
      return;
    }
    if (password.length < 6) {
      emit('Password must be at least 6 characters');
      return;
    }

    emit(loadingState);

    final success = await AuthService.register(
      name: name,
      email: email,
      password: password,
    );

    if (success) {
      emit('success');
    } else {
      emit('Registration failed. Please try again.');
    }
  }

  void resetState() {
    emit(null);
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/splash.jpg', fit: BoxFit.cover),
          Container(
            color: AppColors.overlayDark.withValues(alpha: AppOpacity.high),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: AppColors.transparent),
          ),
          SafeArea(
            child: BlocProvider(
              create: (context) => RegisterCubit(),
              child: const RegisterView(),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showPassword = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelStyle: const TextStyle(color: AppColors.accent),
      prefixIcon: Icon(icon, color: AppColors.accent),
      filled: true,
      fillColor: AppColors.surface.withValues(alpha: 0.24),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.35)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: BorderSide(color: AppColors.accent, width: 1.5),
      ),
    );
  }

  bool _validateEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, String?>(
      listener: (context, state) {
        if (state == 'success') {
          context.go(RoutePaths.home);
        } else if (state != null && state != RegisterCubit.loadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state), backgroundColor: AppColors.error),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state == RegisterCubit.loadingState;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 18),
                  Container(
                    height: 92,
                    width: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.accentDeep, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.24),
                          blurRadius: 26,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_add,
                      size: 42,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Create your account and start planning your trip with ease.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 34),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.45),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.16),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: nameController,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) =>
                                context.read<RegisterCubit>().resetState(),
                            decoration: _inputDecoration(
                              label: 'Full Name',
                              icon: Icons.person,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) =>
                                context.read<RegisterCubit>().resetState(),
                            decoration: _inputDecoration(
                              label: 'Email',
                              icon: Icons.email_rounded,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!_validateEmail(value.trim())) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: passwordController,
                            obscureText: !showPassword,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) =>
                                context.read<RegisterCubit>().resetState(),
                            decoration:
                                _inputDecoration(
                                  label: 'Password (min. 6 characters)',
                                  icon: Icons.lock_rounded,
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    splashRadius: 22,
                                    icon: Icon(
                                      showPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.textSecondary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.trim().length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: !showPassword,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) =>
                                context.read<RegisterCubit>().resetState(),
                            decoration: _inputDecoration(
                              label: 'Confirm Password',
                              icon: Icons.lock_outline,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value.trim() !=
                                  passwordController.text.trim()) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          if (isLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  context.read<RegisterCubit>().register(
                                    nameController.text.trim(),
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    confirmPasswordController.text.trim(),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.button,
                                  ),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Create Account',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go(RoutePaths.login);
                                },
                                child: const Text('Sign In'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
