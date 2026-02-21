import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';

class NeobrutalTheme extends PuzzleTheme {
  const NeobrutalTheme();

  @override
  String get name => 'Neobrutal';

  @override
  Color get backgroundColor => const Color(0xFFF4F1EA); // Off-white/cream paper look

  @override
  double get cellPadding => 6;

  @override
  BoxDecoration? get gridBackgroundDecoration => BoxDecoration(
    color: backgroundColor,
    border: Border.all(
      width: 8,
    ), // Massive bold border around grid
    boxShadow: const [
      BoxShadow(
        offset: Offset(8, 8),
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
    Color fillColor;
    if (hasError) {
      fillColor = const Color(0xFFFFCC00); // Hazard yellow
    } else if (isLit) {
      fillColor = const Color(0xFFFF5500); // Stark brutal orange
    } else {
      fillColor = const Color(0xFF999999); // Flat grey for unlit
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 100), // Fast, abrupt animation
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(
              width: 4,
            ), // Thick black outlines everywhere
            borderRadius: BorderRadius.circular(4),
          ),
          child: hasError && !isLit
              ? CustomPaint(painter: _NeobrutalHazardLinesPainter())
              : child,
        ),
        if (isLocked)
          Positioned(
            top: 4,
            right: 4,
            child: Icon(
              Icons.push_pin,
              color: Colors.black.withValues(alpha: 0.8),
              size: 20,
            ),
          ),
      ],
    );
  }

  @override
  Widget buildNumberMechanic(BuildContext context, NumberCell cell) {
    return CustomPaint(
      key: ValueKey('neo_shape_${cell.number}'),
      painter: _NeobrutalShapePainter(
        number: cell.number,
      ),
      child: const SizedBox.expand(),
    );
  }

  @override
  Widget buildDiamondMechanic(BuildContext context, DiamondCell cell) {
    return CustomPaint(
      key: ValueKey('neo_bolt_${cell.color}'),
      painter: _NeobrutalLightningPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _NeobrutalHazardLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    const step = 20.0;
    // Draw diagonal lines
    for (var i = -size.height; i < size.width + size.height; i += step) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i - size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NeobrutalHazardLinesPainter oldDelegate) =>
      false;
}

class _NeobrutalShapePainter extends CustomPainter {
  const _NeobrutalShapePainter({required this.number});
  final int number;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width;
    final h = size.height;

    // Simulate hand-drawn jitter by adding tiny random offsets to points
    // But since `paint` is called every frame (e.g., during animations),
    // we use a fixed seed based on the number so it doesn't vibrate crazily.
    final rand = Random(number);
    Offset j(double dx, double dy) {
      return Offset(
        dx + (rand.nextDouble() - 0.5) * 4,
        dy + (rand.nextDouble() - 0.5) * 4,
      );
    }

    switch (number % 5) {
      case 0:
        // Scribbled Star
        final path = Path();
        final points = [
          j(w * 0.5, h * 0.2),
          j(w * 0.6, h * 0.45),
          j(w * 0.85, h * 0.45),
          j(w * 0.65, h * 0.65),
          j(w * 0.75, h * 0.9),
          j(w * 0.5, h * 0.75),
          j(w * 0.25, h * 0.9),
          j(w * 0.35, h * 0.65),
          j(w * 0.15, h * 0.45),
          j(w * 0.4, h * 0.45),
        ];
        path.moveTo(points[0].dx, points[0].dy);
        for (var i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        path.close();
        canvas.drawPath(path, paint);
      case 1:
        // Imperfect Cloud
        final path = Path()
          ..moveTo(w * 0.3, h * 0.6)
          ..quadraticBezierTo(w * 0.2, h * 0.4, w * 0.4, h * 0.35)
          ..quadraticBezierTo(w * 0.5, h * 0.2, w * 0.65, h * 0.3)
          ..quadraticBezierTo(w * 0.8, h * 0.35, w * 0.75, h * 0.5)
          ..quadraticBezierTo(w * 0.9, h * 0.65, w * 0.75, h * 0.7)
          ..quadraticBezierTo(w * 0.6, h * 0.8, w * 0.4, h * 0.75)
          ..quadraticBezierTo(w * 0.2, h * 0.8, w * 0.25, h * 0.6)
          ..close();
        canvas.drawPath(path, paint);
      case 2:
        // Swirl / spiral
        final path = Path();
        var angle = 0.0;
        var r = 2.0;
        path.moveTo(center.dx, center.dy);
        for (var i = 0; i < 60; i++) {
          angle += 0.3;
          r += 0.5;
          path.lineTo(
            center.dx + r * cos(angle),
            center.dy + r * sin(angle),
          );
        }
        canvas.drawPath(path, paint);
      case 3:
        // Smiley Face
        canvas.drawCircle(center, w * 0.35, paint);
        canvas.drawCircle(
          Offset(center.dx - w * 0.15, center.dy - h * 0.1),
          2,
          paint..style = PaintingStyle.fill,
        );
        canvas.drawCircle(
          Offset(center.dx + w * 0.15, center.dy - h * 0.1),
          2,
          paint..style = PaintingStyle.fill,
        );
        final smile = Path()
          ..moveTo(center.dx - w * 0.2, center.dy + h * 0.1)
          ..quadraticBezierTo(
            center.dx,
            center.dy + h * 0.25,
            center.dx + w * 0.2,
            center.dy + h * 0.1,
          );
        canvas.drawPath(smile, paint..style = PaintingStyle.stroke);
      case 4:
        // Ex'd Box
        canvas.drawRect(
          Rect.fromCenter(center: center, width: w * 0.6, height: h * 0.6),
          paint,
        );
        canvas.drawLine(
          Offset(center.dx - w * 0.3, center.dy - h * 0.3),
          Offset(center.dx + w * 0.3, center.dy + h * 0.3),
          paint,
        );
        canvas.drawLine(
          Offset(center.dx + w * 0.3, center.dy - h * 0.3),
          Offset(center.dx - w * 0.3, center.dy + h * 0.3),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _NeobrutalShapePainter oldDelegate) {
    return oldDelegate.number != number;
  }
}

class _NeobrutalLightningPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Chunky bold lightning bolt
    final path = Path()
      ..moveTo(w * 0.55, h * 0.2)
      ..lineTo(w * 0.3, h * 0.55)
      ..lineTo(w * 0.45, h * 0.55)
      ..lineTo(w * 0.38, h * 0.8)
      ..lineTo(w * 0.7, h * 0.45)
      ..lineTo(w * 0.55, h * 0.45)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NeobrutalLightningPainter oldDelegate) => false;
}
