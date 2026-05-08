import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../models/goal_progress.dart';
import '../models/spending_category.dart';

const monthlyGoal = GoalProgress(
  label: 'Future Fund',
  current: 14800,
  target: 20000,
);

const cashReserveGoal = GoalProgress(
  label: 'Cash Reserve',
  current: 9200,
  target: 12000,
);

const spendingCategories = [
  SpendingCategory(
    label: 'Bills',
    amount: 2200,
    color: AppColors.purple,
  ),
  SpendingCategory(
    label: 'Leisure',
    amount: 1180,
    color: AppColors.pink,
  ),
  SpendingCategory(
    label: 'Home',
    amount: 860,
    color: AppColors.cyan,
  ),
  SpendingCategory(
    label: 'Invest',
    amount: 1320,
    color: AppColors.emerald,
  ),
];

const flowSignals = <String>[
  'Cash runway healthy for 47 days',
  'Discretionary spend down 12% this week',
  'Home goal is projected to hit 2 weeks early',
];
