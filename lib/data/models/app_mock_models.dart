import 'package:flutter/material.dart';

class DashboardScreenData {
  const DashboardScreenData({
    required this.hero,
    required this.cashFlow,
    required this.categories,
    required this.streakWeeks,
    required this.flowGuardStatus,
    required this.flowGuardCaption,
    required this.rewardStatus,
  });

  final DashboardHeroData hero;
  final CashFlowOverviewData cashFlow;
  final List<SpendingCategoryData> categories;
  final int streakWeeks;
  final String flowGuardStatus;
  final String flowGuardCaption;
  final RewardStatusData rewardStatus;
}

class DashboardHeroData {
  const DashboardHeroData({
    required this.currentBalance,
    required this.spentAmount,
    required this.limitAmount,
  });

  final double currentBalance;
  final double spentAmount;
  final double limitAmount;

  double get spentRatio => limitAmount == 0 ? 0 : spentAmount / limitAmount;
}

class CashFlowOverviewData {
  const CashFlowOverviewData({required this.totalSpent, required this.insight});

  final double totalSpent;
  final String insight;
}

class FutureFlowScreenData {
  const FutureFlowScreenData({
    required this.hero,
    required this.upcomingCommitmentsTotal,
    required this.riskLevelLabel,
    required this.riskLevelCaption,
    required this.predictedEndWeekSpending,
    required this.predictedEndWeekBalance,
    required this.activities,
    required this.commitments,
  });

  final FutureFlowHeroData hero;
  final double upcomingCommitmentsTotal;
  final String riskLevelLabel;
  final String riskLevelCaption;
  final double predictedEndWeekSpending;
  final double predictedEndWeekBalance;
  final List<ActivityEntryData> activities;
  final List<CommitmentEntryData> commitments;
}

class FutureFlowHeroData {
  const FutureFlowHeroData({
    required this.obscuredBalance,
    required this.safeToSpend,
    required this.weeklySpentCurrent,
    required this.weeklySpentLimit,
    required this.todayLimitCurrent,
    required this.todayLimitMax,
  });

  final String obscuredBalance;
  final double safeToSpend;
  final double weeklySpentCurrent;
  final double weeklySpentLimit;
  final double todayLimitCurrent;
  final double todayLimitMax;

  double get weeklySpentProgress =>
      weeklySpentLimit == 0 ? 0 : weeklySpentCurrent / weeklySpentLimit;

  double get todayLimitProgress =>
      todayLimitMax == 0 ? 0 : todayLimitCurrent / todayLimitMax;
}

class ActivityEntryData {
  const ActivityEntryData({
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.amountLabel,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.isPositive,
  });

  final String title;
  final String subtitle;
  final String timeLabel;
  final String amountLabel;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final bool isPositive;
}

class CommitmentEntryData {
  const CommitmentEntryData({
    required this.title,
    required this.subtitle,
    required this.amountLabel,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
  });

  final String title;
  final String subtitle;
  final String amountLabel;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
}

class SpendingCategoryData {
  const SpendingCategoryData({
    required this.title,
    required this.transactionCount,
    required this.amount,
    required this.share,
    required this.icon,
    required this.color,
  });

  final String title;
  final int transactionCount;
  final double amount;
  final double share;
  final IconData icon;
  final Color color;

  String get amountLabel => 'RM ${amount.toStringAsFixed(2)}';
  String get percentLabel => '${(share * 100).round()}%';
}

class CashFlowOverviewScreenData {
  const CashFlowOverviewScreenData({
    required this.insight,
    required this.totalSpentLabel,
    required this.categories,
  });

  final String insight;
  final String totalSpentLabel;
  final List<SpendingCategoryData> categories;
}

class FlowGuardScreenData {
  const FlowGuardScreenData({
    required this.status,
    required this.signals,
    required this.guardrails,
    required this.recoveryNudge,
    required this.recoveryActions,
  });

  final FlowGuardStatusData status;
  final List<FlowGuardSignalData> signals;
  final List<FlowGuardOptionData> guardrails;
  final RecoveryNudgeData recoveryNudge;
  final List<FlowGuardRecoveryActionData> recoveryActions;
}

class FlowGuardStatusData {
  const FlowGuardStatusData({
    required this.spentToday,
    required this.safeLimit,
    required this.overLimitAmount,
    required this.riskLevelLabel,
    required this.riskSummary,
  });

  final double spentToday;
  final double safeLimit;
  final double overLimitAmount;
  final String riskLevelLabel;
  final String riskSummary;

  double get progress => spentToday == 0 ? 0 : safeLimit / spentToday;
}

class FlowGuardSignalData {
  const FlowGuardSignalData({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
}

enum FlowGuardOptionState { standard, active, locked }

class FlowGuardOptionData {
  const FlowGuardOptionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.state,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final FlowGuardOptionState state;
}

class RecoveryNudgeData {
  const RecoveryNudgeData({
    required this.title,
    required this.timestamp,
    required this.message,
  });

  final String title;
  final String timestamp;
  final String message;
}

class FlowGuardRecoveryActionData {
  const FlowGuardRecoveryActionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
}

class RewardStatusData {
  const RewardStatusData({
    required this.headerTitle,
    required this.rewardTitle,
    required this.rewardSubtitle,
    required this.coins,
    required this.nextUnlockCoins,
    required this.streakWeeks,
    required this.autoSavedAmount,
    required this.savingsPocketBalance,
  });

  final String headerTitle;
  final String rewardTitle;
  final String rewardSubtitle;
  final int coins;
  final int nextUnlockCoins;
  final int streakWeeks;
  final double autoSavedAmount;
  final double savingsPocketBalance;
}

class SavingsPocketData {
  const SavingsPocketData({
    required this.title,
    required this.amount,
    required this.imageGradient,
    this.badgeLabel,
    this.badgeColor,
  });

  final String title;
  final double amount;
  final Gradient imageGradient;
  final String? badgeLabel;
  final Color? badgeColor;
}

class SavingsPocketsScreenData {
  const SavingsPocketsScreenData({
    required this.totalPocketBalance,
    required this.pockets,
    required this.futureFlowPockets,
  });

  final double totalPocketBalance;
  final List<SavingsPocketData> pockets;
  final List<SavingsPocketData> futureFlowPockets;
}

class AutoSaveHistoryPoint {
  const AutoSaveHistoryPoint({required this.weekLabel, required this.amount});

  final String weekLabel;
  final double amount;
}

class AutoSaveHistoryScreenData {
  const AutoSaveHistoryScreenData({
    required this.currentWeekAmount,
    required this.insight,
    required this.history,
  });

  final double currentWeekAmount;
  final String insight;
  final List<AutoSaveHistoryPoint> history;
}

class ShopScreenData {
  const ShopScreenData({
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
  final List<ShopItemData> items;
}

class ShopItemData {
  const ShopItemData({
    required this.id,
    required this.title,
    required this.description,
    required this.caption,
    required this.price,
    required this.rewardItemId,
    required this.rewardRevealTitle,
    required this.rewardRevealSubtitle,
    required this.icon,
    required this.iconGradient,
    required this.priceBackground,
    required this.priceTextColor,
    required this.accentColor,
  });

  final String id;
  final String title;
  final String description;
  final String caption;
  final int price;
  final String rewardItemId;
  final String rewardRevealTitle;
  final String rewardRevealSubtitle;
  final IconData icon;
  final Gradient iconGradient;
  final Color priceBackground;
  final Color priceTextColor;
  final Color accentColor;
}

enum RewardInventoryItemType { pet, furniture }

class RewardInventoryItemData {
  const RewardInventoryItemData({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.icon,
    required this.accentColor,
    required this.surfaceColor,
    required this.rarityLabel,
  });

  final String id;
  final String name;
  final String description;
  final RewardInventoryItemType type;
  final IconData icon;
  final Color accentColor;
  final Color surfaceColor;
  final String rarityLabel;
}

class FutureHomeDemoState {
  const FutureHomeDemoState({
    required this.coins,
    required this.ownedItemIds,
    required this.placedItemIds,
    required this.placedItemOffsets,
    required this.editingItemId,
    required this.draftOffset,
    required this.lastUnlockedItemId,
    required this.lastPlacedItemId,
    required this.placementVersion,
    required this.inventoryRequestVersion,
  });

  final int coins;
  final Set<String> ownedItemIds;
  final Set<String> placedItemIds;
  final Map<String, Offset> placedItemOffsets;
  final String? editingItemId;
  final Offset? draftOffset;
  final String? lastUnlockedItemId;
  final String? lastPlacedItemId;
  final int placementVersion;
  final int inventoryRequestVersion;

  FutureHomeDemoState copyWith({
    int? coins,
    Set<String>? ownedItemIds,
    Set<String>? placedItemIds,
    Map<String, Offset>? placedItemOffsets,
    Object? editingItemId = _sentinel,
    Object? draftOffset = _sentinel,
    Object? lastUnlockedItemId = _sentinel,
    Object? lastPlacedItemId = _sentinel,
    int? placementVersion,
    int? inventoryRequestVersion,
  }) {
    return FutureHomeDemoState(
      coins: coins ?? this.coins,
      ownedItemIds: ownedItemIds ?? this.ownedItemIds,
      placedItemIds: placedItemIds ?? this.placedItemIds,
      placedItemOffsets: placedItemOffsets ?? this.placedItemOffsets,
      editingItemId: identical(editingItemId, _sentinel)
          ? this.editingItemId
          : editingItemId as String?,
      draftOffset: identical(draftOffset, _sentinel)
          ? this.draftOffset
          : draftOffset as Offset?,
      lastUnlockedItemId: identical(lastUnlockedItemId, _sentinel)
          ? this.lastUnlockedItemId
          : lastUnlockedItemId as String?,
      lastPlacedItemId: identical(lastPlacedItemId, _sentinel)
          ? this.lastPlacedItemId
          : lastPlacedItemId as String?,
      placementVersion: placementVersion ?? this.placementVersion,
      inventoryRequestVersion:
          inventoryRequestVersion ?? this.inventoryRequestVersion,
    );
  }
}

const Object _sentinel = Object();
