import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';

class PastelTheme extends PuzzleTheme {
  const PastelTheme();

  @override
  String get name => 'Pastel';

  @override
  // Soft grey-blue background
  Color get backgroundColor => const Color(0xFFC7D0D8);

  @override
  double get cellPadding => 8;

  @override
  BoxDecoration? get gridBackgroundDecoration => BoxDecoration(
    color: const Color(0xFFF0F4F8), // Soft white/cream board base
    borderRadius: BorderRadius.circular(32),
    boxShadow: [
      // Outer drop shadow
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        offset: const Offset(10, 10),
        blurRadius: 20,
      ),
      // Inner highlight
      const BoxShadow(
        color: Colors.white,
        offset: Offset(-10, -10),
        blurRadius: 20,
      ),
    ],
  );

  @override
  Widget buildCellBackground(
    BuildContext context, {
    required Cell mechanic,
    required bool isLocked,
    required bool isLit,
    required bool hasError,
    required Widget child,
  }) {
    // Neumorphic/Claymorphic base
    // If it's lit, it looks pressed IN and glows. If unlit, it pops OUT.

    final Color baseColor;
    if (hasError) {
      baseColor = const Color(0xFFFFD1D1); // Soft pastel red
    } else if (isLit) {
      baseColor = const Color(0xFFFFF9E6); // Very soft yellow glow
    } else {
      baseColor = const Color(0xFFF0F4F8); // Same as board material
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16),
        border: isLit
            ? Border.all(color: const Color(0xFFFFD966), width: 3)
            : null,
        boxShadow: isLit
            ? [
                // Pressed in look
                // (inner shadow via simulation, or tight drop shadow)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
                const BoxShadow(
                  color: Colors.transparent,
                  offset: Offset(-4, -4),
                  blurRadius: 10,
                ),
              ]
            : [
                // Popped out look
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  offset: const Offset(6, 6),
                  blurRadius: 10,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 10,
                ),
              ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          if (isLocked)
            Positioned(
              bottom: 4,
              right: 4,
              child: Icon(
                Icons.lock_rounded,
                color: Colors.blueGrey.withValues(alpha: 0.3),
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget buildNumberMechanic(BuildContext context, NumberCell cell) {
    return _ClaymorphicShape(number: cell.number);
  }

  @override
  Widget buildDiamondMechanic(BuildContext context, DiamondCell cell) {
    // Make diamonds look like soft blue squiggles/swirls
    return const _ClaymorphicShape(number: 99);
  }
}

class _ClaymorphicShape extends StatelessWidget {
  const _ClaymorphicShape({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    Color shapeColor;
    CustomPainter painter;

    switch (number % 5) {
      case 0: // Star
        shapeColor = const Color(0xFFFFDF70); // Pastel yellow
        painter = _PastelStarPainter(color: shapeColor);
      case 1: // Cloud
        shapeColor = const Color(0xFF88D2E6); // Pastel blue
        painter = _PastelCloudPainter(color: shapeColor);
      case 2: // Leaf
        shapeColor = const Color(0xFFA1E3A0); // Pastel green
        painter = _PastelLeafPainter(color: shapeColor);
      case 3: // Face
        shapeColor = const Color(0xFFFFAE88); // Pastel peach
        painter = _PastelFacePainter(color: shapeColor);
      default: // Swirl (for case 4 and Diamonds)
        shapeColor = const Color(0xFF6A79A5); // Muted navy/purple
        painter = _PastelSwirlPainter(color: shapeColor);
    }

    // We do a "clay" effect by drawing the shape twice,
    // shifted to create a 3D bevel
    return Stack(
      fit: StackFit.expand,
      children: [
        // Drop shadow of the shape
        Transform.translate(
          offset: const Offset(2, 4),
          child: CustomPaint(
            painter: _ShadowClonePainter(painter),
            child: const SizedBox.expand(),
          ),
        ),
        // The actual shape
        CustomPaint(
          painter: painter,
          child: const SizedBox.expand(),
        ),
        // A white highlight shifted up and left
        Transform.translate(
          offset: const Offset(-1.5, -1.5),
          child: CustomPaint(
            painter: _HighlightClonePainter(painter),
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

// Below are the vector painters for the soft shapes.

class _PastelStarPainter extends CustomPainter {
  const _PastelStarPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width;

    final path = Path();
    var angle = -pi / 2;
    final rOuter = w * 0.4;
    final rInner = w * 0.2;

    for (var i = 0; i < 5; i++) {
      var dx = center.dx + cos(angle) * rOuter;
      var dy = center.dy + sin(angle) * rOuter;
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
      angle += pi / 5;

      dx = center.dx + cos(angle) * rInner;
      dy = center.dy + sin(angle) * rInner;
      path.lineTo(dx, dy);
      angle += pi / 5;
    }
    path.close();

    // Use a thick stroke to heavily round the star points
    canvas
      ..drawPath(path, paint)
      ..drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.1
          ..strokeJoin = StrokeJoin.round,
      );
  }

  @override
  bool shouldRepaint(covariant _PastelStarPainter oldDelegate) => false;
}

class _PastelCloudPainter extends CustomPainter {
  const _PastelCloudPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    final path = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(center.dx - w * 0.15, center.dy + h * 0.1),
          width: w * 0.4,
          height: h * 0.3,
        ),
      )
      ..addOval(
        Rect.fromCenter(
          center: Offset(center.dx + w * 0.15, center.dy + h * 0.1),
          width: w * 0.4,
          height: h * 0.3,
        ),
      )
      ..addOval(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - h * 0.05),
          width: w * 0.45,
          height: h * 0.45,
        ),
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PastelCloudPainter oldDelegate) => false;
}

class _PastelLeafPainter extends CustomPainter {
  const _PastelLeafPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    canvas
      ..save()
      ..translate(w / 2, h / 2)
      ..rotate(-pi / 6) // tilt it
      ..translate(-w / 2, -h / 2);

    final path = Path()
      ..moveTo(w * 0.2, h * 0.8)
      ..quadraticBezierTo(w * 0.1, h * 0.2, w * 0.8, h * 0.2)
      ..quadraticBezierTo(w * 0.8, h * 0.9, w * 0.2, h * 0.8)
      ..close();
    canvas.drawPath(path, paint);

    // Tiny cutouts for leaf veins
    final veinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = w * 0.04
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawLine(
        Offset(w * 0.3, h * 0.7),
        Offset(w * 0.6, h * 0.4),
        veinPaint,
      )
      ..drawLine(
        Offset(w * 0.45, h * 0.55),
        Offset(w * 0.6, h * 0.65),
        veinPaint,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _PastelLeafPainter oldDelegate) => false;
}

class _PastelFacePainter extends CustomPainter {
  const _PastelFacePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    canvas.drawCircle(center, w * 0.35, paint);

    // Eyes and mouth punched out
    final punchPaint = Paint()
      ..blendMode = BlendMode.dstOut
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas
      ..saveLayer(Rect.fromLTWH(0, 0, w, h), Paint())
      ..drawCircle(center, w * 0.35, paint)
      ..drawCircle(
        Offset(center.dx - w * 0.15, center.dy - h * 0.05),
        w * 0.05,
        punchPaint,
      )
      ..drawCircle(
        Offset(center.dx + w * 0.15, center.dy - h * 0.05),
        w * 0.05,
        punchPaint,
      );

    final smile = Path()
      ..moveTo(center.dx - w * 0.15, center.dy + h * 0.1)
      ..quadraticBezierTo(
        center.dx,
        center.dy + h * 0.25,
        center.dx + w * 0.15,
        center.dy + h * 0.1,
      );

    canvas
      ..drawPath(
        smile,
        Paint()
          ..blendMode = BlendMode.dstOut
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.06
          ..strokeCap = StrokeCap.round,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _PastelFacePainter oldDelegate) => false;
}

class _PastelSwirlPainter extends CustomPainter {
  const _PastelSwirlPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    final path = Path();
    var angle = 0.0;
    var r = 1.0;
    path.moveTo(center.dx, center.dy);
    for (var i = 0; i < 40; i++) {
      angle += 0.4;
      r += w * 0.01;
      path.lineTo(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PastelSwirlPainter oldDelegate) => false;
}

// These clones reuse the base painters but force them to draw
// entirely in shadow or highlight colors
class _ShadowClonePainter extends CustomPainter {
  _ShadowClonePainter(this.basePainter);
  final CustomPainter basePainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..colorFilter = const ColorFilter.mode(Colors.black26, BlendMode.srcIn),
    );
    basePainter.paint(canvas, size);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShadowClonePainter oldDelegate) => true;
}

class _HighlightClonePainter extends CustomPainter {
  _HighlightClonePainter(this.basePainter);
  final CustomPainter basePainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..colorFilter = const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
    );
    basePainter.paint(canvas, size);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HighlightClonePainter oldDelegate) => true;
}
