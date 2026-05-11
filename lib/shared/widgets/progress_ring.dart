import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.label,
    required this.amount,
    this.gradientColors = const [AppColors.purple, AppColors.pink],
  });

  final double progress;
  final String label;
  final String amount;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 148,
      height: 148,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              centerSpaceRadius: 44,
              sectionsSpace: 0,
              sections: [
                PieChartSectionData(
                  value: progress.clamp(0, 1) * 100,
                  radius: 12,
                  title: '',
                  gradient: LinearGradient(colors: gradientColors),
                ),
                PieChartSectionData(
                  value: (1 - progress.clamp(0, 1)) * 100,
                  radius: 12,
                  title: '',
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(
                amount,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
