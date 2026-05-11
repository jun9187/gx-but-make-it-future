import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_spacing.dart';
import 'app_top_bar.dart';
import 'glass_card.dart';
import 'icon_circle.dart';

class ScreenPlaceholder extends StatelessWidget {
  const ScreenPlaceholder({
    super.key,
    required this.title,
    required this.eyebrow,
    required this.description,
    required this.icon,
  });

  final String title;
  final String eyebrow;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.lg,
          120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopBar(title: title, eyebrow: eyebrow),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconCircle(
                    icon: icon,
                    size: 56,
                    iconSize: 24,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6F4CFF), Color(0xFFD946EF)],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Prototype placeholder',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.06, end: 0);
  }
}
