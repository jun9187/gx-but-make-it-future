import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/mock/mock_dashboard_data.dart';
import '../../../data/models/goal_progress.dart';
import '../../../data/models/spending_category.dart';

final dashboardTimeframeProvider = StateProvider<String>((ref) => 'This month');

final monthlyGoalProvider = Provider<GoalProgress>((ref) => monthlyGoal);
final cashReserveGoalProvider = Provider<GoalProgress>((ref) => cashReserveGoal);
final spendingCategoriesProvider = Provider<List<SpendingCategory>>(
  (ref) => spendingCategories,
);
final flowSignalsProvider = Provider<List<String>>((ref) => flowSignals);
