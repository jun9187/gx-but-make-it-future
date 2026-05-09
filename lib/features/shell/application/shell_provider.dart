import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShellDestination {
  const ShellDestination({
    required this.label,
    required this.icon,
    required this.routePath,
    this.isActive = false,
    this.isEnabled = false,
  });

  final String label;
  final IconData icon;
  final String routePath;
  final bool isActive;
  final bool isEnabled;
}

final shellDestinationsProvider =
    Provider.family<List<ShellDestination>, String>((ref, currentPath) {
      const homePaths = {
        '/gxbank-home',
        '/flowguard-qr-demo',
        '/flowguard-qr-confirm',
        '/flowguard-alert-demo',
      };
      const futureFlowPaths = {
        '/dashboard',
        '/future-flow',
        '/cash-flow',
        '/flowguard',
        '/future-home',
      };

      final isHomeActive = homePaths.contains(currentPath);
      final isFutureFlowActive = futureFlowPaths.contains(currentPath);

      return [
        ShellDestination(
          label: 'Home',
          icon: Icons.home_outlined,
          routePath: '/gxbank-home',
          isActive: isHomeActive,
          isEnabled: true,
        ),
        const ShellDestination(
          label: 'Cards',
          icon: Icons.credit_card_outlined,
          routePath: '',
        ),
        ShellDestination(
          label: 'FutureFlow',
          icon: Icons.auto_graph_rounded,
          routePath: '/dashboard',
          isActive: isFutureFlowActive,
          isEnabled: true,
        ),
        const ShellDestination(
          label: 'Discover',
          icon: Icons.explore_outlined,
          routePath: '',
        ),
        const ShellDestination(
          label: 'Profile',
          icon: Icons.person_outline_rounded,
          routePath: '',
        ),
      ];
    });
