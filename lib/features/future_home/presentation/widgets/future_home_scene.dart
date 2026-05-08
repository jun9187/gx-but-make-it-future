import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';

class FutureHomeScene extends StatelessWidget {
  const FutureHomeScene({super.key, this.showAtmosphere = true});

  final bool showAtmosphere;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFC59E7B), Color(0xFFB58461), Color(0xFF7D543F)],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: _WallPanel()),
          const _Bookshelf(),
          const _WindowPanel(),
          const _InsectFrame(),
          const _Cabinet(),
          const _Armchair(),
          const _Table(),
          const _Television(),
          const _Rug(),
          if (showAtmosphere) const Positioned.fill(child: _AtmosphereGlow()),
        ],
      ),
    );
  }
}

class _WallPanel extends StatelessWidget {
  const _WallPanel();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _WallPainter());
  }
}

class _Bookshelf extends StatelessWidget {
  const _Bookshelf();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 18,
      top: 70,
      child: Container(
        width: 118,
        height: 194,
        decoration: BoxDecoration(
          color: const Color(0xFFAC774D),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            for (final shelf in [0, 1, 2])
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        top: 20,
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0x80593A26),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _Book(
                            color: shelf == 0
                                ? const Color(0xFF8E3D3C)
                                : const Color(0xFF6480A4),
                            height: shelf == 1 ? 38 : 34,
                          ),
                          const SizedBox(width: 4),
                          _Book(
                            color: const Color(0xFF4C6C58),
                            height: shelf == 0 ? 32 : 36,
                          ),
                          const SizedBox(width: 4),
                          _Book(
                            color: const Color(0xFFB7A06B),
                            height: shelf == 2 ? 28 : 34,
                          ),
                          const SizedBox(width: 4),
                          _Book(
                            color: const Color(0xFF7C3E38),
                            height: shelf == 1 ? 30 : 36,
                          ),
                          const Spacer(),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC5D7A2),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WindowPanel extends StatelessWidget {
  const _WindowPanel();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 18,
      top: 84,
      child: Container(
        width: 94,
        height: 146,
        decoration: BoxDecoration(
          color: const Color(0xFFE8D6B7),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 12,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFBDEBD2), Color(0xFF5AA565)],
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 45,
              top: 6,
              bottom: 6,
              child: VerticalDivider(
                color: Color(0x80B47F53),
                thickness: 2,
                width: 2,
              ),
            ),
            const Positioned(
              left: 6,
              right: 6,
              top: 68,
              child: Divider(color: Color(0x80B47F53), thickness: 2, height: 2),
            ),
            Positioned(
              right: 10,
              top: 16,
              child: Transform.rotate(
                angle: -0.25,
                child: Container(
                  width: 22,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0x4D315B1A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsectFrame extends StatelessWidget {
  const _InsectFrame();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 156,
      top: 62,
      child: Container(
        width: 114,
        height: 112,
        decoration: BoxDecoration(
          color: const Color(0xFFE7DECF),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0x80614A33), width: 3),
        ),
        child: Stack(
          children: const [
            _Bug(top: 12, left: 24, color: Color(0xFF5E3222), scale: 0.75),
            _Bug(top: 14, right: 20, color: Color(0xFF1E211D), scale: 0.72),
            _Bug(top: 40, left: 54, color: Color(0xFFB87415), scale: 1.0),
            _Bug(bottom: 12, right: 26, color: Color(0xFF3C2C1C), scale: 1.15),
            _Bug(bottom: 16, left: 22, color: Color(0xFF313131), scale: 0.85),
          ],
        ),
      ),
    );
  }
}

class _Bug extends StatelessWidget {
  const _Bug({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.color,
    required this.scale,
  });

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Color color;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Transform.scale(
        scale: scale,
        child: SizedBox(
          width: 26,
          height: 26,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 10,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              for (final dx in [-8.0, -5.0, 5.0, 8.0])
                Positioned(
                  left: dx.isNegative ? 2 : null,
                  right: dx.isNegative ? null : 2,
                  child: Transform.rotate(
                    angle: dx.isNegative ? -0.7 : 0.7,
                    child: Container(
                      width: 10,
                      height: 1.8,
                      color: color.withValues(alpha: 0.9),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cabinet extends StatelessWidget {
  const _Cabinet();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 86,
      top: 208,
      child: Container(
        width: 98,
        height: 112,
        decoration: BoxDecoration(
          color: const Color(0xFFD7B98A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xAA8E5C3A), width: 2),
        ),
        child: Stack(
          children: [
            const Positioned(
              left: 47,
              top: 0,
              bottom: 0,
              child: VerticalDivider(
                color: Color(0x806E492D),
                thickness: 2,
                width: 2,
              ),
            ),
            for (final left in [37.0, 58.0])
              Positioned(
                left: left,
                top: 48,
                child: Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF865333),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Armchair extends StatelessWidget {
  const _Armchair();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      bottom: 92,
      child: SizedBox(
        width: 132,
        height: 140,
        child: Stack(
          children: [
            Positioned(
              left: 10,
              right: 10,
              bottom: 0,
              child: Container(
                height: 82,
                decoration: BoxDecoration(
                  color: const Color(0xFFB77E4E),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 34,
              child: Container(
                width: 34,
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xFFB77E4E),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 34,
              child: Container(
                width: 34,
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xFFB77E4E),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(
              left: 26,
              right: 26,
              top: 12,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFCC9762),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            Positioned.fill(child: CustomPaint(painter: _SeatButtonPainter())),
          ],
        ),
      ),
    );
  }
}

class _Table extends StatelessWidget {
  const _Table();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 122,
      bottom: 46,
      child: SizedBox(
        width: 118,
        height: 74,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: 108,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFC28C54),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              child: Container(
                width: 14,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF986845),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            Positioned(
              left: 28,
              bottom: 0,
              child: Container(
                width: 8,
                height: 24,
                color: const Color(0xFF986845),
              ),
            ),
            Positioned(
              right: 28,
              bottom: 0,
              child: Container(
                width: 8,
                height: 24,
                color: const Color(0xFF986845),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Television extends StatelessWidget {
  const _Television();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -10,
      bottom: 48,
      child: SizedBox(
        width: 108,
        height: 122,
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 0,
              child: Container(
                width: 80,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF36353A),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF4D4D52), width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x28000000),
                      blurRadius: 12,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 42,
              top: 72,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF28282E),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Positioned(
              left: 28,
              top: 88,
              child: Container(
                width: 44,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C31),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 54,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF8D4C2E),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Rug extends StatelessWidget {
  const _Rug();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 84,
      right: 34,
      bottom: 8,
      child: Container(
        height: 98,
        decoration: BoxDecoration(
          color: const Color(0xFFE0C398),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: const Color(0x55A1724D), width: 1.5),
        ),
        child: CustomPaint(painter: _RugPatternPainter()),
      ),
    );
  }
}

class _AtmosphereGlow extends StatelessWidget {
  const _AtmosphereGlow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.04),
              Colors.transparent,
              const Color(0x66000000),
            ],
          ),
        ),
      ),
    );
  }
}

class _Book extends StatelessWidget {
  const _Book({required this.color, required this.height});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 14,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

class _WallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final floorPaint = Paint()..color = const Color(0xFF9B6A4A);
    final wallShadowPaint = Paint()..color = const Color(0x22000000);

    final wall = Path()
      ..moveTo(0, size.height * 0.18)
      ..lineTo(size.width * 0.48, size.height * 0.18)
      ..lineTo(size.width * 0.48, size.height * 0.72)
      ..lineTo(0, size.height * 0.72)
      ..close();
    canvas.drawPath(wall, Paint()..color = const Color(0xFFCDB5A0));

    final backWall = Path()
      ..moveTo(size.width * 0.48, size.height * 0.18)
      ..lineTo(size.width, size.height * 0.18)
      ..lineTo(size.width, size.height * 0.72)
      ..lineTo(size.width * 0.48, size.height * 0.72)
      ..close();
    canvas.drawPath(backWall, Paint()..color = const Color(0xFFD7C7B7));

    final floor = Path()
      ..moveTo(0, size.height * 0.72)
      ..lineTo(size.width, size.height * 0.72)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(floor, floorPaint);

    canvas.drawLine(
      Offset(size.width * 0.48, size.height * 0.18),
      Offset(size.width * 0.48, size.height * 0.72),
      Paint()
        ..color = const Color(0x88675A4E)
        ..strokeWidth = 2,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.47,
        size.height * 0.18,
        10,
        size.height * 0.54,
      ),
      wallShadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SeatButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x664F3422);
    for (final offset in const [
      Offset(62, 52),
      Offset(78, 58),
      Offset(90, 48),
      Offset(72, 70),
      Offset(96, 68),
    ]) {
      canvas.drawCircle(offset, 2.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RugPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()..color = const Color(0x66885A34);
    for (double y = 18; y < size.height - 10; y += 22) {
      for (double x = 14; x < size.width - 10; x += 20) {
        canvas.drawCircle(Offset(x, y), 1.6, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
