import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../data/mock/app_mock_data.dart';
import '../../../data/models/app_mock_models.dart';
import '../../../shared/widgets/app_progress_bar.dart';
import '../../../shared/widgets/feature_top_bar.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../../../shared/widgets/section_header.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class CashFlowScreen extends StatelessWidget {
  const CashFlowScreen({super.key});

  static const routeName = 'cash-flow';
  static const routePath = '/cash-flow';

  @override
  Widget build(BuildContext context) {
    const data = cashFlowScreenData;

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
            title: 'Cash Flow',
            onLeadingTap: () => _goBackOrDashboard(context),
          ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: AppSpacing.lg),
          _InsightBanner(text: data.insight)
              .animate()
              .fadeIn(delay: 50.ms, duration: 240.ms)
              .slideY(begin: 0.05, end: 0),
          const SizedBox(height: AppSpacing.xl),
          _SpendingDonutCard(
            totalSpentLabel: data.totalSpentLabel,
            categories: data.categories,
          ).animate().fadeIn(delay: 110.ms, duration: 280.ms),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Categories', actionLabel: 'View all'),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < data.categories.length; i++) ...[
            _CategoryTile(data: data.categories[i]).animate().fadeIn(
              delay: Duration(milliseconds: 210 + (i * 55)),
              duration: 240.ms,
            ),
            if (i != data.categories.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
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

class _InsightBanner extends StatelessWidget {
  const _InsightBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconCircle(
            icon: Icons.auto_graph_rounded,
            size: 34,
            iconSize: 16,
            backgroundColor: Color(0x247C4DFF),
            color: Color(0xFFCFAEFF),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendingDonutCard extends StatelessWidget {
  const _SpendingDonutCard({
    required this.totalSpentLabel,
    required this.categories,
  });

  final String totalSpentLabel;
  final List<SpendingCategoryData> categories;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          SizedBox(
            width: 208,
            height: 208,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    centerSpaceRadius: 58,
                    sectionsSpace: 0,
                    startDegreeOffset: -90,
                    sections: [
                      for (final category in categories)
                        PieChartSectionData(
                          color: category.color,
                          value: category.share * 100,
                          radius: 24,
                          title: '',
                        ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Spent',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      totalSpentLabel,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.data});

  final SpendingCategoryData data;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              IconCircle(
                icon: data.icon,
                size: 40,
                iconSize: 18,
                backgroundColor: data.color.withValues(alpha: 0.14),
                color: data.color,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${data.transactionCount} Transactions',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              SizedBox(
                width: 104,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data.amountLabel,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${data.percentLabel} of spend',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppProgressBar(
            value: data.share,
            height: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            gradient: LinearGradient(
              colors: [data.color, data.color.withValues(alpha: 0.72)],
            ),
          ),
        ],
      ),
    );
  }
}
