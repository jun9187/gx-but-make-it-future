import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/feature_top_bar.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_card.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../../home/presentation/gxbank_home_screen.dart';
import 'flowguard_screen.dart';

class FlowGuardQrPaymentScreen extends StatelessWidget {
  const FlowGuardQrPaymentScreen({super.key});

  static const routeName = 'flowguard-qr-demo';
  static const routePath = '/flowguard-qr-demo';

  @override
  Widget build(BuildContext context) {
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
            title: 'QR Pay',
            onLeadingTap: () => _goBackOrDashboard(context),
          ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: AppSpacing.xl),
          const _QrCanvasCard().animate().fadeIn(
            delay: 60.ms,
            duration: 280.ms,
          ),
          const SizedBox(height: AppSpacing.xl),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE6C7FF), Color(0xFFCAA8FF)],
              ),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x447F52FF),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: TextButton.icon(
              onPressed: () => context.push(FlowGuardQrConfirmScreen.routePath),
              icon: const Icon(Icons.qr_code_2_rounded, size: 18),
              label: const Text('SCAN QR'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF42165E),
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ).animate().fadeIn(delay: 240.ms, duration: 300.ms),
        ],
      ),
    );
  }
}

class FlowGuardQrConfirmScreen extends StatelessWidget {
  const FlowGuardQrConfirmScreen({super.key});

  static const routeName = 'flowguard-qr-confirm';
  static const routePath = '/flowguard-qr-confirm';

  @override
  Widget build(BuildContext context) {
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
            title: 'Confirm Payment',
            onLeadingTap: () => _goBackOrDashboard(context),
          ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: AppSpacing.xl),
          const _MerchantPaymentCard().animate().fadeIn(
            delay: 60.ms,
            duration: 280.ms,
          ),
          const SizedBox(height: AppSpacing.lg),
          const _ConfirmDetailsCard().animate().fadeIn(
            delay: 120.ms,
            duration: 280.ms,
          ),
          const SizedBox(height: AppSpacing.xl),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE6C7FF), Color(0xFFCAA8FF)],
              ),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x447F52FF),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: TextButton.icon(
              onPressed: () =>
                  context.push(FlowGuardPaymentAlertScreen.routePath),
              icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
              label: const Text('CONFIRM TRANSACTION'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF42165E),
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ).animate().fadeIn(delay: 180.ms, duration: 300.ms),
        ],
      ),
    );
  }
}

class FlowGuardPaymentAlertScreen extends StatelessWidget {
  const FlowGuardPaymentAlertScreen({super.key});

  static const routeName = 'flowguard-alert-demo';
  static const routePath = '/flowguard-alert-demo';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl + 70,
              AppSpacing.lg,
              120,
            ),
            children: [
              FeatureTopBar(
                title: 'Payment Complete',
                onLeadingTap: () => _goBackOrDashboard(context),
              ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.xl),
              const _PaymentSuccessCard().animate().fadeIn(
                delay: 60.ms,
                duration: 280.ms,
              ),
              const SizedBox(height: AppSpacing.xl),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE6C7FF), Color(0xFFCAA8FF)],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x447F52FF),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () => context.go(GxBankHomeScreen.routePath),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF42165E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('DONE'),
                ),
              ).animate().fadeIn(delay: 180.ms, duration: 280.ms),
            ],
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.md,
            child: _FlowGuardNotificationBanner(
              onTap: () => context.push(FlowguardScreen.routePath),
            )
                .animate()
                .fadeIn(delay: 420.ms, duration: 220.ms)
                .slideY(
                  begin: -1.15,
                  end: 0,
                  delay: 420.ms,
                  duration: 360.ms,
                  curve: Curves.easeOutCubic,
                ),
          ),
        ],
      ),
    );
  }
}

class _MerchantPaymentCard extends StatelessWidget {
  const _MerchantPaymentCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Merchant', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const IconCircle(
                icon: Icons.local_cafe_outlined,
                size: 42,
                iconSize: 18,
                backgroundColor: Color(0x24FFB36B),
                color: Color(0xFFFFC96B),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mamak Express',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Night supper and drinks',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'RM18.00',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFFFD9A6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QrCanvasCard extends StatelessWidget {
  const _QrCanvasCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Container(
        height: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1F31), Color(0xFF10131D)],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 272,
              height: 272,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                  width: 1.2,
                ),
              ),
            ),
            Container(
              width: 218,
              height: 218,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: const _QrPattern(),
            ),
            Positioned(
              left: 86,
              right: 86,
              child: Container(
                height: 2.4,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.transparent, Color(0xFFE6C7FF), Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x66E6C7FF),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              top: 66,
              left: 66,
              child: _ScannerCorner(alignment: Alignment.topLeft),
            ),
            const Positioned(
              top: 66,
              right: 66,
              child: _ScannerCorner(alignment: Alignment.topRight),
            ),
            const Positioned(
              bottom: 66,
              left: 66,
              child: _ScannerCorner(alignment: Alignment.bottomLeft),
            ),
            const Positioned(
              bottom: 66,
              right: 66,
              child: _ScannerCorner(alignment: Alignment.bottomRight),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerCorner extends StatelessWidget {
  const _ScannerCorner({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final isLeft =
        alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    final isTop =
        alignment == Alignment.topLeft || alignment == Alignment.topRight;

    return SizedBox(
      width: 34,
      height: 34,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: isLeft
                ? const BorderSide(color: Color(0xFFE7D3FF), width: 3)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: Color(0xFFE7D3FF), width: 3)
                : BorderSide.none,
            top: isTop
                ? const BorderSide(color: Color(0xFFE7D3FF), width: 3)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: Color(0xFFE7D3FF), width: 3)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: alignment == Alignment.topLeft
                ? const Radius.circular(14)
                : Radius.zero,
            topRight: alignment == Alignment.topRight
                ? const Radius.circular(14)
                : Radius.zero,
            bottomLeft: alignment == Alignment.bottomLeft
                ? const Radius.circular(14)
                : Radius.zero,
            bottomRight: alignment == Alignment.bottomRight
                ? const Radius.circular(14)
                : Radius.zero,
          ),
        ),
      ),
    );
  }
}

class _QrPattern extends StatelessWidget {
  const _QrPattern();

  @override
  Widget build(BuildContext context) {
    const size = 7;

    return SizedBox(
      width: 190,
      height: 190,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemCount: size * size,
        itemBuilder: (context, index) {
          final row = index ~/ size;
          final col = index % size;
          final isFinder =
              (row < 2 && col < 2) ||
              (row < 2 && col > 4) ||
              (row > 4 && col < 2);
          final isFilled =
              isFinder ||
              (row + col).isEven ||
              (row == 3 && col > 1 && col < 5) ||
              (col == 3 && row > 1 && row < 5);

          return Container(
            decoration: BoxDecoration(
              color: isFilled ? const Color(0xFF121521) : const Color(0xFFF8F8FC),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }
}

class _PaymentSuccessCard extends StatelessWidget {
  const _PaymentSuccessCard();

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1E3E3B), Color(0xFF214C55)],
      ),
      borderColor: const Color(0x3336D99F),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const IconCircle(
            icon: Icons.check_rounded,
            size: 64,
            iconSize: 30,
            backgroundColor: Color(0x2636D99F),
            color: Color(0xFFBFF7DF),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Transfer successful',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'RM18.00',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SuccessDetailRow(
                  label: 'To',
                  value: 'Mamak Express',
                ),
                const SizedBox(height: AppSpacing.sm),
                _SuccessDetailRow(
                  label: 'Reference',
                  value: 'Supper payment',
                ),
                const SizedBox(height: AppSpacing.sm),
                _SuccessDetailRow(
                  label: 'Time',
                  value: '11:42 PM',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Transaction completed successfully.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessDetailRow extends StatelessWidget {
  const _SuccessDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _ConfirmDetailsCard extends StatelessWidget {
  const _ConfirmDetailsCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          const _ConfirmRow(label: 'Pay from', value: 'Main Account'),
          const SizedBox(height: AppSpacing.sm),
          const _ConfirmRow(label: 'Amount', value: 'RM18.00'),
          const SizedBox(height: AppSpacing.sm),
          const _ConfirmRow(label: 'Reference', value: 'Supper payment'),
          const SizedBox(height: AppSpacing.sm),
          const _ConfirmRow(label: 'Time', value: '11:42 PM'),
        ],
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _FlowGuardNotificationBanner extends StatelessWidget {
  const _FlowGuardNotificationBanner({required this.onTap});

  final VoidCallback onTap;

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
            color: AppColors.surface.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: const Color(0x44FF7C8B),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x44000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconCircle(
                icon: Icons.notification_important_outlined,
                size: 34,
                iconSize: 16,
                backgroundColor: Color(0x26FF5C6D),
                color: Color(0xFFFFA1AE),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FlowGuard alert',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Emotional spending detected tonight. Tap to open Night Lock options.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _goBackOrDashboard(BuildContext context) {
  if (context.canPop()) {
    context.pop();
    return;
  }
  context.go(GxBankHomeScreen.routePath);
}
