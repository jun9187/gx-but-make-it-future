import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/app_progress_bar.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_card.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../../../shared/widgets/section_header.dart';

class FutureFlowScreen extends StatelessWidget {
  const FutureFlowScreen({super.key});

  static const routeName = 'future-flow';
  static const routePath = '/future-flow';

  @override
  Widget build(BuildContext context) {
    const screenData = _screenData;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          120,
        ),
        children: [
          const _FutureFlowTopBar()
              .animate()
              .fadeIn(duration: 220.ms)
              .slideY(begin: 0.05, end: 0),
          const SizedBox(height: AppSpacing.xl),
          _FutureFlowHeroCard(data: screenData.hero)
              .animate()
              .fadeIn(delay: 60.ms, duration: 280.ms)
              .slideY(begin: 0.08, end: 0),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            title: 'Recent Activity',
            actionLabel: 'See all',
          ).animate().fadeIn(delay: 120.ms, duration: 240.ms),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < screenData.activities.length; i++) ...[
            _TransactionTile(data: screenData.activities[i])
                .animate()
                .fadeIn(delay: Duration(milliseconds: 180 + (i * 60)), duration: 260.ms),
            if (i != screenData.activities.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            title: 'Future Commitments',
            actionLabel: 'See all',
          ).animate().fadeIn(delay: 280.ms, duration: 240.ms),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < screenData.commitments.length; i++) ...[
            _CommitmentTile(data: screenData.commitments[i])
                .animate()
                .fadeIn(delay: Duration(milliseconds: 320 + (i * 60)), duration: 260.ms),
            if (i != screenData.commitments.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _FutureFlowTopBar extends StatelessWidget {
  const _FutureFlowTopBar();

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
            'Future Flow',
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

class _FutureFlowHeroCard extends StatelessWidget {
  const _FutureFlowHeroCard({required this.data});

  final _HeroData data;

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.heroStart,
          AppColors.heroEnd,
        ],
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
            Expanded(
              child: Text(label, style: labelStyle),
            ),
            if (leftValue.isNotEmpty)
              Text(
                leftValue,
                textAlign: TextAlign.right,
                style: labelStyle,
              ),
            Text(
              rightValue,
              textAlign: TextAlign.right,
              style: labelStyle,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        AppProgressBar(
          value: progress,
          height: 6,
          backgroundColor: Colors.white.withValues(alpha: 0.18),
          gradient: const LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFF7E8FF),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.data});

  final _TransactionData data;

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
          Text(
            data.amountLabel,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: data.isPositive
                      ? const Color(0xFFFFC96B)
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _CommitmentTile extends StatelessWidget {
  const _CommitmentTile({required this.data});

  final _CommitmentData data;

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

class _FutureFlowScreenData {
  const _FutureFlowScreenData({
    required this.hero,
    required this.activities,
    required this.commitments,
  });

  final _HeroData hero;
  final List<_TransactionData> activities;
  final List<_CommitmentData> commitments;
}

class _HeroData {
  const _HeroData({
    required this.obscuredBalance,
    required this.safeToSpend,
    required this.weeklySpentCurrent,
    required this.weeklySpentLimit,
    required this.todayLimitCurrent,
    required this.todayLimitMax,
  });

  final String obscuredBalance;
  final double safeToSpend;
  final double weeklySpentCurrent;
  final double weeklySpentLimit;
  final double todayLimitCurrent;
  final double todayLimitMax;

  double get weeklySpentProgress =>
      weeklySpentLimit == 0 ? 0 : weeklySpentCurrent / weeklySpentLimit;

  double get todayLimitProgress =>
      todayLimitMax == 0 ? 0 : todayLimitCurrent / todayLimitMax;
}

class _TransactionData {
  const _TransactionData({
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.amountLabel,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.isPositive,
  });

  final String title;
  final String subtitle;
  final String timeLabel;
  final String amountLabel;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final bool isPositive;
}

class _CommitmentData {
  const _CommitmentData({
    required this.title,
    required this.subtitle,
    required this.amountLabel,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
  });

  final String title;
  final String subtitle;
  final String amountLabel;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
}

const _screenData = _FutureFlowScreenData(
  hero: _HeroData(
    obscuredBalance: 'RM ****',
    safeToSpend: 142,
    weeklySpentCurrent: 258,
    weeklySpentLimit: 400,
    todayLimitCurrent: 12.5,
    todayLimitMax: 42,
  ),
  activities: [
    _TransactionData(
      title: 'Starbucks',
      subtitle: 'Food & Drinks',
      timeLabel: 'Today',
      amountLabel: '-RM24.50',
      icon: Icons.local_cafe_outlined,
      iconBackground: Color(0x247C4DFF),
      iconColor: Color(0xFFB48CFF),
      isPositive: false,
    ),
    _TransactionData(
      title: 'Salary',
      subtitle: 'Income',
      timeLabel: 'Yesterday',
      amountLabel: '+RM4,500.00',
      icon: Icons.account_balance_wallet_outlined,
      iconBackground: Color(0x245C4DFF),
      iconColor: Color(0xFFD6C2FF),
      isPositive: true,
    ),
  ],
  commitments: [
    _CommitmentData(
      title: 'Rent',
      subtitle: 'Due in 4 days',
      amountLabel: 'RM200.00',
      icon: Icons.home_outlined,
      iconBackground: Color(0x24FF9D5C),
      iconColor: Color(0xFFFFC96B),
    ),
    _CommitmentData(
      title: 'Weekly Essentials',
      subtitle: 'Budget lane',
      amountLabel: 'RM180.00',
      icon: Icons.shopping_cart_outlined,
      iconBackground: Color(0x24FF4FD8),
      iconColor: Color(0xFFFF9BE7),
    ),
    _CommitmentData(
      title: 'Savings Goal',
      subtitle: 'Personal Target',
      amountLabel: 'RM100.00',
      icon: Icons.shield_outlined,
      iconBackground: Color(0x247C4DFF),
      iconColor: Color(0xFFCFAEFF),
    ),
  ],
);
