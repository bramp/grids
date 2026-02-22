import 'package:flutter/material.dart';

/// A widget that renders a number as an arrangement of dots (like a die).
///
/// Supports numbers 1–9 (positive) and -1 to -9 (negative).
/// - Positive numbers render as **filled** dots.
/// - Negative numbers render as **outlined** dots (hollow circles), using the
///   absolute value to determine the dot pattern.
class DiceDotsWidget extends StatelessWidget {
  const DiceDotsWidget({
    required this.number,
    required this.dotColor,
    required this.backgroundColor,
    this.boxShadow = const [],
    super.key,
  }) : assert(number != 0, 'DiceDotsWidget does not support 0');

  final int number;
  final Color dotColor;
  final Color backgroundColor;
  final List<BoxShadow> boxShadow;

  @override
  Widget build(BuildContext context) {
    final abs = number.abs();
    if (abs < 1 || abs > 9) {
      // Fallback if number is out of visual bounds
      return Text(
        number.toString(),
        style: TextStyle(color: dotColor, fontWeight: FontWeight.bold),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final dotSize = constraints.maxWidth * 0.2;
        final padding = constraints.maxWidth * 0.1;

        return Padding(
          padding: EdgeInsets.all(padding),
          child: Stack(
            children: _buildDots(dotSize),
          ),
        );
      },
    );
  }

  List<Widget> _buildDots(double size) {
    // 3x3 positions grid mapping
    // TL, TC, TR
    // ML, MC, MR
    // BL, BC, BR

    final abs = number.abs();
    final positions = <Alignment>[];

    // Standard dice logic expanded up to 9, using absolute value
    final hasCenterCenter = abs % 2 != 0; // 1, 3, 5, 7, 9
    final hasCorners = abs > 1; // 2, 3, 4, 5, 6, 7, 8, 9
    final hasMidLeftRight = abs == 6 || abs == 7 || abs == 8 || abs == 9;
    final hasTopBottomCenter = abs == 8 || abs == 9;
    final hasAllCorners = abs >= 4; // 4, 5, 6, 7, 8, 9

    if (hasCenterCenter) positions.add(Alignment.center);

    if (hasCorners) {
      positions
        ..add(Alignment.topLeft)
        ..add(Alignment.bottomRight);
    }

    if (hasAllCorners) {
      positions
        ..add(Alignment.topRight)
        ..add(Alignment.bottomLeft);
    }

    if (hasMidLeftRight) {
      positions
        ..add(Alignment.centerLeft)
        ..add(Alignment.centerRight);
    }

    if (hasTopBottomCenter) {
      positions
        ..add(Alignment.topCenter)
        ..add(Alignment.bottomCenter);
    }

    final filled = number > 0;
    return positions.map((align) => _buildDot(align, size, filled)).toList();
  }

  Widget _buildDot(Alignment alignment, double size, bool filled) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: filled ? dotColor : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: dotColor, width: size * 0.15),
          boxShadow: [
            ...boxShadow,

            // This shadow fills in the middle with the background colour.
            // Otherwise the entire inside of the dot is glow effect.
            BoxShadow(
              color: backgroundColor,
              spreadRadius: -2,
              blurRadius: 16,
            ),
          ],
        ),
      ),
    );
  }
}
