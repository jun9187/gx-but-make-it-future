import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../data/mock/app_mock_data.dart';
import '../../../data/models/app_mock_models.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../shop/presentation/shop_screen.dart';
import '../application/future_home_provider.dart';
import 'widgets/future_home_scene.dart';

class FutureHomeScreen extends ConsumerWidget {
  const FutureHomeScreen({super.key});

  static const routeName = 'future-home';
  static const routePath = '/future-home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(futureHomeDemoProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(child: FutureHomeScene()),
          Positioned.fill(
            child: _PlacedRewardLayer(
              state: homeState,
              placementVersion: homeState.placementVersion,
            ),
          ),
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
                    child: _FutureHomeHeader(coins: homeState.coins),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: _CoinBadge(coins: homeState.coins),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _HomeDock(
                      coins: homeState.coins,
                      nextUnlockCoins: rewardStatusData.nextUnlockCoins,
                    ),
                  ),
                  if (homeState.lastPlacedItemId != null)
                    Align(
                      alignment: const Alignment(0, 0.64),
                      child: _PlacedToast(itemId: homeState.lastPlacedItemId!),
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

class _FutureHomeHeader extends ConsumerWidget {
  const _FutureHomeHeader({required this.coins});

  final int coins;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        IconCircle(
          icon: Icons.arrow_back_ios_new_rounded,
          size: 36,
          iconSize: 16,
          backgroundColor: AppColors.background.withValues(alpha: 0.42),
          color: Colors.white,
          onTap: () => _goBackToDashboard(context),
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
              rewardStatusData.headerTitle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        IconCircle(
          icon: Icons.inventory_2_outlined,
          size: 36,
          iconSize: 16,
          backgroundColor: const Color(0x6B3A3147),
          color: Colors.white,
          onTap: () => _showInventorySheet(context, ref),
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
                    'FLOW COINS',
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

class _HomeDock extends StatelessWidget {
  const _HomeDock({required this.coins, required this.nextUnlockCoins});

  final int coins;
  final int nextUnlockCoins;

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ProgressStrip(
              currentCoins: coins,
              nextUnlockCoins: nextUnlockCoins,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _QuickStatusPill(
                  label: '${rewardStatusData.streakWeeks} week streak',
                  icon: Icons.bolt_rounded,
                ),
                const SizedBox(width: AppSpacing.sm),
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
                      onPressed: () => context.push(ShopScreen.routePath),
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
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 120.ms, duration: 260.ms)
        .slideY(begin: 0.08, end: 0);
  }
}

class _QuickStatusPill extends StatelessWidget {
  const _QuickStatusPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.56),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 14,
                color: Color(0xFFFFD28A),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.76),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

class _PlacedRewardLayer extends ConsumerWidget {
  const _PlacedRewardLayer({
    required this.state,
    required this.placementVersion,
  });

  final FutureHomeDemoState state;
  final int placementVersion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(rewardInventoryCatalogProvider);

    RewardInventoryItemData? findItem(String id) {
      for (final item in items) {
        if (item.id == id) return item;
      }
      return null;
    }

    final lamp = findItem('reading-lamp');
    final pet = findItem('mochi-pet');

    return Stack(
      children: [
        if (lamp != null && state.placedItemIds.contains(lamp.id))
          Positioned(
            left: 132,
            bottom: 174,
            child: _PlacedRewardAnimation(
              isHighlighted: state.lastPlacedItemId == lamp.id,
              version: placementVersion,
              child: _LampReward(item: lamp),
            ),
          ),
        if (pet != null && state.placedItemIds.contains(pet.id))
          Positioned(
            right: 74,
            bottom: 112,
            child: _PlacedRewardAnimation(
              isHighlighted: state.lastPlacedItemId == pet.id,
              version: placementVersion,
              child: _PetReward(item: pet),
            ),
          ),
      ],
    );
  }
}

class _PlacedRewardAnimation extends StatelessWidget {
  const _PlacedRewardAnimation({
    required this.child,
    required this.isHighlighted,
    required this.version,
  });

  final Widget child;
  final bool isHighlighted;
  final int version;

  @override
  Widget build(BuildContext context) {
    final keyedChild = KeyedSubtree(
      key: ValueKey('$version-$isHighlighted'),
      child: child,
    );

    if (!isHighlighted) return keyedChild;

    return keyedChild
        .animate()
        .fadeIn(duration: 260.ms)
        .scale(
          begin: const Offset(0.82, 0.82),
          end: const Offset(1, 1),
          duration: 320.ms,
        )
        .shimmer(duration: 500.ms, color: Colors.white.withValues(alpha: 0.35));
  }
}

class _LampReward extends StatelessWidget {
  const _LampReward({required this.item});

  final RewardInventoryItemData item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 74,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 6,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF7B5A3F),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Positioned(
            top: 10,
            child: Container(
              width: 28,
              height: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [item.accentColor, const Color(0xFFFFF0C9)],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                  bottom: Radius.circular(6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: item.accentColor.withValues(alpha: 0.35),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 24,
            child: Container(
              width: 22,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0x33FFF4CE),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetReward extends StatelessWidget {
  const _PetReward({required this.item});

  final RewardInventoryItemData item;

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 76,
          height: 64,
          decoration: BoxDecoration(
            color: item.surfaceColor.withValues(alpha: 0.86),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: item.accentColor.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 12,
                top: 10,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2D7BE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Positioned(
                right: 12,
                top: 10,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2D7BE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Container(
                width: 54,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2D7BE),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              const Positioned(left: 24, top: 28, child: _PetEye()),
              const Positioned(right: 24, top: 28, child: _PetEye()),
              Positioned(
                top: 36,
                child: Container(
                  width: 10,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6F4D39),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(begin: 0, end: -4, duration: 1800.ms, curve: Curves.easeInOut)
        .moveX(begin: -2, end: 2, duration: 2600.ms, curve: Curves.easeInOut);
  }
}

class _PetEye extends StatelessWidget {
  const _PetEye();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0xFF2F2119),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _PlacedToast extends ConsumerWidget {
  const _PlacedToast({required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(rewardInventoryCatalogProvider);
    final item = items.firstWhere((element) => element.id == itemId);

    return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Text(
            '${item.name} placed in home',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 200.ms)
        .fadeOut(delay: 1200.ms, duration: 300.ms);
  }
}

Future<void> _showInventorySheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(futureHomeDemoProvider);
        final items = ref.watch(rewardInventoryCatalogProvider);
        final controller = ref.read(futureHomeDemoProvider.notifier);

        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.94),
                border: Border.all(color: AppColors.stroke),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xxl),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Inventory',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      TextButton(
                        onPressed: controller.resetDemo,
                        child: const Text('Reset demo'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Place rewards in your home to show how good money habits build a visible future.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  for (final item in items) ...[
                    _InventoryItemCard(
                      item: item,
                      isOwned: state.ownedItemIds.contains(item.id),
                      isPlaced: state.placedItemIds.contains(item.id),
                      onPlace: state.ownedItemIds.contains(item.id)
                          ? () => controller.placeItem(item.id)
                          : null,
                      onRemove: state.placedItemIds.contains(item.id)
                          ? () => controller.removeItem(item.id)
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _InventoryItemCard extends StatelessWidget {
  const _InventoryItemCard({
    required this.item,
    required this.isOwned,
    required this.isPlaced,
    this.onPlace,
    this.onRemove,
  });

  final RewardInventoryItemData item;
  final bool isOwned;
  final bool isPlaced;
  final VoidCallback? onPlace;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: item.surfaceColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(item.icon, color: item.accentColor, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  item.rarityLabel.toUpperCase(),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: item.accentColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (!isOwned)
            Text(
              'Locked',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.textMuted),
            )
          else if (isPlaced)
            OutlinedButton(onPressed: onRemove, child: const Text('Remove'))
          else
            TextButton(onPressed: onPlace, child: const Text('Place')),
        ],
      ),
    );
  }
}

void _goBackToDashboard(BuildContext context) {
  if (context.canPop()) {
    context.pop();
    return;
  }
  context.go(DashboardScreen.routePath);
}
