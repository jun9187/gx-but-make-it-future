import 'dart:async';

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
import '../../../shared/widgets/pill_badge.dart';
import '../../../shared/widgets/section_header.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

const double _floatingNudgeBottom = 70;

class FlowguardScreen extends StatefulWidget {
  const FlowguardScreen({super.key});

  static const routeName = 'flowguard';
  static const routePath = '/flowguard';

  @override
  State<FlowguardScreen> createState() => _FlowguardScreenState();
}

class _FlowguardScreenState extends State<FlowguardScreen> {
  bool _showNudge = true;
  bool _showAcceptedMessage = false;
  Timer? _acceptedMessageTimer;

  @override
  void dispose() {
    _acceptedMessageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const data = flowGuardScreenData;

    return SafeArea(
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              300,
            ),
            children: [
              FeatureTopBar(
                title: 'FlowGuard',
                onLeadingTap: () => _goBackOrDashboard(context),
              ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.xl),
              _StatusCard(data: data.status)
                  .animate()
                  .fadeIn(delay: 60.ms, duration: 280.ms)
                  .slideY(begin: 0.08, end: 0),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'Budgets'),
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
            ],
          ),
          if (_showNudge)
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: _floatingNudgeBottom,
              child: _RecoveryNudgeOverlay(
                data: data.recoveryNudge,
                onAccept: _handleAccept,
                onDismiss: _handleDismiss,
              ),
            ),
          if (_showAcceptedMessage)
            Positioned(
              left: AppSpacing.xl,
              right: AppSpacing.xl,
              bottom: _floatingNudgeBottom + 18,
              child: const _AcceptedMessage(),
            ),
        ],
      ),
    );
  }

  void _handleAccept() {
    setState(() {
      _showNudge = false;
      _showAcceptedMessage = true;
    });

    _acceptedMessageTimer?.cancel();
    _acceptedMessageTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() => _showAcceptedMessage = false);
      }
    });
  }

  void _handleDismiss() {
    setState(() => _showNudge = false);
  }
}

void _goBackOrDashboard(BuildContext context) {
  if (context.canPop()) {
    context.pop();
    return;
  }
  context.go(DashboardScreen.routePath);
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.data});

  final FlowGuardStatusData data;

  @override
  Widget build(BuildContext context) {
    final spentRatio = data.safeLimit == 0
        ? 0.0
        : data.spentToday / data.safeLimit;
    final isOverLimit = data.spentToday > data.safeLimit;

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
                  value: spentRatio,
                  height: 8,
                  backgroundColor: isOverLimit
                      ? const Color(0x66FF6A7E)
                      : Colors.white.withValues(alpha: 0.15),
                  gradient: isOverLimit
                      ? const LinearGradient(
                          colors: [Color(0xFFFF5C6D), Color(0xFFFF003D)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFFFFA35C), Color(0xFFFF5C8A)],
                        ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: Text(
                    'SPENT TODAY: ${formatCurrency(data.spentToday)} / SAFE LIMIT ${formatCurrency(data.safeLimit)}',
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

  final FlowGuardOptionData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          if (data.state == FlowGuardOptionState.active)
            PillBadge(label: 'Active', isSelected: true)
          else if (data.state == FlowGuardOptionState.locked)
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

class _RecoveryNudgeOverlay extends StatelessWidget {
  const _RecoveryNudgeOverlay({
    required this.data,
    required this.onAccept,
    required this.onDismiss,
  });

  final RecoveryNudgeData data;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconCircle(
                icon: Icons.trending_down_rounded,
                size: 34,
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
                    onPressed: onAccept,
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
                  onPressed: onDismiss,
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
    ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.06, end: 0);
  }
}

class _AcceptedMessage extends StatelessWidget {
  const _AcceptedMessage();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              const IconCircle(
                icon: Icons.check_rounded,
                size: 32,
                iconSize: 16,
                backgroundColor: Color(0x2636D99F),
                color: Color(0xFFBFF7DF),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Tomorrow’s spending limit adjusted. FlowGuard recovery plan is now active.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 180.ms)
        .slideY(begin: 0.04, end: 0)
        .fadeOut(delay: 1300.ms, duration: 280.ms);
  }
}
