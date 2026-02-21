import 'package:flutter/material.dart';

/// A widget that renders a number as an arrangement of dots (like a die).
/// Supports numbers 1 through 9.
class DiceDotsWidget extends StatelessWidget {
  const DiceDotsWidget({
    required this.number,
    required this.dotColor,
    this.boxShadow,
    super.key,
  });

  final int number;
  final Color dotColor;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    if (number < 1 || number > 9) {
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

    final positions = <Alignment>[];

    // Standard dice logic expanded up to 9
    final hasCenterCenter = number % 2 != 0; // 1, 3, 5, 7, 9
    final hasCorners = number > 1; // 2, 3, 4, 5, 6, 7, 8, 9
    final hasMidLeftRight =
        number == 6 || number == 7 || number == 8 || number == 9;
    final hasTopBottomCenter = number == 8 || number == 9;
    final hasAllCorners = number >= 4; // 4, 5, 6, 7, 8, 9

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

    return positions.map((align) => _buildDot(align, size)).toList();
  }

  Widget _buildDot(Alignment alignment, double size) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: dotColor,
          shape: BoxShape.circle,
          boxShadow: boxShadow,
        ),
      ),
    );
  }
}
