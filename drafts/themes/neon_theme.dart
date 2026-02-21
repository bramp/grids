import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';

class NeonTheme extends PuzzleTheme {
  const NeonTheme();

  @override
  String get name => 'Neon';

  @override
  Color get backgroundColor => const Color(0xff050510); // Pitch dark night

  @override
  double get cellPadding => 6;

  @override
  Widget buildCellBackground(
    BuildContext context, {
    required Cell mechanic,
    required bool isLocked,
    required bool isLit,
    required bool hasError,
    required Widget child,
  }) {
    Color glowColor;
    if (hasError) {
      glowColor = Colors.redAccent.shade400;
    } else if (isLit) {
      glowColor = Colors.cyanAccent.shade400;
    } else {
      glowColor = Colors.transparent;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isLocked ? const Color(0xff111122) : const Color(0xff0a0a1a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLit
              ? glowColor.withValues(alpha: 0.8)
              : (isLocked ? Colors.white30 : Colors.white12),
          width: isLit ? 2 : 1,
        ),
        boxShadow: isLit || hasError
            ? [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.6),
                  blurRadius: isLit ? 16 : 24,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.2),
                  blurRadius: 32,
                  spreadRadius: 8,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  @override
  Widget buildNumberMechanic(BuildContext context, NumberCell cell) {
    final color = cell.color != null ? _getColor(cell.color!) : Colors.white;
    return Text(
      cell.number.toString(),
      style: TextStyle(
        fontFamily:
            'Montserrat', // Modern font if available, fallback otherwise
        fontSize: 26,
        fontWeight: FontWeight.w300,
        color: color,
        shadows: [
          Shadow(
            color: color,
            blurRadius: 12,
          ),
          Shadow(
            color: color,
            blurRadius: 24,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildDiamondMechanic(BuildContext context, DiamondCell cell) {
    final color = _getColor(cell.color);
    return Padding(
      padding: const EdgeInsets.all(14),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          transform: Matrix4.rotationZ(0.785398),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color,
                blurRadius: 16,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 32,
                spreadRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor(CellColor color) {
    switch (color) {
      case CellColor.red:
        return Colors.pinkAccent.shade400; // More neon pink/red
      case CellColor.black:
        return Colors.purpleAccent.shade400; // Black mechanics get purple neon
      case CellColor.blue:
        return Colors.cyanAccent.shade400;
      case CellColor.yellow:
        return Colors.limeAccent.shade400;
      case CellColor.purple:
        return Colors.deepPurpleAccent.shade400;
      case CellColor.white:
        return Colors.white;
      case CellColor.cyan:
        return Colors.cyanAccent.shade400;
    }
  }
}
