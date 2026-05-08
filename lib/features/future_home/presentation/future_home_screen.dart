import 'package:flutter/material.dart';

import '../../../shared/widgets/screen_placeholder.dart';

class FutureHomeScreen extends StatelessWidget {
  const FutureHomeScreen({super.key});

  static const routeName = 'future-home';
  static const routePath = '/future-home';

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Future Home',
      eyebrow: 'Home ownership goal',
      description:
          'Deposit milestones, affordability modelling, and timeline nudges will be added here.',
      icon: Icons.home_work_rounded,
    );
  }
}
