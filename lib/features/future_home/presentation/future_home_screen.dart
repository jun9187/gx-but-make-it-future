import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../shop/presentation/shop_screen.dart';
import 'widgets/future_home_scene.dart';

class FutureHomeScreen extends StatelessWidget {
  const FutureHomeScreen({super.key});

  static const routeName = 'future-home';
  static const routePath = '/future-home';

  @override
  Widget build(BuildContext context) {
    const data = _futureHomeData;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(child: FutureHomeScene()),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.10),
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.22),
                    AppColors.background.withValues(alpha: 0.56),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: _FutureHomeHeader(data: data),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: _CoinBadge(coins: data.coins),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _ShopDock(data: data),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FutureHomeHeader extends StatelessWidget {
  const _FutureHomeHeader({required this.data});

  final _FutureHomeScreenData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconCircle(
          icon: Icons.arrow_back_ios_new_rounded,
          size: 36,
          iconSize: 16,
          backgroundColor: AppColors.background.withValues(alpha: 0.42),
          color: Colors.white,
          onTap: () => context.go(DashboardScreen.routePath),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Text(
              data.headerTitle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        const IconCircle(
          icon: Icons.camera_alt_outlined,
          size: 36,
          iconSize: 16,
          backgroundColor: Color(0x6B3A3147),
          color: Colors.white,
        ),
      ],
    ).animate().fadeIn(duration: 220.ms).slideY(begin: -0.04, end: 0);
  }
}

class _CoinBadge extends StatelessWidget {
  const _CoinBadge({required this.coins});

  final int coins;

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: AppColors.strokeStrong.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFA95C0B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.monetization_on_rounded,
                  size: 12,
                  color: Color(0xFFFFE2A6),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$coins',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'COINS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.68),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 120.ms, duration: 260.ms)
        .slideX(begin: -0.08, end: 0);
  }
}

class _ShopDock extends StatelessWidget {
  const _ShopDock({required this.data});

  final _FutureHomeScreenData data;

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ProgressStrip(
              currentCoins: data.coins,
              nextUnlockCoins: data.nextUnlockCoins,
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: 144,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFAA75FF), Color(0xFFCAA5FF)],
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
                  onPressed: () => context.go(ShopScreen.routePath),
                  icon: const Icon(
                    Icons.shopping_cart_checkout_rounded,
                    size: 18,
                  ),
                  label: const Text('SHOP'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF42165E),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 120.ms, duration: 260.ms)
        .slideY(begin: 0.08, end: 0);
  }
}

class _ProgressStrip extends StatelessWidget {
  const _ProgressStrip({
    required this.currentCoins,
    required this.nextUnlockCoins,
  });

  final int currentCoins;
  final int nextUnlockCoins;

  @override
  Widget build(BuildContext context) {
    final remaining = (nextUnlockCoins - currentCoins).clamp(
      0,
      nextUnlockCoins,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        remaining == 0
            ? 'Next reward ready to unlock'
            : 'Next unlock in $remaining coins',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.76),
        ),
      ),
    );
  }
}

class _FutureHomeScreenData {
  const _FutureHomeScreenData({
    required this.headerTitle,
    required this.coins,
    required this.nextUnlockCoins,
  });

  final String headerTitle;
  final int coins;
  final int nextUnlockCoins;
}

const _futureHomeData = _FutureHomeScreenData(
  headerTitle: 'Your Future Home',
  coins: 450,
  nextUnlockCoins: 500,
);
