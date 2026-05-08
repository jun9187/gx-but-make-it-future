import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/mock/app_mock_data.dart';
import '../../../shared/widgets/feature_top_bar.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class AutoSaveHistoryScreen extends StatelessWidget {
  const AutoSaveHistoryScreen({super.key});

  static const routeName = 'auto-save-history';
  static const routePath = '/auto-save-history';

  @override
  Widget build(BuildContext context) {
    const data = autoSaveHistoryScreenData;
    final maxAmount = data.history
        .map((point) => point.amount)
        .fold<double>(0, (prev, next) => next > prev ? next : prev);

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
            title: 'Auto-Save History',
            onLeadingTap: () => _goBackOrDashboard(context),
          ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Previous Week Auto-Saved',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            formatCurrency(data.currentWeekAmount),
            style: Theme.of(context).textTheme.displaySmall,
          ).animate().fadeIn(delay: 60.ms, duration: 260.ms),
          const SizedBox(height: AppSpacing.sm),
          Text(
            data.insight,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          GlassCard(
            child: SizedBox(
              height: 260,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  maxY: maxAmount + 10,
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: 10,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.white.withValues(alpha: 0.08),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        interval: 10,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.textMuted),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= data.history.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              data.history[index].weekLabel,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < data.history.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: data.history[i].amount,
                            width: 22,
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: i == data.history.length - 1
                                  ? const [Color(0xFFD946EF), Color(0xFF7639FF)]
                                  : const [
                                      Color(0xFFCAA5FF),
                                      Color(0xFF8C66FF),
                                    ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 140.ms, duration: 280.ms),
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
