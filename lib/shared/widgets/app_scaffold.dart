import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.extendBody = false,
    this.backgroundGradient,
  });

  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool extendBody;
  final Gradient? backgroundGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            backgroundGradient ??
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                AppColors.backgroundSecondary,
                Color(0xFF120B1A),
              ],
            ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: extendBody,
        body: Stack(
          children: [
            const Positioned(
              top: -110,
              right: -24,
              child: _GlowOrb(color: Color(0x447C4DFF), size: 220),
            ),
            const Positioned(
              top: 190,
              left: -80,
              child: _GlowOrb(color: Color(0x33FF4FD8), size: 220),
            ),
            body,
          ],
        ),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 120, spreadRadius: 24),
          ],
        ),
      ),
    );
  }
}
