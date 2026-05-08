import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';

class IconCircle extends StatelessWidget {
  const IconCircle({
    super.key,
    this.icon,
    this.child,
    this.size = 44,
    this.iconSize = 20,
    this.color = AppColors.textPrimary,
    this.backgroundColor,
    this.gradient,
  }) : assert(icon != null || child != null);

  final IconData? icon;
  final Widget? child;
  final double size;
  final double iconSize;
  final Color color;
  final Color? backgroundColor;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceElevated,
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.icon),
        border: Border.all(color: AppColors.stroke),
      ),
      alignment: Alignment.center,
      child: child ?? Icon(icon, size: iconSize, color: color),
    );
  }
}
