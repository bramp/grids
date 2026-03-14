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
    // Define the offset from center for the dots (0.0 to 1.0)
    // 0.7-0.75 is often considered optimal for dice pips
    const offset = 0.7;

    const tl = Alignment(-offset, -offset);
    const tc = Alignment(0, -offset);
    const tr = Alignment(offset, -offset);
    const ml = Alignment(-offset, 0);
    const mc = Alignment.center;
    const mr = Alignment(offset, 0);
    const bl = Alignment(-offset, offset);
    const bc = Alignment(0, offset);
    const br = Alignment(offset, offset);

    final abs = number.abs();
    final positions = <Alignment>[];

    // Standard dice logic expanded up to 9, using absolute value
    final hasCenterCenter = abs % 2 != 0; // 1, 3, 5, 7, 9
    final hasCorners = abs > 1; // 2, 3, 4, 5, 6, 7, 8, 9
    final hasMidLeftRight = abs == 6 || abs == 7 || abs == 8 || abs == 9;
    final hasTopBottomCenter = abs == 8 || abs == 9;
    final hasAllCorners = abs >= 4; // 4, 5, 6, 7, 8, 9

    if (hasCenterCenter) positions.add(mc);

    if (hasCorners) {
      positions
        ..add(tl)
        ..add(br);
    }

    if (hasAllCorners) {
      positions
        ..add(tr)
        ..add(bl);
    }

    if (hasMidLeftRight) {
      positions
        ..add(ml)
        ..add(mr);
    }

    if (hasTopBottomCenter) {
      positions
        ..add(tc)
        ..add(bc);
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
              spreadRadius: -size * 0.05,
              blurRadius: size * 0.4,
            ),
          ],
        ),
      ),
    );
  }
}
