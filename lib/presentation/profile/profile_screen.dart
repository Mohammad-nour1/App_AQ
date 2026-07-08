import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/router/route_paths.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نفترض اسم المستخدم مسجل في AuthService (لاحقاً رح نجيبها من API)
    final String userName = 'أيهم البوش';
    final String userEmail = 'ayham@example.com';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // صورة المستخدم (دائرية)
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: const Icon(Icons.person, size: 80, color: AppColors.primary),
            ),
            const SizedBox(height: 20),

            // اسم المستخدم
            Text(
              userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),

            // البريد الإلكتروني
            Text(userEmail, style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 40),

            // بطاقة معلومات
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildProfileItem(
                      icon: Icons.location_on,
                      title: 'الأماكن المضافة',
                      value: '0', // لاحقاً رح نجيب العدد الحقيقي
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.favorite,
                      title: 'المفضلة',
                      value: '0', // لاحقاً رح نجيب العدد الحقيقي
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.star,
                      title: 'التقييمات',
                      value: '0', // لاحقاً رح نجيب العدد الحقيقي
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // زر تسجيل الخروج (Logout)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _logout(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('تسجيل الخروج', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لبناء عنصر في البطاقة
  Widget _buildProfileItem({required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 16, color: AppColors.textPrimary)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  // دالة تسجيل الخروج
  void _logout(BuildContext context) {
    // إظهار مربع حوار للتأكيد
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الحوار
                // تنفيذ تسجيل الخروج
                AuthService.logout();
                // العودة لشاشة Login
                context.go(RoutePaths.login);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
  }
}
