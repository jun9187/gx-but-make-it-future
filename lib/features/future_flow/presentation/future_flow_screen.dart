import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
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
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Recent Activity', actionLabel: 'See all'),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < screenData.activities.length; i++) ...[
            _TransactionTile(data: screenData.activities[i]).animate().fadeIn(
              delay: Duration(milliseconds: 180 + (i * 60)),
              duration: 260.ms,
            ),
            if (i != screenData.activities.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            title: 'Future Commitments',
            actionLabel: 'See all',
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < screenData.commitments.length; i++) ...[
            _CommitmentTile(data: screenData.commitments[i]).animate().fadeIn(
              delay: Duration(milliseconds: 320 + (i * 60)),
              duration: 260.ms,
            ),
            if (i != screenData.commitments.length - 1)
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
            'SAFE TO SPEND',
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
            leftValue: '',
            rightValue:
                '${formatCurrency(data.weeklySpentCurrent)} / ${formatCurrency(data.weeklySpentLimit)}',
            progress: data.weeklySpentProgress,
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProgressInfoRow(
            label: 'TODAY\'S LIMIT',
            leftValue: '',
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
    required this.leftValue,
    required this.rightValue,
    required this.progress,
  });

  final String label;
  final String leftValue;
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
            if (leftValue.isNotEmpty)
              Text(leftValue, textAlign: TextAlign.right, style: labelStyle),
            Text(rightValue, textAlign: TextAlign.right, style: labelStyle),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        AppProgressBar(
          value: progress,
          height: 6,
          backgroundColor: Colors.white.withValues(alpha: 0.18),
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFF7E8FF)],
          ),
        ),
      ],
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
