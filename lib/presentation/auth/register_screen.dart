import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/router/route_paths.dart';
import 'package:go_router/go_router.dart';

// --- 1. Cubit خاص بالتسجيل ---
class RegisterCubit extends Cubit<String?> {
  RegisterCubit() : super(null);

  void register(String name, String email, String password, String confirmPassword) {
    // تحقق من الحقول الفارغة
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      emit('الرجاء تعبئة جميع الحقول');
      return;
    }
    // تحقق من تطابق كلمة المرور
    if (password != confirmPassword) {
      emit('كلمة المرور غير متطابقة');
      return;
    }
    if (password.length < 6) {
      emit('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }

    emit('جاري إنشاء الحساب...');

    // محاكاة طلب السيرفر
    Future.delayed(const Duration(seconds: 2), () {
      // نفترض إنه تم التسجيل بنجاح
      emit('success');
    });
  }

  void resetState() {
    emit(null);
  }
}

// --- 2. شاشة Register ---
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

// --- 3. الـ View ---
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
          // بعد نجاح التسجيل، نسجل دخوله تلقائياً ونوديه للـ Home
          AuthService.login();
          context.go(RoutePaths.home);
        } else if (state != null && state != 'جاري إنشاء الحساب...') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state), backgroundColor: Colors.red));
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                const Icon(Icons.person_add, size: 80, color: AppColors.primary),
                const SizedBox(height: 20),
                const Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                TextField(
                  controller: nameController,
                  onChanged: (_) => context.read<RegisterCubit>().resetState(),
                  decoration: InputDecoration(
                    labelText: 'الاسم الكامل',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: emailController,
                  onChanged: (_) => context.read<RegisterCubit>().resetState(),
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  onChanged: (_) => context.read<RegisterCubit>().resetState(),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'كلمة السر (6 أحرف على الأقل)',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: confirmPasswordController,
                  onChanged: (_) => context.read<RegisterCubit>().resetState(),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة السر',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),

                if (state == 'جاري إنشاء الحساب...')
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: () {
                      context.read<RegisterCubit>().register(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        confirmPasswordController.text.trim(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('إنشاء الحساب'),
                  ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    context.go(RoutePaths.login);
                  },
                  child: const Text('لديك حساب بالفعل؟ سجل دخول'),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
