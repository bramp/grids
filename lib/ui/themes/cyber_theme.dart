import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';

class CyberTheme extends PuzzleTheme {
  const CyberTheme();

  @override
  String get name => 'Cyber';

  @override
  Color get backgroundColor => const Color(0xFF0D0E15); // Deep dark blue-black

  @override
  double get cellPadding => 4;

  @override
  Widget buildCellBackground(
    BuildContext context, {
    required Cell mechanic,
    required bool isLocked,
    required bool isLit,
    required bool hasError,
    required Widget child,
  }) {
    // Determine the base color
    Color glowColor;
    if (hasError) {
      glowColor = Colors.redAccent;
    } else if (mechanic is DiamondCell) {
      glowColor = _getColor(mechanic.color);
    } else if (mechanic is NumberCell && mechanic.color != null) {
      glowColor = _getColor(mechanic.color!);
    } else {
      glowColor = const Color(0xFF00FFCC); // Default Neon Cyan
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutExpo,
      decoration: BoxDecoration(
        color: isLit
            ? glowColor.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLit
              ? glowColor.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.1),
          width: isLit ? 2 : 1,
        ),
        boxShadow: isLit
            ? [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.2),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ]
            : [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: glowColor.withValues(alpha: 0),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Glassmorphism subtle white gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.05),
                  Colors.white.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          if (isLocked)
            Center(
              child: Icon(
                Icons.lock_outline,
                color: Colors.white.withValues(alpha: 0.3),
                size: 32,
              ),
            ),
          child,
        ],
      ),
    );
  }

  @override
  Widget buildNumberMechanic(BuildContext context, NumberCell cell) {
    // In Cyber theme, we replace simple numbers with neon geometric shapes
    // To maintain gameplay identity, we'll map numbers to specific shapes
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: CustomPaint(
        key: ValueKey('${cell.number}_${cell.color}'),
        painter: _CyberShapePainter(
          number: cell.number,
          color: cell.color != null
              ? _getColor(cell.color!)
              : const Color(0xFF00FFCC),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  @override
  Widget buildDiamondMechanic(BuildContext context, DiamondCell cell) {
    // For Cyber Theme, diamonds are glowing lightning bolts
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: CustomPaint(
        key: ValueKey('lightning_${cell.color}'),
        painter: _CyberLightningPainter(
          color: _getColor(cell.color),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  Color _getColor(CellColor color) {
    switch (color) {
      case CellColor.red:
        return const Color(0xFFFF0055); // Neon Pink/Red
      case CellColor.black:
        return const Color(0xFF555555); // Cannot have glowing black easily
      case CellColor.blue:
        return const Color(0xFF0055FF); // Neon Blue
      case CellColor.yellow:
        return const Color(0xFFFFDD00); // Neon Yellow
      case CellColor.purple:
        return const Color(0xFFAA00FF); // Neon Purple
      case CellColor.white:
        return const Color(0xFFFFFFFF); // Pure White
      case CellColor.cyan:
        return const Color(0xFF00FFCC); // Neon Cyan
    }
  }
}

class _CyberShapePainter extends CustomPainter {
  const _CyberShapePainter({required this.number, required this.color});
  final int number;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.25;

    // Draw a glow behind the line
    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    void drawShape() {
      switch (number % 5) {
        case 0:
        case 1:
          // Triangle
          final path = Path();
          for (var i = 0; i < 3; i++) {
            final angle = (i * 2 * pi / 3) - (pi / 2);
            final point = Offset(
              center.dx + radius * cos(angle),
              center.dy + radius * sin(angle),
            );
            if (i == 0) {
              path.moveTo(point.dx, point.dy);
            } else {
              path.lineTo(point.dx, point.dy);
            }
          }
          path.close();
          canvas
            ..drawPath(path, shadowPaint)
            ..drawPath(path, paint);
        case 2:
          // 'X' Cross
          canvas
            ..drawLine(
              Offset(center.dx - radius, center.dy - radius),
              Offset(center.dx + radius, center.dy + radius),
              shadowPaint,
            )
            ..drawLine(
              Offset(center.dx + radius, center.dy - radius),
              Offset(center.dx - radius, center.dy + radius),
              shadowPaint,
            )
            ..drawLine(
              Offset(center.dx - radius, center.dy - radius),
              Offset(center.dx + radius, center.dy + radius),
              paint,
            )
            ..drawLine(
              Offset(center.dx + radius, center.dy - radius),
              Offset(center.dx - radius, center.dy + radius),
              paint,
            );
        case 3:
          // Circle
          canvas
            ..drawCircle(center, radius, shadowPaint)
            ..drawCircle(center, radius, paint);
        case 4:
          // Rune 'M' / Sigma like shape
          final path = Path()
            ..moveTo(center.dx - radius, center.dy + radius)
            ..lineTo(center.dx - radius, center.dy - radius)
            ..lineTo(center.dx, center.dy)
            ..lineTo(center.dx + radius, center.dy - radius)
            ..lineTo(center.dx + radius, center.dy + radius);
          canvas
            ..drawPath(path, shadowPaint)
            ..drawPath(path, paint);
      }
    }

    drawShape();
  }

  @override
  bool shouldRepaint(covariant _CyberShapePainter oldDelegate) {
    return oldDelegate.number != number || oldDelegate.color != color;
  }
}

class _CyberLightningPainter extends CustomPainter {
  const _CyberLightningPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final w = size.width;
    final h = size.height;

    // A classic lightning bolt shape
    final path = Path()
      ..moveTo(w * 0.6, h * 0.2)
      ..lineTo(w * 0.35, h * 0.55)
      ..lineTo(w * 0.5, h * 0.55)
      ..lineTo(w * 0.4, h * 0.8)
      ..lineTo(w * 0.75, h * 0.45)
      ..lineTo(w * 0.55, h * 0.45)
      ..close();

    canvas
      ..drawPath(path, shadowPaint)
      ..drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CyberLightningPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
