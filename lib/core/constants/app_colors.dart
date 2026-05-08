import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF06070C);
  static const backgroundSecondary = Color(0xFF0B0D14);
  static const surface = Color(0xFF121521);
  static const surfaceElevated = Color(0xFF171B29);
  static const card = surface;
  static const cardStrong = surfaceElevated;

  static const stroke = Color(0x24F4F0FF);
  static const strokeStrong = Color(0x3DE8E0FF);

  static const textPrimary = Color(0xFFF6F7FB);
  static const textSecondary = Color(0xFFC8CBDA);
  static const textMuted = Color(0xFF8F95AB);
  static const white = textPrimary;
  static const muted = textMuted;

  static const purple = Color(0xFF7C4DFF);
  static const magenta = Color(0xFFFF4FD8);
  static const pink = magenta;
  static const violet = Color(0xFFB48CFF);
  static const cyan = Color(0xFF67E8F9);
  static const emerald = Color(0xFF3DD9A4);
  static const amber = Color(0xFFFFC96B);
  static const danger = Color(0xFFFF738D);

  static const heroStart = Color(0xFF6F4CFF);
  static const heroEnd = Color(0xFFD946EF);
  static const heroGlow = Color(0xFF2B163A);
}
