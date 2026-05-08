import 'package:flutter/material.dart';

import '../../../shared/widgets/screen_placeholder.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  static const routeName = 'shop';
  static const routePath = '/shop';

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Shop',
      eyebrow: 'Marketplace',
      description:
          'Offers, rewards, and curated financial lifestyle add-ons can grow from this placeholder.',
      icon: Icons.shopping_bag_rounded,
    );
  }
}
