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

  static final FutureHomeDemoState _initialState = FutureHomeDemoState(
    coins: rewardStatusData.coins,
    ownedItemIds: {'reading-lamp'},
    placedItemIds: <String>{},
    lastUnlockedItemId: null,
    lastPlacedItemId: null,
    placementVersion: 0,
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

  void placeItem(String itemId) {
    final placed = {...state.placedItemIds, itemId};
    state = state.copyWith(
      placedItemIds: placed,
      lastPlacedItemId: itemId,
      placementVersion: state.placementVersion + 1,
    );
  }

  void removeItem(String itemId) {
    final placed = {...state.placedItemIds}..remove(itemId);
    state = state.copyWith(placedItemIds: placed, lastPlacedItemId: null);
  }

  void resetDemo() {
    state = _initialState;
  }
}
