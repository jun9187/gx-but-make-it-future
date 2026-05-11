import 'package:flutter/material.dart';

import 'icon_circle.dart';
import 'pill_badge.dart';

class MetricChip extends StatelessWidget {
  const MetricChip({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PillBadge(
      label: label,
      onTap: onTap,
      leading: IconCircle(
        icon: icon,
        size: 20,
        iconSize: 12,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
