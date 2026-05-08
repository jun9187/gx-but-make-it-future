import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/mock/app_mock_data.dart';
import '../../../data/models/app_mock_models.dart';
import '../../../shared/widgets/app_progress_bar.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_card.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../../cash_flow/presentation/cash_flow_screen.dart';
import '../../flowguard/presentation/flowguard_screen.dart';
import '../../auto_save_history/presentation/auto_save_history_screen.dart';
import '../../future_flow/presentation/future_flow_screen.dart';
import '../../future_home/presentation/future_home_screen.dart';
import '../../savings_pockets/presentation/savings_pockets_screen.dart';

const double _shellBottomBarClearance = 96;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const routeName = 'dashboard';
  static const routePath = '/dashboard';

  @override
  Widget build(BuildContext context) {
    const dashboard = dashboardScreenData;

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
          _DashboardCardLink(
                onTap: () => context.push(FutureFlowScreen.routePath),
                child: _BalanceHeroCard(data: dashboard.hero),
              )
              .animate()
              .fadeIn(delay: 60.ms, duration: 280.ms)
              .slideY(begin: 0.08, end: 0),
          const SizedBox(height: AppSpacing.xl),
          _DashboardCardLink(
            onTap: () => context.push(CashFlowScreen.routePath),
            child: _CashFlowPreviewCard(
              data: dashboard.cashFlow,
              categories: dashboard.categories,
            ),
          ).animate().fadeIn(delay: 120.ms, duration: 280.ms),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DashboardCardLink(
                  onTap: () => _showAutoSaveSheet(context),
                  child: SizedBox(
                    height: 198,
                    child: _MetricOverviewCard(
                      title: 'Streak',
                      value: '${dashboard.streakWeeks} Weeks',
                      caption: 'Staying under safe-to-spend',
                      icon: Icons.bolt_rounded,
                      iconBackground: const Color(0x26FF9D5C),
                      iconColor: const Color(0xFFFFC96B),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _DashboardCardLink(
                  onTap: () => context.push(FlowguardScreen.routePath),
                  child: SizedBox(
                    height: 198,
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
              ),
            ],
          ).animate().fadeIn(delay: 180.ms, duration: 280.ms),
          const SizedBox(height: AppSpacing.lg),
          _DashboardCardLink(
            onTap: () => context.push(FutureHomeScreen.routePath),
            child: _FutureHomePreviewCard(data: dashboard.rewardStatus),
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

  final DashboardHeroData data;

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
            'WEEKLY SAFE TO SPEND',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            formatCurrency(data.currentBalance),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppProgressBar(
            value: data.spentRatio,
            height: 8,
            backgroundColor: const Color(0x44FFFFFF),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD67C), Color(0xFFFF7FB7)],
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

  final CashFlowOverviewData data;
  final List<SpendingCategoryData> categories;

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
                      _LegendDot(label: category.title, color: category.color),
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
          Expanded(
            child: Text(
              caption,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _FutureHomePreviewCard extends StatelessWidget {
  const _FutureHomePreviewCard({required this.data});

  final RewardStatusData data;

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
                        const IconCircle(
                          icon: Icons.forest_rounded,
                          size: 28,
                          iconSize: 14,
                          backgroundColor: Color(0x66B7F57B),
                          color: Color(0xFFE9FFE0),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'REWARD SPACE',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.62),
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          data.rewardTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          data.rewardSubtitle,
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
                          '${data.coins} Coins',
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

Future<void> _showAutoSaveSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: _shellBottomBarClearance),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xxl),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Auto-Save + Streak',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Because you stayed within your weekly safe flow, FutureFlow auto-moved leftover money into your GX Savings Pocket.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _SheetMetric(
                label: 'Previous week auto-saved',
                value: formatCurrency(rewardStatusData.autoSavedAmount),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(AutoSaveHistoryScreen.routePath);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _SheetMetric(
                label: 'Savings Pocket balance',
                value: formatCurrency(rewardStatusData.savingsPocketBalance),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(SavingsPocketsScreen.routePath);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _SheetMetric(
                label: 'Current streak',
                value: '${rewardStatusData.streakWeeks} weeks',
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _SheetMetric extends StatelessWidget {
  const _SheetMetric({required this.label, required this.value, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
              if (onTap != null) ...[
                const SizedBox(width: AppSpacing.xs),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ],
          ),
        ),
      ),
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
