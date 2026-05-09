import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_card.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../flowguard/presentation/flowguard_demo_screens.dart';

class GxBankHomeScreen extends StatelessWidget {
  const GxBankHomeScreen({super.key});

  static const routeName = 'gxbank-home';
  static const routePath = '/gxbank-home';

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
          _GxTopBar().animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: AppSpacing.xl),
          const _GxBalanceCard().animate().fadeIn(
            delay: 60.ms,
            duration: 280.ms,
          ),
          const SizedBox(height: AppSpacing.lg),
          _QuickActionsRow(
            onQrPayTap: () => context.push(FlowGuardQrPaymentScreen.routePath),
            onFutureFlowTap: () => context.go(DashboardScreen.routePath),
          ).animate().fadeIn(delay: 120.ms, duration: 280.ms),
          const SizedBox(height: AppSpacing.lg),
          _FutureFlowGatewayCard(
            onTap: () => context.go(DashboardScreen.routePath),
          ).animate().fadeIn(delay: 180.ms, duration: 280.ms),
          const SizedBox(height: AppSpacing.lg),
          const _RecentActivityCard().animate().fadeIn(
            delay: 240.ms,
            duration: 300.ms,
          ),
        ],
      ),
    );
  }
}

class _GxTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE8FFF7), Color(0xFFBFF0E2)],
            ),
            borderRadius: BorderRadius.circular(AppRadius.icon),
          ),
          alignment: Alignment.center,
          child: Text(
            'GX',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: const Color(0xFF145F53),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GXBank',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Banking home',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const IconCircle(
          icon: Icons.notifications_none_rounded,
          size: 40,
          iconSize: 18,
        ),
      ],
    );
  }
}

class _GxBalanceCard extends StatelessWidget {
  const _GxBalanceCard();

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF064C45), Color(0xFF0D6B60), Color(0xFF1AA18C)],
      ),
      borderColor: const Color(0x33FFFFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Main Account',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                ),
              ),
              const Spacer(),
              Text(
                'Available',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            formatCurrency(1284.32),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _BalanceMeta(
                  label: 'Savings Pocket',
                  value: formatCurrency(188),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _BalanceMeta(
                  label: 'Cashback this month',
                  value: formatCurrency(23.40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceMeta extends StatelessWidget {
  const _BalanceMeta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({
    required this.onQrPayTap,
    required this.onFutureFlowTap,
  });

  final VoidCallback onQrPayTap;
  final VoidCallback onFutureFlowTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            title: 'QR Pay',
            subtitle: 'Scan or pay a merchant',
            icon: Icons.qr_code_scanner_rounded,
            accent: const Color(0xFF5DE3C1),
            onTap: onQrPayTap,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _QuickActionCard(
            title: 'FutureFlow',
            subtitle: 'Open smart money insights',
            icon: Icons.auto_graph_rounded,
            accent: const Color(0xFFCA78FF),
            onTap: onFutureFlowTap,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconCircle(
                icon: icon,
                size: 38,
                iconSize: 18,
                backgroundColor: accent.withValues(alpha: 0.16),
                color: accent,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FutureFlowGatewayCard extends StatelessWidget {
  const _FutureFlowGatewayCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: GradientCard(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5A31D1), Color(0xFF943AE6), Color(0xFFD946EF)],
          ),
          borderColor: const Color(0x2EFFFFFF),
          child: Row(
            children: [
              const IconCircle(
                icon: Icons.shield_moon_outlined,
                size: 42,
                iconSize: 20,
                backgroundColor: Color(0x24FFFFFF),
                color: Colors.white,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FutureFlow',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Check your safe-to-spend, FlowGuard, and savings rewards.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.86),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activity', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          const _RecentActivityRow(
            icon: Icons.shopping_bag_outlined,
            title: 'GXMart',
            subtitle: 'Today, 6:12 PM',
            amount: '-RM12.80',
            accent: Color(0xFFFFC96B),
          ),
          const SizedBox(height: AppSpacing.md),
          const _RecentActivityRow(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Part-time Salary',
            subtitle: 'Today, 3:05 PM',
            amount: '+RM420.00',
            accent: Color(0xFF76E7C8),
          ),
          const SizedBox(height: AppSpacing.md),
          const _RecentActivityRow(
            icon: Icons.nightlife_outlined,
            title: 'Mamak Express',
            subtitle: 'Nearby merchant',
            amount: 'RM18.00',
            accent: Color(0xFFCA78FF),
          ),
        ],
      ),
    );
  }
}

class _RecentActivityRow extends StatelessWidget {
  const _RecentActivityRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconCircle(
          icon: icon,
          size: 38,
          iconSize: 18,
          backgroundColor: accent.withValues(alpha: 0.14),
          color: accent,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          amount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.88),
          ),
        ),
      ],
    );
  }
}
