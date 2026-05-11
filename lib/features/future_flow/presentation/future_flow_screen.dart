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
import '../../../shared/widgets/feature_top_bar.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_card.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../../../shared/widgets/section_header.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class FutureFlowScreen extends StatelessWidget {
  const FutureFlowScreen({super.key});

  static const routeName = 'future-flow';
  static const routePath = '/future-flow';

  @override
  Widget build(BuildContext context) {
    const screenData = futureFlowScreenData;

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
            title: 'Future Flow',
            onLeadingTap: () => _goBackOrDashboard(context),
          ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: AppSpacing.xl),
          _FutureFlowHeroCard(data: screenData.hero)
              .animate()
              .fadeIn(delay: 60.ms, duration: 280.ms)
              .slideY(begin: 0.08, end: 0),
          const SizedBox(height: AppSpacing.lg),
          _DecisionSummaryRow(
            data: screenData,
          ).animate().fadeIn(delay: 120.ms, duration: 280.ms),
          const SizedBox(height: AppSpacing.lg),
          _PredictionCard(data: screenData)
              .animate()
              .fadeIn(delay: 180.ms, duration: 280.ms)
              .slideY(begin: 0.05, end: 0),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            title: 'Upcoming Commitments',
            subtitle: 'Protected before you make today’s spending decision.',
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < screenData.commitments.length; i++) ...[
            _CommitmentTile(data: screenData.commitments[i]).animate().fadeIn(
              delay: Duration(milliseconds: 260 + (i * 60)),
              duration: 260.ms,
            ),
            if (i != screenData.commitments.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            title: 'Recent Activity',
            subtitle: 'Latest signals shaping your safe-to-spend forecast.',
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < screenData.activities.length; i++) ...[
            _TransactionTile(data: screenData.activities[i]).animate().fadeIn(
              delay: Duration(milliseconds: 420 + (i * 60)),
              duration: 260.ms,
            ),
            if (i != screenData.activities.length - 1)
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

class _FutureFlowHeroCard extends StatelessWidget {
  const _FutureFlowHeroCard({required this.data});

  final FutureFlowHeroData data;

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.heroStart, AppColors.heroEnd],
      ),
      borderColor: const Color(0x40FFFFFF),
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
              color: Colors.white.withValues(alpha: 0.82),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            data.obscuredBalance,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'WEEKLY SAFE TO SPEND',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.84),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            formatCurrency(data.safeToSpend),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _ProgressInfoRow(
            label: 'WEEKLY SPENT',
            rightValue:
                '${formatCurrency(data.weeklySpentCurrent)} / ${formatCurrency(data.weeklySpentLimit)}',
            progress: data.weeklySpentProgress,
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProgressInfoRow(
            label: 'TODAY\'S LIMIT',
            rightValue:
                '${formatCurrency(data.todayLimitCurrent)} / ${formatCurrency(data.todayLimitMax)}',
            progress: data.todayLimitProgress,
          ),
        ],
      ),
    );
  }
}

class _ProgressInfoRow extends StatelessWidget {
  const _ProgressInfoRow({
    required this.label,
    required this.rightValue,
    required this.progress,
  });

  final String label;
  final String rightValue;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: Colors.white.withValues(alpha: 0.82),
      letterSpacing: 1.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: labelStyle)),
            Text(rightValue, textAlign: TextAlign.right, style: labelStyle),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        AppProgressBar(
          value: progress,
          height: 8,
          backgroundColor: const Color(0x44FFFFFF),
          gradient: label == 'TODAY\'S LIMIT'
              ? const LinearGradient(
                  colors: [Color(0xFFFFA86A), Color(0xFFFF668F)],
                )
              : const LinearGradient(
                  colors: [Color(0xFFFFD67C), Color(0xFFFF7FB7)],
                ),
        ),
      ],
    );
  }
}

class _DecisionSummaryRow extends StatelessWidget {
  const _DecisionSummaryRow({required this.data});

  final FutureFlowScreenData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Upcoming Commitments',
            value: formatCurrency(data.upcomingCommitmentsTotal),
            caption: 'Protected this week',
            icon: Icons.event_note_rounded,
            iconColor: const Color(0xFFFFC96B),
            iconBackground: const Color(0x26FF9D5C),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _SummaryCard(
            title: 'Risk Level',
            value: data.riskLevelLabel,
            caption: 'Based on pace + commitments',
            icon: Icons.shield_moon_rounded,
            iconColor: const Color(0xFFCAA5FF),
            iconBackground: const Color(0x247C4DFF),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  final String title;
  final String value;
  final String caption;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

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
          Text(title, style: Theme.of(context).textTheme.labelMedium),
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

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({required this.data});

  final FutureFlowScreenData data;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconCircle(
                icon: Icons.show_chart_rounded,
                size: 34,
                iconSize: 16,
                backgroundColor: Color(0x247C4DFF),
                color: Color(0xFFD7C4FF),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Predicted End-Of-Week Spending',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            formatCurrency(data.predictedEndWeekSpending),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            data.riskLevelCaption,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
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
                    'Projected week-end balance',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  formatCurrency(data.predictedEndWeekBalance),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.data});

  final ActivityEntryData data;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          IconCircle(
            icon: data.icon,
            size: 40,
            iconSize: 18,
            backgroundColor: data.iconBackground,
            color: data.iconColor,
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
                  '${data.subtitle} • ${data.timeLabel}',
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
            child: Text(
              data.amountLabel,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: data.isPositive
                    ? const Color(0xFFFFC96B)
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommitmentTile extends StatelessWidget {
  const _CommitmentTile({required this.data});

  final CommitmentEntryData data;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          IconCircle(
            icon: data.icon,
            size: 42,
            iconSize: 18,
            backgroundColor: data.iconBackground,
            color: data.iconColor,
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
                  data.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 92,
            child: Text(
              data.amountLabel,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
