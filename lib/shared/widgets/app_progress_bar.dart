import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.height = 10,
    this.gradient,
    this.backgroundColor,
  });

  final double value;
  final double height;
  final Gradient? gradient;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            ColoredBox(
              color: backgroundColor ?? Colors.white.withValues(alpha: 0.08),
              child: const SizedBox.expand(),
            ),
            FractionallySizedBox(
              widthFactor: clampedValue,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: gradient ??
                      const LinearGradient(
                        colors: [AppColors.heroStart, AppColors.heroEnd],
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
