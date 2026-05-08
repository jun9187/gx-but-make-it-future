import 'package:flutter/material.dart';

class SpendingCategory {
  const SpendingCategory({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;
}
