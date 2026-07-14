import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/route_paths.dart';
import '../../core/services/auth_service.dart';

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
          AuthService.login();

          context.go(RoutePaths.home);
        } else if (state != null && state != 'جاري تسجيل الدخول...') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state), backgroundColor: Colors.red));
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.explore, size: 80, color: AppColors.primary),
              const SizedBox(height: 20),
              const Text(
                'مرحباً بك!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              TextField(
                controller: emailController,
                onChanged: (_) => context.read<LoginCubit>().resetState(),
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                onChanged: (_) => context.read<LoginCubit>().resetState(),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة السر',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),

              if (state == 'جاري تسجيل الدخول...')
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: () {
                    context.read<LoginCubit>().login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('تسجيل الدخول'),
                ),

              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go(RoutePaths.register);
                },
                child: const Text('ليس لديك حساب؟ سجل الآن'),
              ),
            ],
          ),
        );
      },
    );
  }
}
