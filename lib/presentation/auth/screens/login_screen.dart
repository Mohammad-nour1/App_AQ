import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/constants/app_spacing.dart';
import 'package:app_aq_2/core/constants/app_text_styles.dart';
import 'package:app_aq_2/core/router/route_paths.dart';
import 'package:app_aq_2/core/services/auth_service.dart';
import 'package:app_aq_2/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginCubit extends Cubit<String?> {
  LoginCubit() : super(null);

  void login(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      emit('الرجاء تعبئة جميع الحقول');
      return;
    }
    emit('جاري تسجيل الدخول...');

    Future.delayed(const Duration(seconds: 2), () {
      if (email == 'test@test.com' && password == '123456') {
        AuthService.login();
        emit('success');
      } else {
        emit('البريد أو كلمة السر غير صحيحة');
      }
    });
  }

  void resetState() {
    emit(null);
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocProvider(create: (context) => LoginCubit(), child: const LoginView()),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocConsumer<LoginCubit, String?>(
      listener: (context, state) {
        if (state == 'success') {
          context.go(RoutePaths.home);
        } else if (state != null && state != 'جاري تسجيل الدخول...') {
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
                    Icon(Icons.explore, size: 64, color: AppColors.textPrimary),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Welcome Back',
                      style: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Sign in to continue',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Email
                    GlassContainer(
                      blur: 5.0,
                      opacity: 0.1,
                      borderRadius: 50.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: emailController,
                        onChanged: (_) => context.read<LoginCubit>().resetState(),
                        style: TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                          floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textSecondary),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textSecondary),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          icon: Icon(Icons.email, color: AppColors.textSecondary),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Password
                    GlassContainer(
                      blur: 5.0,
                      opacity: 0.1,
                      borderRadius: 50.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: passwordController,
                        onChanged: (_) => context.read<LoginCubit>().resetState(),
                        obscureText: true,
                        style: TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                          floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textSecondary),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textSecondary),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          icon: Icon(Icons.lock, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text('Forgot Password?', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    if (state == 'جاري تسجيل الدخول...')
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
                            context.read<LoginCubit>().login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                          },
                          height: 56,
                          minWidth: double.infinity,
                          child: Text(
                            'Sign In',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.lg),

                    TextButton(
                      onPressed: () => context.go(RoutePaths.register),
                      child: Text('Create an account', style: TextStyle(color: AppColors.textSecondary)),
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
