import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShellDestination {
  const ShellDestination({
    required this.label,
    required this.icon,
    this.isActive = false,
    this.isEnabled = false,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final bool isEnabled;
}

final shellDestinationsProvider = Provider<List<ShellDestination>>((ref) {
  return const [
    ShellDestination(label: 'Home', icon: Icons.home_outlined),
    ShellDestination(label: 'Cards', icon: Icons.credit_card_outlined),
    ShellDestination(
      label: 'FutureFlow',
      icon: Icons.auto_graph_rounded,
      isActive: true,
      isEnabled: true,
    ),
    ShellDestination(label: 'Discover', icon: Icons.explore_outlined),
    ShellDestination(label: 'Profile', icon: Icons.person_outline_rounded),
  ];
});
