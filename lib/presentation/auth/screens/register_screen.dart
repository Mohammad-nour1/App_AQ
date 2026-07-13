import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/constants/app_spacing.dart';
import 'package:app_aq_2/core/constants/app_text_styles.dart';
import 'package:app_aq_2/core/router/route_paths.dart';
import 'package:app_aq_2/core/services/auth_service.dart';
import 'package:app_aq_2/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterCubit extends Cubit<String?> {
  RegisterCubit() : super(null);

  void register(String name, String email, String password, String confirmPassword) {
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      emit('الرجاء تعبئة جميع الحقول');
      return;
    }
    if (password != confirmPassword) {
      emit('كلمة المرور غير متطابقة');
      return;
    }
    if (password.length < 6) {
      emit('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }

    emit('جاري إنشاء الحساب...');

    Future.delayed(const Duration(seconds: 2), () {
      AuthService.login();
      emit('success');
    });
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
      backgroundColor: AppColors.background,
      body: BlocProvider(create: (context) => RegisterCubit(), child: const RegisterView()),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return BlocConsumer<RegisterCubit, String?>(
      listener: (context, state) {
        if (state == 'success') {
          context.go(RoutePaths.home);
        } else if (state != null && state != 'جاري إنشاء الحساب...') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state), backgroundColor: AppColors.error));
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: GlassContainer(
                blur: 15.0,
                opacity: 0.15,
                borderRadius: 24.0,
                borderColor: AppColors.surface.withOpacity(0.1),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.person_add, size: 64, color: AppColors.textPrimary),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Create Account',
                      style: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Sign up to get started',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    GlassContainer(
                      blur: 5.0,
                      opacity: 0.1,
                      borderRadius: 50.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: nameController,
                        onChanged: (_) => context.read<RegisterCubit>().resetState(),
                        style: TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                          floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                          border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          icon: Icon(Icons.person, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    GlassContainer(
                      blur: 5.0,
                      opacity: 0.1,
                      borderRadius: 50.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        onChanged: (_) => context.read<RegisterCubit>().resetState(),
                        style: TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Last Name (optional)',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                          floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                          border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          icon: Icon(Icons.person_outline, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    GlassContainer(
                      blur: 5.0,
                      opacity: 0.1,
                      borderRadius: 50.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: emailController,
                        onChanged: (_) => context.read<RegisterCubit>().resetState(),
                        style: TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                          floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                          border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          icon: Icon(Icons.email, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    GlassContainer(
                      blur: 5.0,
                      opacity: 0.1,
                      borderRadius: 50.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: passwordController,
                        onChanged: (_) => context.read<RegisterCubit>().resetState(),
                        obscureText: true,
                        style: TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Password (min 6 chars)',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                          floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                          border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          icon: Icon(Icons.lock, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    GlassContainer(
                      blur: 5.0,
                      opacity: 0.1,
                      borderRadius: 50.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: confirmPasswordController,
                        onChanged: (_) => context.read<RegisterCubit>().resetState(),
                        obscureText: true,
                        style: TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                          floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                          border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          icon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    if (state == 'جاري إنشاء الحساب...')
                      const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    else
                      GlassContainer(
                        blur: 10.0,
                        opacity: 0.25,
                        borderRadius: 12.0,
                        borderColor: AppColors.primary.withOpacity(0.5),
                        padding: EdgeInsets.zero,
                        child: MaterialButton(
                          onPressed: () {
                            context.read<RegisterCubit>().register(
                              nameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              confirmPasswordController.text.trim(),
                            );
                          },
                          height: 56,
                          minWidth: double.infinity,
                          child: Text(
                            'Sign Up',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.lg),

                    TextButton(
                      onPressed: () => context.go(RoutePaths.login),
                      child: Text(
                        'Already have an account? Sign in',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
