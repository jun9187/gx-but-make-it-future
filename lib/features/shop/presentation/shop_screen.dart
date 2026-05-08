import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../../future_home/presentation/future_home_screen.dart';
import '../../future_home/presentation/widgets/future_home_scene.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  static const routeName = 'shop';
  static const routePath = '/shop';

  @override
  Widget build(BuildContext context) {
    const data = _shopData;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const FutureHomeScene(showAtmosphere: false),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0.28),
                    AppColors.background.withValues(alpha: 0.18),
                    AppColors.background.withValues(alpha: 0.78),
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
              child: Column(
                children: [
                  _ShopHeader(data: data),
                  const Spacer(),
                  _ShopStage(data: data),
                  const Spacer(),
                  _BackHomeButton(label: data.backLabel),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopHeader extends StatelessWidget {
  const _ShopHeader({required this.data});

  final _ShopScreenData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconCircle(
          icon: Icons.arrow_back_ios_new_rounded,
          size: 36,
          iconSize: 16,
          backgroundColor: AppColors.background.withValues(alpha: 0.48),
          color: Colors.white,
          onTap: () => context.go(FutureHomeScreen.routePath),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.48),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Text(
              data.headerTitle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.48),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Color(0xFFA95C0B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.monetization_on_rounded,
                  size: 10,
                  color: Color(0xFFFFE2A6),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${data.coins}',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 220.ms).slideY(begin: -0.04, end: 0);
  }
}

class _ShopStage extends StatelessWidget {
  const _ShopStage({required this.data});

  final _ShopScreenData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          data.subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.72),
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        for (var i = 0; i < data.items.length; i++) ...[
          _ShopCard(item: data.items[i])
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 120 + (i * 70)),
                duration: 260.ms,
              )
              .slideY(begin: 0.06, end: 0),
          if (i != data.items.length - 1) const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.item});

  final _ShopItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: const Color(0xA1261F31),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 22,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: item.iconGradient,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(item.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.74),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      item.caption,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: item.accentColor.withValues(alpha: 0.95),
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: item.priceBackground,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${item.price}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: item.priceTextColor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Icon(
                      Icons.monetization_on_rounded,
                      size: 14,
                      color: item.priceTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackHomeButton extends StatelessWidget {
  const _BackHomeButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.44),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
              ),
              child: TextButton.icon(
                onPressed: () => context.go(FutureHomeScreen.routePath),
                icon: const Icon(Icons.close_rounded, size: 18),
                label: Text(label),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white.withValues(alpha: 0.82),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 240.ms, duration: 240.ms)
        .slideY(begin: 0.06, end: 0);
  }
}

class _ShopScreenData {
  const _ShopScreenData({
    required this.headerTitle,
    required this.coins,
    required this.title,
    required this.subtitle,
    required this.backLabel,
    required this.items,
  });

  final String headerTitle;
  final int coins;
  final String title;
  final String subtitle;
  final String backLabel;
  final List<_ShopItem> items;
}

class _ShopItem {
  const _ShopItem({
    required this.title,
    required this.description,
    required this.caption,
    required this.price,
    required this.icon,
    required this.iconGradient,
    required this.priceBackground,
    required this.priceTextColor,
    required this.accentColor,
  });

  final String title;
  final String description;
  final String caption;
  final int price;
  final IconData icon;
  final Gradient iconGradient;
  final Color priceBackground;
  final Color priceTextColor;
  final Color accentColor;
}

const _shopData = _ShopScreenData(
  headerTitle: 'Mystery Shop',
  coins: 450,
  title: 'Unlock Your Style',
  subtitle: 'Choose a curated reward box to personalize your future space.',
  backLabel: 'BACK TO HOME',
  items: [
    _ShopItem(
      title: 'Furniture Box',
      description:
          'Rare and modern decor pieces for a more elevated room vibe.',
      caption: 'Curated interior upgrades',
      price: 100,
      icon: Icons.chair_outlined,
      iconGradient: LinearGradient(
        colors: [Color(0xFF7639FF), Color(0xFF9F67FF)],
      ),
      priceBackground: Color(0xFFE0C9FF),
      priceTextColor: Color(0xFF5E2C8F),
      accentColor: Color(0xFFCAA5FF),
    ),
    _ShopItem(
      title: 'Pet Mystery Box',
      description:
          'Adopt a digital companion that adds warmth and personality.',
      caption: 'Playful companion unlock',
      price: 250,
      icon: Icons.pets_rounded,
      iconGradient: LinearGradient(
        colors: [Color(0xFFE4008B), Color(0xFFFF5DB8)],
      ),
      priceBackground: Color(0xFFFFB3D4),
      priceTextColor: Color(0xFF8E1D58),
      accentColor: Color(0xFFFF8DC7),
    ),
  ],
);
