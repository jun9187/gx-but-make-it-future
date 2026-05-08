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
import '../../future_home/application/future_home_provider.dart';
import '../../future_home/presentation/future_home_screen.dart';
import '../../future_home/presentation/widgets/future_home_scene.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  static const routeName = 'shop';
  static const routePath = '/shop';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = shopScreenData;
    final state = ref.watch(futureHomeDemoProvider);

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
                  _ShopHeader(coins: state.coins, title: data.headerTitle),
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
  const _ShopHeader({required this.coins, required this.title});

  final int coins;
  final String title;

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
          onTap: () => _backToHome(context),
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
              title,
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
                '$coins',
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

class _ShopStage extends ConsumerWidget {
  const _ShopStage({required this.data});

  final ShopScreenData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(futureHomeDemoProvider.notifier);
    final state = ref.watch(futureHomeDemoProvider);

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
          _ShopCard(
                item: data.items[i],
                isOwned: state.ownedItemIds.contains(
                  data.items[i].rewardItemId,
                ),
                canAfford: controller.canUnlock(data.items[i]),
                onTap: () => _showGachaDialog(context, ref, data.items[i]),
              )
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
  const _ShopCard({
    required this.item,
    required this.isOwned,
    required this.canAfford,
    required this.onTap,
  });

  final ShopItemData item;
  final bool isOwned;
  final bool canAfford;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
        child: ClipRRect(
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.74),
                                height: 1.45,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          isOwned
                              ? 'Unlocked in inventory'
                              : canAfford
                              ? item.caption
                              : 'Not enough Flow Coins',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: isOwned
                                    ? const Color(0xFFD5FFC9)
                                    : canAfford
                                    ? item.accentColor.withValues(alpha: 0.95)
                                    : AppColors.textMuted,
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
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: item.priceTextColor),
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
                onPressed: () => _backToHome(context),
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

class _GachaDialog extends ConsumerStatefulWidget {
  const _GachaDialog({required this.item});

  final ShopItemData item;

  @override
  ConsumerState<_GachaDialog> createState() => _GachaDialogState();
}

class _GachaDialogState extends ConsumerState<_GachaDialog> {
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        final controller = ref.read(futureHomeDemoProvider.notifier);
        if (controller.canUnlock(widget.item)) {
          controller.unlockReward(widget.item);
        }
        setState(() => _revealed = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(futureHomeDemoProvider);
    final reward = rewardInventoryCatalog.firstWhere(
      (entry) => entry.id == widget.item.rewardItemId,
    );
    final isOwned = state.ownedItemIds.contains(reward.id);
    final canAfford = state.coins >= widget.item.price || isOwned;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.96),
              border: Border.all(color: AppColors.stroke),
              borderRadius: BorderRadius.circular(AppRadius.xxl),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: !_revealed
                  ? _GachaLoadingView(item: widget.item)
                  : _GachaRevealView(
                      item: widget.item,
                      reward: reward,
                      isOwned: isOwned,
                      canAfford: canAfford,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GachaLoadingView extends StatelessWidget {
  const _GachaLoadingView({required this.item});

  final ShopItemData item;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('loading'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: item.iconGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: item.accentColor.withValues(alpha: 0.35),
                    blurRadius: 30,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: Icon(item.icon, color: Colors.white, size: 42),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: 1100.ms)
            .scale(
              begin: const Offset(0.92, 0.92),
              end: const Offset(1.08, 1.08),
              duration: 700.ms,
            )
            .then()
            .scale(
              begin: const Offset(1.08, 1.08),
              end: const Offset(0.92, 0.92),
              duration: 700.ms,
            ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Drawing reward...',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'FutureFlow is opening your ${item.title.toLowerCase()}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _GachaRevealView extends StatelessWidget {
  const _GachaRevealView({
    required this.item,
    required this.reward,
    required this.isOwned,
    required this.canAfford,
  });

  final ShopItemData item;
  final RewardInventoryItemData reward;
  final bool isOwned;
  final bool canAfford;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('reveal'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                color: reward.surfaceColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: reward.accentColor.withValues(alpha: 0.36),
                    blurRadius: 26,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(reward.icon, color: reward.accentColor, size: 48),
            )
            .animate()
            .fadeIn(duration: 260.ms)
            .scale(begin: const Offset(0.8, 0.8)),
        const SizedBox(height: AppSpacing.xl),
        Text(
          item.rewardRevealTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          item.rewardRevealSubtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          reward.rarityLabel.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: reward.accentColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isOwned
                ? () => Navigator.of(context).pop('inventory')
                : null,
            child: Text(
              isOwned
                  ? 'Go To Inventory'
                  : canAfford
                  ? 'Preparing Inventory...'
                  : 'Not Enough Flow Coins',
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _showGachaDialog(
  BuildContext context,
  WidgetRef ref,
  ShopItemData item,
) async {
  final nextAction = await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (context) => _GachaDialog(item: item),
  );

  if (!context.mounted) return;

  if (nextAction == 'inventory') {
    ref.read(futureHomeDemoProvider.notifier).requestInventoryOpen();
    _backToHome(context);
  }
}

void _backToHome(BuildContext context) {
  if (context.canPop()) {
    context.pop();
    return;
  }
  context.go(FutureHomeScreen.routePath);
}
