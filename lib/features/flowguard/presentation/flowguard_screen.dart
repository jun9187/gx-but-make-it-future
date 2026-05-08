import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/app_progress_bar.dart';
import '../../../shared/widgets/feature_top_bar.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_card.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../../../shared/widgets/pill_badge.dart';
import '../../../shared/widgets/section_header.dart';

class FlowguardScreen extends StatelessWidget {
  const FlowguardScreen({super.key});

  static const routeName = 'flowguard';
  static const routePath = '/flowguard';

  @override
  Widget build(BuildContext context) {
    const data = _flowGuardData;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          120,
        ),
        children: [
          const FeatureTopBar(
            title: 'FlowGuard',
          ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: AppSpacing.xl),
          _StatusCard(data: data.status)
              .animate()
              .fadeIn(delay: 60.ms, duration: 280.ms)
              .slideY(begin: 0.08, end: 0),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Pre-Commitment Guardrails'),
          const SizedBox(height: AppSpacing.md),
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < data.guardrails.length; i++) ...[
                  _GuardrailRow(data: data.guardrails[i]),
                  if (i != data.guardrails.length - 1)
                    Divider(
                      height: 1,
                      color: AppColors.stroke.withValues(alpha: 0.8),
                    ),
                ],
              ],
            ),
          ).animate().fadeIn(delay: 180.ms, duration: 280.ms),
          const SizedBox(height: AppSpacing.xl),
          _RecoveryNudgeCard(data: data.recoveryNudge)
              .animate()
              .fadeIn(delay: 240.ms, duration: 300.ms)
              .slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.data});

  final _StatusCardData data;

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
            'FlowGuard',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You have spent ${formatCurrency(data.spentToday)} today, ${formatCurrency(data.overLimitAmount)} above your daily safe limit.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.94),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppProgressBar(
                  value: data.progress,
                  height: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF3D4F), Color(0xFFFF005C)],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: Text(
                    'SAFE LIMIT: ${formatCurrency(data.safeLimit)} / ${formatCurrency(data.spentToday)}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 0.4,
                    ),
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

class _GuardrailRow extends StatelessWidget {
  const _GuardrailRow({required this.data});

  final _GuardrailData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            backgroundColor: data.accentColor.withValues(alpha: 0.12),
            color: data.accentColor,
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
          if (data.state == _GuardrailState.active)
            PillBadge(label: 'Active', isSelected: true)
          else if (data.state == _GuardrailState.locked)
            const Icon(
              Icons.lock_outline_rounded,
              size: 18,
              color: AppColors.textSecondary,
            )
          else
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
        ],
      ),
    );
  }
}

class _RecoveryNudgeCard extends StatelessWidget {
  const _RecoveryNudgeCard({required this.data});

  final _RecoveryNudgeData data;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconCircle(
                icon: Icons.call_split_rounded,
                size: 32,
                iconSize: 16,
                gradient: LinearGradient(
                  colors: [AppColors.heroStart, AppColors.heroEnd],
                ),
                color: Colors.white,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  data.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                data.timestamp,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE6C7FF), Color(0xFFCAA8FF)],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF4C1A7A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('ACCEPT'),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: BorderSide(
                      color: AppColors.strokeStrong.withValues(alpha: 0.55),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('DISMISS'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlowGuardScreenData {
  const _FlowGuardScreenData({
    required this.status,
    required this.guardrails,
    required this.recoveryNudge,
  });

  final _StatusCardData status;
  final List<_GuardrailData> guardrails;
  final _RecoveryNudgeData recoveryNudge;
}

class _StatusCardData {
  const _StatusCardData({
    required this.spentToday,
    required this.safeLimit,
    required this.overLimitAmount,
  });

  final double spentToday;
  final double safeLimit;
  final double overLimitAmount;

  double get progress => spentToday == 0 ? 0 : safeLimit / spentToday;
}

enum _GuardrailState { standard, active, locked }

class _GuardrailData {
  const _GuardrailData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.state,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final _GuardrailState state;
}

class _RecoveryNudgeData {
  const _RecoveryNudgeData({
    required this.title,
    required this.timestamp,
    required this.message,
  });

  final String title;
  final String timestamp;
  final String message;
}

const _flowGuardData = _FlowGuardScreenData(
  status: _StatusCardData(spentToday: 64, safeLimit: 42, overLimitAmount: 22),
  guardrails: [
    _GuardrailData(
      title: 'Daily Flexible Spending',
      subtitle: 'RM25/day',
      icon: Icons.account_balance_wallet_outlined,
      accentColor: Color(0xFFB48CFF),
      state: _GuardrailState.standard,
    ),
    _GuardrailData(
      title: 'E-commerce Cap',
      subtitle: 'RM60/week',
      icon: Icons.shopping_cart_outlined,
      accentColor: Color(0xFFE49A67),
      state: _GuardrailState.standard,
    ),
    _GuardrailData(
      title: 'Food Delivery Cap',
      subtitle: 'RM50/week',
      icon: Icons.storefront_outlined,
      accentColor: Color(0xFFF0A76C),
      state: _GuardrailState.standard,
    ),
    _GuardrailData(
      title: 'Weekend Social Spending',
      subtitle: 'RM80/week',
      icon: Icons.celebration_outlined,
      accentColor: Color(0xFF8E7BC8),
      state: _GuardrailState.standard,
    ),
    _GuardrailData(
      title: 'Emergency Buffer Lock',
      subtitle: 'RM200',
      icon: Icons.shield_outlined,
      accentColor: Color(0xFFC94F66),
      state: _GuardrailState.locked,
    ),
    _GuardrailData(
      title: 'Night Calm Lock',
      subtitle: '11 PM to 6 AM (self-control mode)',
      icon: Icons.dark_mode_outlined,
      accentColor: Color(0xFF7280FF),
      state: _GuardrailState.active,
    ),
  ],
  recoveryNudge: _RecoveryNudgeData(
    title: 'Recovery Nudge',
    timestamp: 'JUST NOW',
    message:
        'You spent RM64 today, RM22 above pace. Reduce tomorrow\'s limit to RM18?',
  ),
);
