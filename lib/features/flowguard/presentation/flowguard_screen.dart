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

const double _shellNavClearance = 18;
const double _listBottomPadding = 188;
const double _statusHeaderHeight = 40;

enum _FlowGuardPromptType { nightLock, recoveryNudge }

class FlowguardScreen extends StatefulWidget {
  const FlowguardScreen({super.key});

  static const routeName = 'flowguard';
  static const routePath = '/flowguard';

  @override
  State<FlowguardScreen> createState() => _FlowguardScreenState();
}

class _FlowguardScreenState extends State<FlowguardScreen> {
  bool _showAcceptedMessage = false;
  bool _nightLockEnabled = false;
  String? _acceptedMessageText;
  _FlowGuardPromptType? _activePrompt = _FlowGuardPromptType.nightLock;
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
              _listBottomPadding,
            ),
            children: [
              FeatureTopBar(
                title: 'FlowGuard',
                onLeadingTap: () => _goBackOrDashboard(context),
              ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.xl),
              _StatusCard(
                data: data.status,
                isNightLockEnabled: _nightLockEnabled,
              )
                  .animate()
                  .fadeIn(delay: 60.ms, duration: 280.ms)
                  .slideY(begin: 0.08, end: 0),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'Guardrail'),
              const SizedBox(height: AppSpacing.md),
              for (var i = 0; i < data.guardrails.length; i++) ...[
                _GuardrailOptionCard(
                  data: data.guardrails[i],
                  isNightLockEnabled: _nightLockEnabled,
                  onTap: () => _handleGuardrailTap(data.guardrails[i]),
                ).animate().fadeIn(
                  delay: Duration(milliseconds: 180 + (i * 60)),
                  duration: 280.ms,
                ),
                if (i != data.guardrails.length - 1)
                  const SizedBox(height: AppSpacing.md),
              ],
            ],
          ),
          if (_activePrompt != null)
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: _shellNavClearance,
              child: _RecoveryNudgeOverlay(
                data: _promptData(data),
                onAccept: _handleAccept,
                onDismiss: _handleDismiss,
              ),
            ),
          if (_showAcceptedMessage)
            Positioned(
              left: AppSpacing.xl,
              right: AppSpacing.xl,
              bottom: _shellNavClearance + 10,
              child: _AcceptedMessage(message: _acceptedMessageText ?? ''),
            ),
        ],
      ),
    );
  }

  RecoveryNudgeData _promptData(FlowGuardScreenData data) {
    switch (_activePrompt) {
      case _FlowGuardPromptType.recoveryNudge:
        return const RecoveryNudgeData(
          title: 'Open Recovery Nudge?',
          timestamp: '11:43 PM',
          message:
              'You already spent above your safe limit today. Do you want FlowGuard to reduce tomorrow\'s limit to RM18 so you can recover your pace?',
        );
      case _FlowGuardPromptType.nightLock:
      case null:
        return data.recoveryNudge;
    }
  }

  void _handleGuardrailTap(FlowGuardOptionData option) {
    setState(() {
      _showAcceptedMessage = false;
      _activePrompt = option.title == 'Recovery Nudge'
          ? _FlowGuardPromptType.recoveryNudge
          : _FlowGuardPromptType.nightLock;
    });
  }

  void _handleAccept() {
    final prompt = _activePrompt;

    setState(() {
      _activePrompt = null;
      _showAcceptedMessage = true;
      if (prompt == _FlowGuardPromptType.recoveryNudge) {
        _acceptedMessageText =
            'Tomorrow\'s spending limit is now reduced to RM18 to help you recover your pace.';
      } else {
        _nightLockEnabled = true;
        _acceptedMessageText =
            'Night Lock is now active from 11 PM to 6 AM.';
      }
    });

    _acceptedMessageTimer?.cancel();
    _acceptedMessageTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() => _showAcceptedMessage = false);
      }
    });
  }

  void _handleDismiss() {
    setState(() => _activePrompt = null);
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
  const _StatusCard({
    required this.data,
    required this.isNightLockEnabled,
  });

  final FlowGuardStatusData data;
  final bool isNightLockEnabled;

  @override
  Widget build(BuildContext context) {
    final spentRatio = data.safeLimit == 0
        ? 0.0
        : data.spentToday / data.safeLimit;
    final isOverLimit = data.spentToday > data.safeLimit;

    return GradientCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gradient: isNightLockEnabled
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF151728), Color(0xFF2A2144), Color(0xFF43305B)],
            )
          : const LinearGradient(
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
          SizedBox(
            height: _statusHeaderHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'FlowGuard',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: isNightLockEnabled ? 1 : 0,
                  child: IgnorePointer(
                    ignoring: !isNightLockEnabled,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.nights_stay_rounded,
                            size: 16,
                            color: Color(0xFFE3D7FF),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Night Lock On',
                            style: Theme.of(
                              context,
                            ).textTheme.labelMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.92),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isNightLockEnabled
                  ? Colors.black.withValues(alpha: 0.24)
                  : Colors.black.withValues(alpha: 0.12),
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

class _GuardrailOptionCard extends StatelessWidget {
  const _GuardrailOptionCard({
    required this.data,
    required this.isNightLockEnabled,
    this.onTap,
  });

  final FlowGuardOptionData data;
  final bool isNightLockEnabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isNightLock = data.title == 'Night Lock';
    final isRecoveryNudge = data.title == 'Recovery Nudge';
    final isActive = isNightLock
        ? isNightLockEnabled
        : data.state == FlowGuardOptionState.active;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: GlassCard(
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: isActive
                    ? data.accentColor.withValues(alpha: 0.4)
                    : AppColors.stroke.withValues(alpha: 0.85),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  data.accentColor.withValues(alpha: isActive ? 0.18 : 0.10),
                  AppColors.surface.withValues(alpha: 0.88),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconCircle(
                        icon: data.icon,
                        size: 44,
                        iconSize: 20,
                        backgroundColor: data.accentColor.withValues(alpha: 0.16),
                        color: data.accentColor,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          data.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (isRecoveryNudge)
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0x26FF5C6D),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(0x66FF7C8B),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '!',
                            style: TextStyle(
                              color: Color(0xFFFF7E8D),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      else
                        PillBadge(
                          label: isActive ? 'Active' : 'Inactive',
                          isSelected: isActive,
                        ),
                    ],
                  ),
                  if (data.subtitle.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      data.subtitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
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
              IconCircle(
                icon: data.title.contains('Recovery')
                    ? Icons.error_outline_rounded
                    : Icons.dark_mode_outlined,
                size: 34,
                iconSize: 16,
                backgroundColor: data.title.contains('Recovery')
                    ? const Color(0x26FF5C6D)
                    : null,
                gradient: data.title.contains('Recovery')
                    ? null
                    : const LinearGradient(
                        colors: [AppColors.heroStart, AppColors.heroEnd],
                      ),
                color: data.title.contains('Recovery')
                    ? const Color(0xFFFFA1AE)
                    : Colors.white,
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
                    child: Text(
                      data.title.contains('Recovery')
                          ? 'LIMIT TOMORROW'
                          : 'OPEN NIGHT LOCK',
                    ),
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
                  child: Text(
                    data.title.contains('Recovery') ? 'NOT NOW' : 'NOT NOW',
                  ),
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
  const _AcceptedMessage({required this.message});

  final String message;

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
                  message,
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
