import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_progress_bar.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../../../shared/widgets/section_header.dart';

class CashFlowScreen extends StatelessWidget {
  const CashFlowScreen({super.key});

  static const routeName = 'cash-flow';
  static const routePath = '/cash-flow';

  @override
  Widget build(BuildContext context) {
    const data = _cashFlowData;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          120,
        ),
        children: [
          const _CashFlowTopBar()
              .animate()
              .fadeIn(duration: 220.ms)
              .slideY(begin: 0.05, end: 0),
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
          const SectionHeader(
            title: 'Categories',
            actionLabel: 'View all',
          ).animate().fadeIn(delay: 170.ms, duration: 240.ms),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < data.categories.length; i++) ...[
            _CategoryTile(data: data.categories[i])
                .animate()
                .fadeIn(delay: Duration(milliseconds: 210 + (i * 55)), duration: 240.ms),
            if (i != data.categories.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _CashFlowTopBar extends StatelessWidget {
  const _CashFlowTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const IconCircle(
          icon: Icons.arrow_back_rounded,
          size: 36,
          iconSize: 18,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'Cash Flow',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const IconCircle(
          icon: Icons.notifications_none_rounded,
          size: 36,
          iconSize: 18,
        ),
        const SizedBox(width: AppSpacing.sm),
        const _ProfileAvatar(),
      ],
    );
  }
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
  final List<_CashFlowCategoryData> categories;

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

  final _CashFlowCategoryData data;

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data.amountLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${data.percentLabel} of spend',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppProgressBar(
            value: data.share,
            height: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            gradient: LinearGradient(
              colors: [
                data.color,
                data.color.withValues(alpha: 0.72),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEAF9DB),
            Color(0xFF6FCF97),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAF3),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: const Center(
          child: Text(
            'Y',
            style: TextStyle(
              color: Color(0xFF2B7A4B),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _CashFlowScreenData {
  const _CashFlowScreenData({
    required this.insight,
    required this.totalSpentLabel,
    required this.categories,
  });

  final String insight;
  final String totalSpentLabel;
  final List<_CashFlowCategoryData> categories;
}

class _CashFlowCategoryData {
  const _CashFlowCategoryData({
    required this.title,
    required this.transactionCount,
    required this.amountLabel,
    required this.percentLabel,
    required this.share,
    required this.icon,
    required this.color,
  });

  final String title;
  final int transactionCount;
  final String amountLabel;
  final String percentLabel;
  final double share;
  final IconData icon;
  final Color color;
}

const _cashFlowData = _CashFlowScreenData(
  insight: 'Transfer and services are driving most of this week’s spend.',
  totalSpentLabel: 'RM 258.00',
  categories: [
    _CashFlowCategoryData(
      title: 'Transfer',
      transactionCount: 4,
      amountLabel: 'RM 103.20',
      percentLabel: '40%',
      share: 0.40,
      icon: Icons.swap_horiz_rounded,
      color: Color(0xFF7A3FF2),
    ),
    _CashFlowCategoryData(
      title: 'Services',
      transactionCount: 6,
      amountLabel: 'RM 77.40',
      percentLabel: '30%',
      share: 0.30,
      icon: Icons.settings_outlined,
      color: Color(0xFFD55F93),
    ),
    _CashFlowCategoryData(
      title: 'Shops',
      transactionCount: 3,
      amountLabel: 'RM 38.70',
      percentLabel: '15%',
      share: 0.15,
      icon: Icons.storefront_outlined,
      color: Color(0xFFC5721E),
    ),
    _CashFlowCategoryData(
      title: 'Food & Drink',
      transactionCount: 8,
      amountLabel: 'RM 38.70',
      percentLabel: '15%',
      share: 0.15,
      icon: Icons.restaurant_outlined,
      color: Color(0xFFFFB8B0),
    ),
  ],
);
