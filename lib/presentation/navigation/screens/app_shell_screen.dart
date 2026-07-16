import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import 'package:app_aq_2/core/utils/fab_visibility.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    // الحصول على المساحة الآمنة السفلية
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: navigationShell,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: fabVisibleNotifier,
        builder: (context, visible, child) {
          return AnimatedScale(
            duration: const Duration(milliseconds: 220),
            scale: visible ? 1 : 0,
            curve: Curves.easeOutCubic,
            child: child,
          );
        },
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            heroTag: 'app_shell_home',
            onPressed: () => _onSelectIndex(0),
            elevation: 8,
            backgroundColor: navigationShell.currentIndex == 0
                ? AppColors.accent
                : AppColors.surface,
            shape: const CircleBorder(),
            child: Icon(
              Icons.home_rounded,
              size: 28,
              color: navigationShell.currentIndex == 0
                  ? AppColors.black
                  : AppColors.accent,
            ),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: bottomPadding > 0 ? 0 : 2,
            left: 8,
            right: 8,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  // لون غامق مع شفافية عالية للبلور
                  color: isDarkMode
                      ? Colors.black.withValues(alpha: 0.75)
                      : AppColors.background.withValues(alpha: 0.75),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.2),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.4),
                      blurRadius: 35,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: _buildNavItem(
                          context,
                          label: 'Favorites',
                          index: 2,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    ),
                    const SizedBox(width: 75),
                    Expanded(
                      child: Center(
                        child: _buildNavItem(
                          context,
                          label: 'Profile',
                          index: 3,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String label,
    required int index,
    required bool isDarkMode,
  }) {
    final bool isSelected = navigationShell.currentIndex == index;
    final IconData iconData = _getIconForIndex(index, isSelected);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onSelectIndex(index),
        borderRadius: BorderRadius.circular(20),
        splashColor: AppColors.accent.withValues(alpha: 0.2),
        highlightColor: AppColors.accent.withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accent.withValues(alpha: 0.2)
                : (isDarkMode
                      ? Colors.white.withValues(alpha: 0.06)
                      : AppColors.surface.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : (isDarkMode
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.border.withValues(alpha: 0.2)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 22,
                color: isSelected
                    ? AppColors.accent
                    : (isDarkMode
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppColors.textPrimary),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.accent
                      : (isDarkMode
                            ? Colors.white.withValues(alpha: 0.7)
                            : AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index, bool isSelected) {
    switch (index) {
      case 0:
        return isSelected ? Icons.home_rounded : Icons.home_outlined;
      case 1:
        return isSelected ? Icons.search_rounded : Icons.search_outlined;
      case 2:
        return Icons.favorite_rounded;
      case 3:
        return Icons.person_rounded;
      default:
        return Icons.home_outlined;
    }
  }

  void _onSelectIndex(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
