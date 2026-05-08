import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/mock/app_mock_data.dart';
import '../../../data/models/app_mock_models.dart';

final rewardInventoryCatalogProvider = Provider<List<RewardInventoryItemData>>((
  ref,
) {
  return rewardInventoryCatalog;
});

final futureHomeDemoProvider =
    StateNotifierProvider<FutureHomeDemoController, FutureHomeDemoState>((ref) {
      return FutureHomeDemoController();
    });

class FutureHomeDemoController extends StateNotifier<FutureHomeDemoState> {
  FutureHomeDemoController() : super(_initialState);

  static const Map<String, Offset> _defaultOffsets = {
    'reading-lamp': Offset(116, 258),
    'mochi-pet': Offset(222, 392),
  };

  static final FutureHomeDemoState _initialState = FutureHomeDemoState(
    coins: rewardStatusData.coins,
    ownedItemIds: {'reading-lamp'},
    placedItemIds: <String>{},
    placedItemOffsets: <String, Offset>{},
    editingItemId: null,
    draftOffset: null,
    lastUnlockedItemId: null,
    lastPlacedItemId: null,
    placementVersion: 0,
    inventoryRequestVersion: 0,
  );

  bool canUnlock(ShopItemData item) {
    return state.coins >= item.price &&
        !state.ownedItemIds.contains(item.rewardItemId);
  }

  bool unlockReward(ShopItemData item) {
    if (!canUnlock(item)) return false;

    final owned = {...state.ownedItemIds, item.rewardItemId};
    state = state.copyWith(
      coins: state.coins - item.price,
      ownedItemIds: owned,
      lastUnlockedItemId: item.rewardItemId,
    );
    return true;
  }

  void startPlacingItem(String itemId) {
    if (!state.ownedItemIds.contains(itemId)) return;

    state = state.copyWith(
      editingItemId: itemId,
      draftOffset:
          state.placedItemOffsets[itemId] ??
          _defaultOffsets[itemId] ??
          Offset.zero,
      lastPlacedItemId: null,
    );
  }

  void updateDraftOffset(Offset offset) {
    if (state.editingItemId == null) return;
    state = state.copyWith(draftOffset: offset);
  }

  void placeItem() {
    final itemId = state.editingItemId;
    final draftOffset = state.draftOffset;
    if (itemId == null || draftOffset == null) return;

    final placed = {...state.placedItemIds, itemId};
    final offsets = {...state.placedItemOffsets, itemId: draftOffset};
    state = state.copyWith(
      placedItemIds: placed,
      placedItemOffsets: offsets,
      editingItemId: null,
      draftOffset: null,
      lastPlacedItemId: itemId,
      placementVersion: state.placementVersion + 1,
    );
  }

  void cancelPlacement() {
    state = state.copyWith(
      editingItemId: null,
      draftOffset: null,
      lastPlacedItemId: null,
    );
  }

  void removeItem(String itemId) {
    final placed = {...state.placedItemIds}..remove(itemId);
    final offsets = {...state.placedItemOffsets}..remove(itemId);
    state = state.copyWith(
      placedItemIds: placed,
      placedItemOffsets: offsets,
      editingItemId: state.editingItemId == itemId ? null : state.editingItemId,
      draftOffset: state.editingItemId == itemId ? null : state.draftOffset,
      lastPlacedItemId: null,
    );
  }

  void requestInventoryOpen() {
    state = state.copyWith(
      inventoryRequestVersion: state.inventoryRequestVersion + 1,
    );
  }

  void resetDemo() {
    state = _initialState;
  }
}
