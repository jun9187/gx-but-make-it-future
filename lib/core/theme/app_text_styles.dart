import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

abstract final class AppTextStyles {
  static TextTheme textTheme() {
    final base = GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme);

    return base.copyWith(
      displayLarge: _style(base.displayLarge, 40, FontWeight.w700, AppColors.textPrimary, -0.8),
      displayMedium: _style(base.displayMedium, 32, FontWeight.w700, AppColors.textPrimary, -0.6),
      displaySmall: _style(base.displaySmall, 28, FontWeight.w700, AppColors.textPrimary, -0.4),
      headlineLarge: _style(base.headlineLarge, 24, FontWeight.w700, AppColors.textPrimary, -0.3),
      headlineMedium: _style(base.headlineMedium, 22, FontWeight.w700, AppColors.textPrimary, -0.2),
      headlineSmall: _style(base.headlineSmall, 20, FontWeight.w700, AppColors.textPrimary),
      titleLarge: _style(base.titleLarge, 18, FontWeight.w700, AppColors.textPrimary),
      titleMedium: _style(base.titleMedium, 16, FontWeight.w600, AppColors.textPrimary),
      titleSmall: _style(base.titleSmall, 14, FontWeight.w600, AppColors.textSecondary),
      bodyLarge: _style(base.bodyLarge, 16, FontWeight.w500, AppColors.textSecondary),
      bodyMedium: _style(base.bodyMedium, 14, FontWeight.w500, AppColors.textMuted),
      bodySmall: _style(base.bodySmall, 12, FontWeight.w500, AppColors.textMuted, 0.1),
      labelLarge: _style(base.labelLarge, 14, FontWeight.w600, AppColors.textPrimary, 0.1),
      labelMedium: _style(base.labelMedium, 12, FontWeight.w600, AppColors.textSecondary, 0.2),
      labelSmall: _style(base.labelSmall, 11, FontWeight.w600, AppColors.textMuted, 0.3),
    );
  }

  static TextStyle? _style(
    TextStyle? source,
    double size,
    FontWeight weight,
    Color color, [
    double? letterSpacing,
  ]) {
    return source?.copyWith(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.2,
    );
  }
}
