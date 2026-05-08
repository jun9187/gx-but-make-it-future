import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppGradients {
  static const shellBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF09090E), Color(0xFF0D0914), Color(0xFF150A1D)],
  );

  static const primaryGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.purple, AppColors.pink],
  );

  static const accentGlow = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB668FF), Color(0xFF7C3AED), Color(0xFF3C1A5A)],
  );
}
