import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/app_progress_bar.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_card.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../../cash_flow/presentation/cash_flow_screen.dart';
import '../../flowguard/presentation/flowguard_screen.dart';
import '../../future_home/presentation/future_home_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const routeName = 'dashboard';
  static const routePath = '/dashboard';

  @override
  Widget build(BuildContext context) {
    const dashboard = _dashboardData;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          120,
        ),
        children: [
          AppTopBar(
            title: 'FutureFlow',
            eyebrow: 'Your money, made clearer',
            trailing: const IconCircle(
              icon: Icons.notifications_none_rounded,
              size: 40,
              iconSize: 18,
            ),
          ).animate().fadeIn(duration: 240.ms).slideY(begin: 0.06, end: 0),
          _BalanceHeroCard(data: dashboard.hero)
              .animate()
              .fadeIn(delay: 60.ms, duration: 280.ms)
              .slideY(begin: 0.08, end: 0),
          const SizedBox(height: AppSpacing.xl),
          _DashboardCardLink(
            onTap: () => context.go(CashFlowScreen.routePath),
            child: _CashFlowPreviewCard(
              data: dashboard.cashFlow,
              categories: dashboard.categories,
            ),
          ).animate().fadeIn(delay: 120.ms, duration: 280.ms),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _MetricOverviewCard(
                  title: 'Streak',
                  value: '${dashboard.streakWeeks} Weeks',
                  caption: 'Staying under safe-to-spend',
                  icon: Icons.bolt_rounded,
                  iconBackground: const Color(0x26FF9D5C),
                  iconColor: const Color(0xFFFFC96B),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _DashboardCardLink(
                  onTap: () => context.go(FlowguardScreen.routePath),
                  child: _MetricOverviewCard(
                    title: 'FlowGuard',
                    value: dashboard.flowGuardStatus,
                    caption: dashboard.flowGuardCaption,
                    icon: Icons.shield_rounded,
                    iconBackground: const Color(0x247C4DFF),
                    iconColor: const Color(0xFFB48CFF),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 180.ms, duration: 280.ms),
          const SizedBox(height: AppSpacing.lg),
          _DashboardCardLink(
            onTap: () => context.go(FutureHomeScreen.routePath),
            child: _FutureHomePreviewCard(data: dashboard.futureHome),
          ).animate().fadeIn(delay: 240.ms, duration: 320.ms),
        ],
      ),
    );
  }
}

class _DashboardCardLink extends StatelessWidget {
  const _DashboardCardLink({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: child,
      ),
    );
  }
}

class _BalanceHeroCard extends StatelessWidget {
  const _BalanceHeroCard({required this.data});

  final _DashboardHeroData data;

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.heroStart, AppColors.heroEnd],
      ),
      borderColor: const Color(0x3DFFFFFF),
      boxShadow: const [
        BoxShadow(
          color: Color(0x66301358),
          blurRadius: 34,
          offset: Offset(0, 18),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT BALANCE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  formatCurrency(data.currentBalance),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'Safe to Spend',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppProgressBar(
            value: data.spentRatio,
            height: 7,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF7E8FF)],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  'SPENT: ${formatCurrency(data.spentAmount)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
              ),
              Text(
                'LIMIT: ${formatCurrency(data.limitAmount)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CashFlowPreviewCard extends StatelessWidget {
  const _CashFlowPreviewCard({required this.data, required this.categories});

  final _CashFlowPreviewData data;
  final List<_CategoryData> categories;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Cash Flow',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(
                'View details',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: SizedBox(
                    width: 148,
                    height: 148,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            centerSpaceRadius: 42,
                            sectionsSpace: 0,
                            startDegreeOffset: -90,
                            sections: [
                              for (final category in categories)
                                PieChartSectionData(
                                  color: category.color,
                                  value: category.share * 100,
                                  radius: 18,
                                  title: '',
                                ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'TOTAL',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              formatCurrency(data.totalSpent),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final category in categories) ...[
                      _LegendDot(label: category.label, color: category.color),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.insight,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricOverviewCard extends StatelessWidget {
  const _MetricOverviewCard({
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
  });

  final String title;
  final String value;
  final String caption;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconCircle(
            icon: icon,
            size: 34,
            iconSize: 16,
            backgroundColor: iconBackground,
            color: iconColor,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            caption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _FutureHomePreviewCard extends StatelessWidget {
  const _FutureHomePreviewCard({required this.data});

  final _FutureHomePreviewData data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: SizedBox(
        height: 146,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFDFC4A6), Color(0xFF8A5B40)],
                ),
                border: Border.all(color: AppColors.stroke),
              ),
            ),
            const Positioned.fill(child: _RoomSceneArtwork()),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withValues(alpha: 0.82),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const IconCircle(
                              icon: Icons.forest_rounded,
                              size: 28,
                              iconSize: 14,
                              backgroundColor: Color(0x66B7F57B),
                              color: Color(0xFFE9FFE0),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'REWARD SPACE',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.62),
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              data.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          data.subtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.84),
                                height: 1.35,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.74),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: AppColors.stroke),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.monetization_on_rounded,
                          size: 16,
                          color: Color(0xFFFFB85C),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '${data.coinBalance} Coins',
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _RoomSceneArtwork extends StatelessWidget {
  const _RoomSceneArtwork();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 18,
          top: 18,
          child: Container(
            width: 64,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF8C4C36).withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 18,
          child: Container(
            width: 70,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.24),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.38)),
            ),
          ),
        ),
        Positioned(
          left: 92,
          top: 72,
          child: Transform.rotate(
            angle: -0.08,
            child: Container(
              width: 54,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFC49563),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        Positioned(
          right: 24,
          bottom: 32,
          child: Container(
            width: 82,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFB97C4F),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Positioned(
          left: 18,
          bottom: 26,
          child: Container(
            width: 56,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF5C412F),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashboardData {
  const _DashboardData({
    required this.hero,
    required this.cashFlow,
    required this.categories,
    required this.streakWeeks,
    required this.flowGuardStatus,
    required this.flowGuardCaption,
    required this.futureHome,
  });

  final _DashboardHeroData hero;
  final _CashFlowPreviewData cashFlow;
  final List<_CategoryData> categories;
  final int streakWeeks;
  final String flowGuardStatus;
  final String flowGuardCaption;
  final _FutureHomePreviewData futureHome;
}

class _DashboardHeroData {
  const _DashboardHeroData({
    required this.currentBalance,
    required this.spentAmount,
    required this.limitAmount,
  });

  final double currentBalance;
  final double spentAmount;
  final double limitAmount;

  double get spentRatio => limitAmount == 0 ? 0 : spentAmount / limitAmount;
}

class _CashFlowPreviewData {
  const _CashFlowPreviewData({required this.totalSpent, required this.insight});

  final double totalSpent;
  final String insight;
}

class _CategoryData {
  const _CategoryData({
    required this.label,
    required this.share,
    required this.color,
  });

  final String label;
  final double share;
  final Color color;
}

class _FutureHomePreviewData {
  const _FutureHomePreviewData({
    required this.title,
    required this.subtitle,
    required this.coinBalance,
  });

  final String title;
  final String subtitle;
  final int coinBalance;
}

const _dashboardData = _DashboardData(
  hero: _DashboardHeroData(
    currentBalance: 142,
    spentAmount: 258,
    limitAmount: 400,
  ),
  cashFlow: _CashFlowPreviewData(
    totalSpent: 258,
    insight: 'Your spending is 12% lower than last week. Great job!',
  ),
  categories: [
    _CategoryData(label: 'Transfer', share: 0.40, color: Color(0xFF7A3FF2)),
    _CategoryData(label: 'Services', share: 0.30, color: Color(0xFFFFB38B)),
    _CategoryData(label: 'Shops', share: 0.15, color: Color(0xFFE3008C)),
    _CategoryData(label: 'Food & Drink', share: 0.15, color: Color(0xFFFFB9D4)),
  ],
  streakWeeks: 3,
  flowGuardStatus: 'Active',
  flowGuardCaption: 'Daily alerts and spending nudges are on.',
  futureHome: _FutureHomePreviewData(
    title: 'Future Home',
    subtitle: 'Customize your digital sanctuary',
    coinBalance: 450,
  ),
);
