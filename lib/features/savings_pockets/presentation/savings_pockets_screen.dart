import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/mock/app_mock_data.dart';
import '../../../data/models/app_mock_models.dart';
import '../../../shared/widgets/feature_top_bar.dart';
import '../../../shared/widgets/section_header.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class SavingsPocketsScreen extends StatelessWidget {
  const SavingsPocketsScreen({super.key});

  static const routeName = 'savings-pockets';
  static const routePath = '/savings-pockets';

  @override
  Widget build(BuildContext context) {
    const data = savingsPocketsScreenData;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          120,
        ),
        children: [
          FeatureTopBar(
            title: 'Savings Pockets',
            onLeadingTap: () => _goBackOrDashboard(context),
          ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Total Pocket Balance',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            formatCurrency(data.totalPocketBalance),
            style: Theme.of(context).textTheme.displaySmall,
          ).animate().fadeIn(delay: 60.ms, duration: 260.ms),
          const SizedBox(height: AppSpacing.sm),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            title: 'All Pockets',
            subtitle: '10 pockets available in GXBank.',
          ),
          const SizedBox(height: AppSpacing.md),
          _PocketGrid(pockets: data.pockets),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            title: 'FutureFlow Saving Pockets',
            subtitle: 'Additional pockets managed by FutureFlow.',
          ),
          const SizedBox(height: AppSpacing.md),
          _PocketGrid(pockets: data.futureFlowPockets),
        ],
      ),
    );
  }
}

class _PocketGrid extends StatelessWidget {
  const _PocketGrid({required this.pockets});

  final List<SavingsPocketData> pockets;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pockets.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final pocket = pockets[index];
        return _PocketCard(data: pocket)
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: 80 + (index * 50)),
              duration: 240.ms,
            )
            .slideY(begin: 0.04, end: 0);
      },
    );
  }
}

class _PocketCard extends StatelessWidget {
  const _PocketCard({required this.data});

  final SavingsPocketData data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(decoration: BoxDecoration(gradient: data.imageGradient)),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.08),
                    AppColors.background.withValues(alpha: 0.74),
                  ],
                ),
              ),
            ),
          ),
          if (data.badgeLabel != null)
            Positioned(
              left: AppSpacing.sm,
              top: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color:
                      data.badgeColor ?? Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  data.badgeLabel!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: data.badgeColor == const Color(0xFFFFD400)
                        ? const Color(0xFF4C2F00)
                        : Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  formatCurrency(data.amount),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _goBackOrDashboard(BuildContext context) {
  if (context.canPop()) {
    context.pop();
    return;
  }
  context.go(DashboardScreen.routePath);
}
