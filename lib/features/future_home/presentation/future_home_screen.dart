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

const double _shellNavClearance = 34;
const double _sheetBottomClearance = 96;

class FutureHomeScreen extends ConsumerStatefulWidget {
  const FutureHomeScreen({super.key});

  static const routeName = 'future-home';
  static const routePath = '/future-home';

  @override
  ConsumerState<FutureHomeScreen> createState() => _FutureHomeScreenState();
}

class _FutureHomeScreenState extends ConsumerState<FutureHomeScreen> {
  bool _inventorySheetOpen = false;
  int _handledInventoryRequestVersion = 0;

  @override
  Widget build(BuildContext context) {
    ref.listen<FutureHomeDemoState>(futureHomeDemoProvider, (previous, next) {
      if (next.inventoryRequestVersion > _handledInventoryRequestVersion) {
        _handledInventoryRequestVersion = next.inventoryRequestVersion;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _openInventorySheet();
          }
        });
      }
    });

    final homeState = ref.watch(futureHomeDemoProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final sceneSize = constraints.biggest;

          return Stack(
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
                        AppColors.background.withValues(alpha: 0.20),
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
                    AppSpacing.md,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: _FutureHomeHeader(
                          onInventoryTap: _openInventorySheet,
                        ),
                      ),
                      if (homeState.editingItemId != null)
                        Align(
                          alignment: const Alignment(0, -0.24),
                          child: _PlacementBanner(
                            itemId: homeState.editingItemId!,
                          ),
                        ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: _shellNavClearance,
                        child: _BottomDockRow(
                          state: homeState,
                          onOpenShop: () => context.push(ShopScreen.routePath),
                          onCancelPlacement: () => ref
                              .read(futureHomeDemoProvider.notifier)
                              .cancelPlacement(),
                          onConfirmPlacement: () => ref
                              .read(futureHomeDemoProvider.notifier)
                              .placeItem(),
                        ),
                      ),
                      if (homeState.lastPlacedItemId != null)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: _shellNavClearance + 112,
                          child: Center(
                            child: _PlacedToast(
                              itemId: homeState.lastPlacedItemId!,
                            ),
                          ),
                        ),
                      if (homeState.editingItemId != null)
                        Positioned.fill(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onPanUpdate: (details) {
                              final draftOffset = homeState.draftOffset;
                              final editingItemId = homeState.editingItemId;
                              if (draftOffset == null ||
                                  editingItemId == null) {
                                return;
                              }

                              final nextOffset = _clampOffset(
                                draftOffset + details.delta,
                                sceneSize,
                                _itemSizeFor(editingItemId),
                              );
                              ref
                                  .read(futureHomeDemoProvider.notifier)
                                  .updateDraftOffset(nextOffset);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openInventorySheet() async {
    if (_inventorySheetOpen) return;

    setState(() => _inventorySheetOpen = true);
    await _showInventorySheet(context, ref);
    if (mounted) {
      setState(() => _inventorySheetOpen = false);
    }
  }
}

class _FutureHomeHeader extends StatelessWidget {
  const _FutureHomeHeader({required this.onInventoryTap});

  final VoidCallback onInventoryTap;

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
          onTap: onInventoryTap,
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

class _BottomDockRow extends StatelessWidget {
  const _BottomDockRow({
    required this.state,
    required this.onOpenShop,
    required this.onCancelPlacement,
    required this.onConfirmPlacement,
  });

  final FutureHomeDemoState state;
  final VoidCallback onOpenShop;
  final VoidCallback onCancelPlacement;
  final VoidCallback onConfirmPlacement;

  @override
  Widget build(BuildContext context) {
    final editingItem = state.editingItemId == null
        ? null
        : rewardInventoryCatalog.firstWhere(
            (item) => item.id == state.editingItemId,
          );

    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ProgressStrip(
              label: editingItem == null
                  ? _nextUnlockLabel(
                      state.coins,
                      rewardStatusData.nextUnlockCoins,
                    )
                  : 'Drag ${editingItem.name} into your room, then tap place',
            ),
            const SizedBox(height: AppSpacing.sm),
            if (editingItem == null)
              Row(
                children: [
                  _CoinBadge(coins: state.coins),
                  const Spacer(),
                  SizedBox(
                    width: 132,
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
                        onPressed: onOpenShop,
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
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: onCancelPlacement,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: 0.86),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: 14,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton.icon(
                    onPressed: onConfirmPlacement,
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text('Place Here'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFB08CFF),
                      foregroundColor: const Color(0xFF311048),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: 14,
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

class _ProgressStrip extends StatelessWidget {
  const _ProgressStrip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
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
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.76),
        ),
      ),
    );
  }
}

class _PlacementBanner extends StatelessWidget {
  const _PlacementBanner({required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) {
    final item = rewardInventoryCatalog.firstWhere(
      (entry) => entry.id == itemId,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 16, color: item.accentColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Placing ${item.name}',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 220.ms).slideY(begin: -0.03, end: 0);
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

    Widget buildReward(String id) {
      final item = items.firstWhere((entry) => entry.id == id);
      return switch (item.type) {
        RewardInventoryItemType.furniture => _LampReward(item: item),
        RewardInventoryItemType.pet => _CatReward(item: item),
      };
    }

    final children = <Widget>[];

    for (final itemId in state.placedItemIds) {
      if (itemId == state.editingItemId) continue;
      final offset = state.placedItemOffsets[itemId];
      if (offset == null) continue;

      children.add(
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            onTap: () => ref
                .read(futureHomeDemoProvider.notifier)
                .startPlacingItem(itemId),
            child: _PlacedRewardAnimation(
              isHighlighted: state.lastPlacedItemId == itemId,
              version: placementVersion,
              child: buildReward(itemId),
            ),
          ),
        ),
      );
    }

    final editingItemId = state.editingItemId;
    final draftOffset = state.draftOffset;
    if (editingItemId != null && draftOffset != null) {
      children.add(
        Positioned(
          left: draftOffset.dx,
          top: draftOffset.dy,
          child: _PlacementGhost(child: buildReward(editingItemId)),
        ),
      );
    }

    return Stack(children: children);
  }
}

class _PlacementGhost extends StatelessWidget {
  const _PlacementGhost({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.24),
                  width: 1.4,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x447F52FF),
                    blurRadius: 22,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: child,
            ),
            Positioned(
              top: -26,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
                child: Text(
                  'Drag me',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.84),
                  ),
                ),
              ),
            ),
          ],
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fade(begin: 0.78, end: 1, duration: 850.ms)
        .scale(
          begin: const Offset(0.98, 0.98),
          end: const Offset(1.02, 1.02),
          duration: 850.ms,
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

    return _PlacementSparkleBurst(
      key: ValueKey('sparkle-$version'),
      child: keyedChild
          .animate()
          .fadeIn(duration: 260.ms)
          .scale(
            begin: const Offset(0.82, 0.82),
            end: const Offset(1, 1),
            duration: 320.ms,
          )
          .shimmer(
            duration: 500.ms,
            color: Colors.white.withValues(alpha: 0.35),
          ),
    );
  }
}

class _PlacementSparkleBurst extends StatelessWidget {
  const _PlacementSparkleBurst({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        IgnorePointer(
          child: Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.20),
                  const Color(0xFF86FFE8).withValues(alpha: 0.16),
                  Colors.transparent,
                ],
                stops: const [0, 0.58, 1],
              ),
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0.45, 0.45),
                end: const Offset(1.22, 1.22),
                duration: 620.ms,
                curve: Curves.easeOutCubic,
              )
              .fadeOut(
                begin: 0.95,
                delay: 120.ms,
                duration: 560.ms,
                curve: Curves.easeOut,
              ),
        ),
        child,
        const _PlacementSparkle(
          top: -14,
          left: 2,
          size: 12,
          delay: Duration.zero,
        ),
        const _PlacementSparkle(
          top: 10,
          right: -12,
          size: 10,
          delay: Duration(milliseconds: 90),
        ),
        const _PlacementSparkle(
          bottom: 8,
          left: -14,
          size: 11,
          delay: Duration(milliseconds: 150),
          tint: Color(0xFF86FFE8),
        ),
        const _PlacementSparkle(
          bottom: -12,
          right: 4,
          size: 9,
          delay: Duration(milliseconds: 220),
        ),
      ],
    );
  }
}

class _PlacementSparkle extends StatelessWidget {
  const _PlacementSparkle({
    this.top,
    this.right,
    this.bottom,
    this.left,
    required this.size,
    required this.delay,
    this.tint = Colors.white,
  });

  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final double size;
  final Duration delay;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: IgnorePointer(
        child: Icon(
          Icons.auto_awesome_rounded,
          size: size,
          color: tint,
        )
            .animate()
            .fadeIn(
              delay: delay,
              duration: 160.ms,
              curve: Curves.easeOut,
            )
            .scale(
              begin: const Offset(0.2, 0.2),
              end: const Offset(1.18, 1.18),
              delay: delay,
              duration: 300.ms,
              curve: Curves.easeOutBack,
            )
            .then(delay: 140.ms)
            .fadeOut(duration: 260.ms, curve: Curves.easeIn)
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.45, 1.45),
              duration: 260.ms,
              curve: Curves.easeIn,
            ),
      ),
    );
  }
}

class _LampReward extends StatelessWidget {
  const _LampReward({required this.item});

  final RewardInventoryItemData item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 94,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 8,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF7B5A3F),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 22,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF6B4126),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Positioned(
            top: 12,
            child: Container(
              width: 36,
              height: 28,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [item.accentColor, const Color(0xFFFFF0C9)],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                  bottom: Radius.circular(8),
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
            top: 30,
            child: Container(
              width: 26,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0x33FFF4CE),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatReward extends StatelessWidget {
  const _CatReward({required this.item});

  final RewardInventoryItemData item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: 92,
          height: 88,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: 4,
                top: 18,
                child: Transform.rotate(
                  angle: 0.62,
                  child: Container(
                    width: 28,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECCFB9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                top: 18,
                child: Container(
                  width: 58,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECCFB9),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: item.accentColor.withValues(alpha: 0.24),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 32,
                top: 0,
                child: SizedBox(
                  width: 40,
                  height: 36,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 2,
                        top: 2,
                        child: Transform.rotate(
                          angle: -0.34,
                          child: Container(
                            width: 14,
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color(0xFFECCFB9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Transform.rotate(
                          angle: 0.34,
                          child: Container(
                            width: 14,
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color(0xFFECCFB9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 4,
                        right: 4,
                        bottom: 0,
                        child: Container(
                          height: 26,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6DFC8),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(left: 42, top: 18, child: _CatEye()),
              const Positioned(right: 30, top: 18, child: _CatEye()),
              Positioned(
                left: 42,
                top: 28,
                child: Container(
                  width: 10,
                  height: 7,
                  decoration: BoxDecoration(
                    color: const Color(0xFF80553C),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Positioned(
                left: 27,
                bottom: 6,
                child: Container(
                  width: 10,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7C7AF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Positioned(
                left: 51,
                bottom: 6,
                child: Container(
                  width: 10,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7C7AF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 0,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(begin: 0, end: -5, duration: 1800.ms, curve: Curves.easeInOut)
        .moveX(
          begin: -1.5,
          end: 2.5,
          duration: 2500.ms,
          curve: Curves.easeInOut,
        )
        .rotate(begin: -0.01, end: 0.01, duration: 2200.ms);
  }
}

class _CatEye extends StatelessWidget {
  const _CatEye();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 7,
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
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(futureHomeDemoProvider);
        final items = ref.watch(rewardInventoryCatalogProvider);
        final controller = ref.read(futureHomeDemoProvider.notifier);

        return FractionallySizedBox(
          heightFactor: 0.62,
          child: Padding(
            padding: const EdgeInsets.only(bottom: _sheetBottomClearance),
            child: ClipRRect(
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
                    AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.94),
                    border: Border.all(color: AppColors.stroke),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.xxl),
                    ),
                  ),
                  child: Column(
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
                      Expanded(
                        child: ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _InventoryItemCard(
                              item: item,
                              isOwned: state.ownedItemIds.contains(item.id),
                              isPlaced: state.placedItemIds.contains(item.id),
                              isEditing: state.editingItemId == item.id,
                              onPlace: state.ownedItemIds.contains(item.id)
                                  ? () {
                                      controller.startPlacingItem(item.id);
                                      Navigator.of(context).pop();
                                    }
                                  : null,
                              onRemove: state.placedItemIds.contains(item.id)
                                  ? () => controller.removeItem(item.id)
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
    required this.isEditing,
    this.onPlace,
    this.onRemove,
  });

  final RewardInventoryItemData item;
  final bool isOwned;
  final bool isPlaced;
  final bool isEditing;
  final VoidCallback? onPlace;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isEditing
              ? item.accentColor.withValues(alpha: 0.6)
              : AppColors.stroke,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          else if (isEditing)
            Text(
              'Placing...',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: item.accentColor),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onPlace,
                  child: Text(isPlaced ? 'Move' : 'Place'),
                ),
                if (isPlaced)
                  OutlinedButton(
                    onPressed: onRemove,
                    child: const Text('Remove'),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

String _nextUnlockLabel(int currentCoins, int nextUnlockCoins) {
  final remaining = (nextUnlockCoins - currentCoins).clamp(0, nextUnlockCoins);
  return remaining == 0
      ? 'Next reward ready to unlock'
      : 'Next unlock in $remaining coins';
}

Offset _clampOffset(Offset offset, Size sceneSize, Size itemSize) {
  final minX = 8.0;
  const minY = 106.0;
  final maxX = sceneSize.width - itemSize.width - 8;
  final maxY = sceneSize.height - itemSize.height - 168;

  return Offset(offset.dx.clamp(minX, maxX), offset.dy.clamp(minY, maxY));
}

Size _itemSizeFor(String itemId) {
  switch (itemId) {
    case 'reading-lamp':
      return const Size(46, 94);
    case 'mochi-pet':
      return const Size(92, 88);
    default:
      return const Size(72, 72);
  }
}

void _goBackToDashboard(BuildContext context) {
  if (context.canPop()) {
    context.pop();
    return;
  }
  context.go(DashboardScreen.routePath);
}
