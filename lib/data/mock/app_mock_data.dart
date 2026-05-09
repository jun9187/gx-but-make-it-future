import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../models/app_mock_models.dart';
import '../models/goal_progress.dart';
import '../models/spending_category.dart';

const dashboardScreenData = DashboardScreenData(
  hero: DashboardHeroData(
    currentBalance: 142,
    spentAmount: 258,
    limitAmount: 400,
  ),
  cashFlow: CashFlowOverviewData(
    totalSpent: 258,
    insight: 'Your spending is 12% lower than last week. Great job!',
  ),
  categories: spendingCategoryData,
  streakWeeks: 3,
  flowGuardStatus: 'Active',
  flowGuardCaption: 'Night lock and recovery nudges are ready.',
  rewardStatus: rewardStatusData,
);

const futureFlowScreenData = FutureFlowScreenData(
  hero: FutureFlowHeroData(
    obscuredBalance: 'RM ****',
    safeToSpend: 142,
    weeklySpentCurrent: 258,
    weeklySpentLimit: 400,
    todayLimitCurrent: 12.5,
    todayLimitMax: 42,
  ),
  upcomingCommitmentsTotal: 315.90,
  riskLevelLabel: 'Moderate Risk',
  riskLevelCaption:
      'You are still within your weekly safe flow, but rent and savings protection tighten your weekend flexibility.',
  predictedEndWeekSpending: 368,
  predictedEndWeekBalance: 74,
  activities: [
    ActivityEntryData(
      title: 'TNG Reload Transfer',
      subtitle: 'Transfers',
      timeLabel: 'Today',
      amountLabel: '-RM30.00',
      icon: Icons.swap_horiz_rounded,
      iconBackground: Color(0x247C4DFF),
      iconColor: Color(0xFFB48CFF),
      isPositive: false,
    ),
    ActivityEntryData(
      title: 'GrabFood',
      subtitle: 'Food Delivery',
      timeLabel: 'Today',
      amountLabel: '-RM24.50',
      icon: Icons.fastfood_outlined,
      iconBackground: Color(0x24FF9D5C),
      iconColor: Color(0xFFFFC96B),
      isPositive: false,
    ),
    ActivityEntryData(
      title: 'Part-time Salary',
      subtitle: 'Income',
      timeLabel: 'Yesterday',
      amountLabel: '+RM420.00',
      icon: Icons.account_balance_wallet_outlined,
      iconBackground: Color(0x245C4DFF),
      iconColor: Color(0xFFD6C2FF),
      isPositive: true,
    ),
  ],
  commitments: [
    CommitmentEntryData(
      title: 'Room Rent',
      subtitle: 'Due in 4 days',
      amountLabel: 'RM200.00',
      icon: Icons.home_outlined,
      iconBackground: Color(0x24FF9D5C),
      iconColor: Color(0xFFFFC96B),
    ),
    CommitmentEntryData(
      title: 'Savings Goal',
      subtitle: 'Future laptop fund',
      amountLabel: 'RM100.00',
      icon: Icons.savings_outlined,
      iconBackground: Color(0x247C4DFF),
      iconColor: Color(0xFFCFAEFF),
    ),
    CommitmentEntryData(
      title: 'Spotify Student',
      subtitle: 'Subscription renews Friday',
      amountLabel: 'RM15.90',
      icon: Icons.music_note_outlined,
      iconBackground: Color(0x24FF4FD8),
      iconColor: Color(0xFFFF9BE7),
    ),
  ],
);

const spendingCategoryData = [
  SpendingCategoryData(
    title: 'Transfers',
    transactionCount: 4,
    amount: 103.20,
    share: 0.40,
    icon: Icons.swap_horiz_rounded,
    color: Color(0xFF7A3FF2),
  ),
  SpendingCategoryData(
    title: 'Subscriptions',
    transactionCount: 3,
    amount: 64.80,
    share: 0.25,
    icon: Icons.subscriptions_outlined,
    color: Color(0xFFD55F93),
  ),
  SpendingCategoryData(
    title: 'Food Delivery',
    transactionCount: 5,
    amount: 51.60,
    share: 0.20,
    icon: Icons.delivery_dining_outlined,
    color: Color(0xFFC5721E),
  ),
  SpendingCategoryData(
    title: 'Campus & Other',
    transactionCount: 6,
    amount: 38.40,
    share: 0.15,
    icon: Icons.storefront_outlined,
    color: Color(0xFFFFB8B0),
  ),
];

const cashFlowScreenData = CashFlowOverviewScreenData(
  insight:
      'Transfers, food delivery, and subscriptions are driving most of this week\'s spend.',
  totalSpentLabel: 'RM 258.00',
  categories: spendingCategoryData,
);

const flowGuardScreenData = FlowGuardScreenData(
  status: FlowGuardStatusData(
    spentToday: 64,
    safeLimit: 42,
    overLimitAmount: 22,
    riskLevelLabel: 'Elevated Risk',
    riskSummary:
        'FlowGuard detected a late-night emotional spending pattern after your QR payment.',
  ),
  signals: [
    FlowGuardSignalData(
      title: 'Spending too fast',
      description: 'RM64 spent by 8:40 PM, already RM22 above your safe pace.',
      icon: Icons.speed_rounded,
      accentColor: Color(0xFFFF8B7B),
    ),
    FlowGuardSignalData(
      title: 'Repeated small payments',
      description:
          '4 small convenience and delivery transactions landed within 90 minutes.',
      icon: Icons.receipt_long_rounded,
      accentColor: Color(0xFFFFC96B),
    ),
    FlowGuardSignalData(
      title: 'Late-night emotional trigger',
      description:
          'Recent browsing and food delivery timing matches your overspend pattern after 10 PM.',
      icon: Icons.nightlight_round,
      accentColor: Color(0xFFB48CFF),
    ),
  ],
  guardrails: [
    FlowGuardOptionData(
      title: 'Night Lock',
      subtitle: 'Pause transaction from 11pm to 6am',
      icon: Icons.dark_mode_outlined,
      accentColor: Color(0xFF6E7DFF),
      state: FlowGuardOptionState.standard,
    ),
    FlowGuardOptionData(
      title: 'Recovery Nudge',
      subtitle: '',
      icon: Icons.trending_down_rounded,
      accentColor: Color(0xFFCA78FF),
      state: FlowGuardOptionState.active,
    ),
  ],
  recoveryNudge: RecoveryNudgeData(
    title: 'Open Night Lock?',
    timestamp: '11:42 PM',
    message:
        'FlowGuard spotted emotional spending after your night QR payment. Turn on Night Lock to pause non-essential spending until 6 AM?',
  ),
  recoveryActions: [
    FlowGuardRecoveryActionData(
      title: 'Reduce tomorrow limit',
      subtitle: 'Tighten flexible spend to RM18 for one day recovery.',
      icon: Icons.tune_rounded,
      accentColor: Color(0xFFCAA5FF),
    ),
    FlowGuardRecoveryActionData(
      title: 'Pause food delivery',
      subtitle: 'Lock delivery apps until 10 AM so the impulse window passes.',
      icon: Icons.delivery_dining_outlined,
      accentColor: Color(0xFFFFB877),
    ),
    FlowGuardRecoveryActionData(
      title: 'Protect savings pocket',
      subtitle: 'Keep RM100 savings goal untouched even if spending continues.',
      icon: Icons.lock_rounded,
      accentColor: Color(0xFF8FE2C5),
    ),
  ],
);

const rewardStatusData = RewardStatusData(
  headerTitle: 'Your Future Home',
  rewardTitle: 'Future Home',
  rewardSubtitle: 'Customize your digital sanctuary',
  coins: 500,
  nextUnlockCoins: 500,
  streakWeeks: 3,
  autoSavedAmount: 38,
  savingsPocketBalance: 188,
);

const savingsPocketsScreenData = SavingsPocketsScreenData(
  totalPocketBalance: 1400,
  pockets: [
    SavingsPocketData(
      title: 'FutureFlow Weekly Leftover',
      amount: 38,
      badgeLabel: 'This week',
      badgeColor: Color(0xFF7C4DFF),
      imageGradient: LinearGradient(
        colors: [Color(0xFF7639FF), Color(0xFFD24EF5)],
      ),
    ),
    SavingsPocketData(
      title: 'Emergency',
      amount: 200,
      imageGradient: LinearGradient(
        colors: [Color(0xFF7B52FF), Color(0xFFD2BCFF)],
      ),
    ),
    SavingsPocketData(
      title: 'Redang road trip',
      amount: 100,
      badgeLabel: '50%',
      badgeColor: Color(0xFF1A1234),
      imageGradient: LinearGradient(
        colors: [Color(0xFFE0BE8D), Color(0xFFBFE6D0)],
      ),
    ),
    SavingsPocketData(
      title: 'Charity fund',
      amount: 250,
      badgeLabel: 'Goal completed!',
      badgeColor: Color(0xFFD946EF),
      imageGradient: LinearGradient(
        colors: [Color(0xFFE84E97), Color(0xFF9D5CFF)],
      ),
    ),
    SavingsPocketData(
      title: 'Phuket!',
      amount: 180,
      imageGradient: LinearGradient(
        colors: [Color(0xFFE8D8CF), Color(0xFFC9B1FF)],
      ),
    ),
    SavingsPocketData(
      title: 'Graduation party',
      amount: 120,
      imageGradient: LinearGradient(
        colors: [Color(0xFFF4D9E2), Color(0xFFFF9CA0)],
      ),
    ),
  ],
  futureFlowPockets: [
    SavingsPocketData(
      title: 'Safe Spend Recovery Buffer',
      amount: 150,
      badgeLabel: 'Protected',
      badgeColor: Color(0xFF18B981),
      imageGradient: LinearGradient(
        colors: [Color(0xFF254E63), Color(0xFF67C9A6)],
      ),
    ),
  ],
);

const autoSaveHistoryScreenData = AutoSaveHistoryScreenData(
  currentWeekAmount: 38,
  insight:
      'FutureFlow has auto-saved for 3 straight weeks because spending stayed below safe flow.',
  history: [
    AutoSaveHistoryPoint(weekLabel: 'W1', amount: 12),
    AutoSaveHistoryPoint(weekLabel: 'W2', amount: 24),
    AutoSaveHistoryPoint(weekLabel: 'W3', amount: 31),
    AutoSaveHistoryPoint(weekLabel: 'W4', amount: 18),
    AutoSaveHistoryPoint(weekLabel: 'W5', amount: 38),
  ],
);

const shopScreenData = ShopScreenData(
  headerTitle: 'Mystery Shop',
  coins: 500,
  title: 'Unlock Your Style',
  subtitle: 'Choose a curated reward box to personalize your future space.',
  backLabel: 'BACK TO HOME',
  items: [
    ShopItemData(
      id: 'furniture-box',
      title: 'Furniture Box',
      description:
          'Rare and modern decor pieces for a more elevated room vibe.',
      caption: 'Curated interior upgrades',
      price: 100,
      rewardItemId: 'reading-lamp',
      rewardRevealTitle: 'Reading Lamp Unlocked',
      rewardRevealSubtitle: 'A warm glow for your future space.',
      icon: Icons.chair_outlined,
      iconGradient: LinearGradient(
        colors: [Color(0xFF7639FF), Color(0xFF9F67FF)],
      ),
      priceBackground: Color(0xFFE0C9FF),
      priceTextColor: Color(0xFF5E2C8F),
      accentColor: Color(0xFFCAA5FF),
    ),
    ShopItemData(
      id: 'pet-mystery-box',
      title: 'Pet Mystery Box',
      description:
          'Adopt a digital companion that adds warmth and personality.',
      caption: 'Playful companion unlock',
      price: 250,
      rewardItemId: 'mochi-pet',
      rewardRevealTitle: 'Mochi Joined Your Home',
      rewardRevealSubtitle: 'A calm little pet who bobs around the room.',
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

const rewardInventoryCatalog = [
  RewardInventoryItemData(
    id: 'reading-lamp',
    name: 'Reading Lamp',
    description: 'A warm corner lamp for the cabinet area.',
    type: RewardInventoryItemType.furniture,
    icon: Icons.light_rounded,
    accentColor: Color(0xFFFFD28A),
    surfaceColor: Color(0xFF7F4D2D),
    rarityLabel: 'Starter',
  ),
  RewardInventoryItemData(
    id: 'mochi-pet',
    name: 'Mochi',
    description: 'A friendly digital pet that moves around your room.',
    type: RewardInventoryItemType.pet,
    icon: Icons.pets_rounded,
    accentColor: Color(0xFFFF9BE7),
    surfaceColor: Color(0xFF5A355E),
    rarityLabel: 'Lucky Pull',
  ),
];

const monthlyGoal = GoalProgress(
  label: 'Savings Goal',
  current: 900,
  target: 1500,
);

const cashReserveGoal = GoalProgress(
  label: 'Emergency Buffer',
  current: 320,
  target: 600,
);

const spendingCategories = [
  SpendingCategory(label: 'Rent', amount: 200, color: AppColors.purple),
  SpendingCategory(label: 'Food Delivery', amount: 51.6, color: AppColors.pink),
  SpendingCategory(label: 'Transfers', amount: 103.2, color: AppColors.cyan),
  SpendingCategory(
    label: 'Subscriptions',
    amount: 64.8,
    color: AppColors.emerald,
  ),
];

const flowSignals = <String>[
  'Weekly spending is below your RM400 limit.',
  'Food delivery is the easiest category to trim this week.',
  'Your savings goal is on pace if you keep RM100 protected.',
];
