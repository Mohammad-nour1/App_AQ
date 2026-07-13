import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/constants/app_spacing.dart';
import 'package:app_aq_2/core/constants/app_text_styles.dart';
import 'package:app_aq_2/core/router/route_paths.dart';
import 'package:app_aq_2/core/services/auth_service.dart';
import 'package:app_aq_2/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            GlassContainer(
              blur: 15.0,
              opacity: 0.15,
              borderRadius: 24.0,
              borderColor: AppColors.surface.withOpacity(0.1),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withOpacity(0.3),
                    child: Icon(Icons.person, size: 50, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Ayham', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'ayham@example.com',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            GlassContainer(
              blur: 10.0,
              opacity: 0.1,
              borderRadius: 16.0,
              borderColor: AppColors.border.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    Icons.location_on,
                    'My Places',
                    '0',
                    onTap: () => context.go(RoutePaths.myPlaces),
                  ),
                  _buildStatItem(
                    Icons.favorite,
                    'Favorites',
                    '0',
                    onTap: () => context.go(RoutePaths.favorites),
                  ),
                  _buildStatItem(Icons.star, 'Reviews', '0'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            GlassContainer(
              blur: 10.0,
              opacity: 0.2,
              borderRadius: 12.0,
              borderColor: AppColors.error.withOpacity(0.5),
              padding: EdgeInsets.zero,
              child: MaterialButton(
                onPressed: () {
                  AuthService.logout();
                  context.go(RoutePaths.login);
                },
                height: 56,
                minWidth: double.infinity,
                child: Text(
                  'Logout',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String title, String value, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary)),
            Text(title, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
