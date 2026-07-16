import 'dart:ui';

import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/constants/app_radius.dart';
import 'package:app_aq_2/core/constants/app_spacing.dart';
import 'package:app_aq_2/presentation/profile/cubit/profile_cubit.dart';
import 'package:app_aq_2/presentation/profile/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text('Profile'),
            flexibleSpace: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                color: AppColors.surfaceElevated.withValues(alpha: 0.72),
              ),
            ),
          ),
        ),
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOut) {
            context.go('/splash');
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              );
            }

            if (state is ProfileLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 132, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 28,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated.withValues(
                                alpha: 0.72,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.border.withValues(alpha: 0.45),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.accent.withValues(
                                      alpha: 0.18,
                                    ),
                                    border: Border.all(
                                      color: AppColors.accent,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: AppColors.accent,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  state.name,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.email,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Menu Items
                    _buildMenuItem(
                      icon: Icons.favorite_border,
                      title: 'My Favorites',
                      onTap: () {
                        context.go('/favorites');
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.history,
                      title: 'History',
                      onTap: () {
                        _showComingSoon(context);
                      },
                      isComingSoon: true,
                    ),
                    _buildMenuItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        _showComingSoon(context);
                      },
                      isComingSoon: true,
                    ),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        _showComingSoon(context);
                      },
                      isComingSoon: true,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ProfileCubit>().logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppRadius.button,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isComingSoon = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.accent),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
        ),
        trailing: isComingSoon
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Coming Soon',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming Soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
