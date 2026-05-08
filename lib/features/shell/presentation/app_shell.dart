import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../features/dashboard/presentation/dashboard_screen.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../application/shell_provider.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinations = ref.watch(shellDestinationsProvider);

    return AppScaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated.withValues(alpha: 0.78),
                border: Border.all(color: AppColors.stroke),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x59000000),
                    blurRadius: 24,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    for (final destination in destinations)
                      Expanded(
                        child: _ShellNavItem(
                          destination: destination,
                          onTap: destination.isEnabled
                              ? () => context.go(DashboardScreen.routePath)
                              : null,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, curve: Curves.easeOut),
    );
  }
}

class _ShellNavItem extends StatelessWidget {
  const _ShellNavItem({required this.destination, this.onTap});

  final ShellDestination destination;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = destination.isActive;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0x666F4CFF), Color(0x66D946EF)],
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              destination.icon,
              size: 20,
              color: isActive ? AppColors.textPrimary : AppColors.textMuted,
            ),
            const SizedBox(height: 6),
            Text(
              destination.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive ? AppColors.textPrimary : AppColors.textMuted,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 11,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
