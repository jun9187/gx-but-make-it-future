import 'package:flutter/material.dart';

import 'app_scaffold.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.extendBody = false,
  });

  final Widget body;
  final Widget? bottomNavigationBar;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBody: extendBody,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
