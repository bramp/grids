import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';
import 'package:grids/ui/widgets/dice_dots_widget.dart';

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
    return DiceDotsWidget(
      key: ValueKey('neo_dots_${cell.number}'),
      number: cell.number,
      dotColor: Colors.black,
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
