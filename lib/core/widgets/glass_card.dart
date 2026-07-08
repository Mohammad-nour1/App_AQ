import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/blur_constants.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    super.key,
    this.borderRadius,
    this.padding,
    this.margin,
    this.blur = AppBlur.card,
    this.opacity = AppOpacity.glassBackground,
    this.borderWidth = 1.0,
    this.onTap,
    this.onLongPress,
  });

  final Widget child;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final double opacity;
  final double borderWidth;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.card;

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(effectiveRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppRadius.md),
          margin: margin,
          decoration: BoxDecoration(
            color: AppColors.glassBackground.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(effectiveRadius),
            border: Border.all(
              color: AppColors.glassBorder,
              width: borderWidth,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.glassHighlight.withValues(alpha: opacity),
                AppColors.glassBackground.withValues(alpha: 0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.glassShadow,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null || onLongPress != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(effectiveRadius),
          child: card,
        ),
      );
    }

    return card;
  }
}
