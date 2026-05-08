import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cash_flow/presentation/cash_flow_screen.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../flowguard/presentation/flowguard_screen.dart';
import '../../future_flow/presentation/future_flow_screen.dart';
import '../../future_home/presentation/future_home_screen.dart';
import '../../shop/presentation/shop_screen.dart';

class ShellDestination {
  const ShellDestination({
    required this.label,
    required this.icon,
    required this.routePath,
  });

  final String label;
  final IconData icon;
  final String routePath;
}

final shellDestinationsProvider = Provider<List<ShellDestination>>((ref) {
  return const [
    ShellDestination(
      label: 'Dashboard',
      icon: Icons.space_dashboard_rounded,
      routePath: DashboardScreen.routePath,
    ),
    ShellDestination(
      label: 'FutureFlow',
      icon: Icons.auto_graph_rounded,
      routePath: FutureFlowScreen.routePath,
    ),
    ShellDestination(
      label: 'Cash Flow',
      icon: Icons.pie_chart_rounded,
      routePath: CashFlowScreen.routePath,
    ),
    ShellDestination(
      label: 'FlowGuard',
      icon: Icons.security_rounded,
      routePath: FlowguardScreen.routePath,
    ),
    ShellDestination(
      label: 'Future Home',
      icon: Icons.home_work_rounded,
      routePath: FutureHomeScreen.routePath,
    ),
    ShellDestination(
      label: 'Shop',
      icon: Icons.shopping_bag_rounded,
      routePath: ShopScreen.routePath,
    ),
  ];
});
