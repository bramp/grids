import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';

class NeoTheme extends PuzzleTheme {
  const NeoTheme();

  @override
  String get name => 'Neo';

  @override
  Color get backgroundColor => const Color(0xfff0f2f5); // Soft off-white

  @override
  EdgeInsets get gridPadding => const EdgeInsets.all(24);

  @override
  double get cellPadding => 4; // Spacing to separate bubbles

  // We omit gridBackgroundDecoration because Neo is just floating tiles
  @override
  BoxDecoration? get gridBackgroundDecoration => null;

  @override
  Widget buildCellBackground(
    BuildContext context, {
    required Cell mechanic,
    required bool isLocked,
    required bool isLit,
    required bool hasError,
    required Widget child,
  }) {
    // Determine cell colors based on state
    Color cellColor;
    if (hasError) {
      cellColor = isLit ? Colors.red.shade400 : Colors.red.shade200;
    } else {
      if (isLocked) {
        cellColor = isLit ? Colors.indigo.shade400 : Colors.grey.shade400;
      } else {
        cellColor = isLit ? Colors.blue.shade400 : Colors.white;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(isLocked ? 12 : 16),
        boxShadow: [
          // Subtle soft shadow to make them float
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          if (isLit)
            BoxShadow(
              color: cellColor.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
        border: isLocked
            ? Border.all(color: Colors.indigo.shade200, width: 2)
            : Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  @override
  Widget buildNumberMechanic(BuildContext context, NumberCell cell) {
    return Text(
      cell.number.toString(),
      style: TextStyle(
        fontFamily: 'Roboto', // Default sans-serif, standard in Flutter
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: cell.color != null
            ? _getColor(cell.color!)
            : Colors.grey.shade800,
      ),
    );
  }

  @override
  Widget buildDiamondMechanic(BuildContext context, DiamondCell cell) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          transform: Matrix4.rotationZ(0.785398),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: _getColor(cell.color),
            borderRadius: BorderRadius.circular(6), // Softer corners for neo
            boxShadow: [
              BoxShadow(
                color: _getColor(cell.color).withValues(alpha: 0.5),
                blurRadius: 6,
                offset: const Offset(0, 2),
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
        return Colors.redAccent.shade400;
      case CellColor.black:
        return Colors.grey.shade800; // Softer black
      case CellColor.blue:
        return Colors.blueAccent.shade400;
      case CellColor.yellow:
        return Colors.amber.shade500;
      case CellColor.purple:
        return Colors.purpleAccent.shade400;
      case CellColor.white:
        return Colors.white;
      case CellColor.cyan:
        return Colors.cyanAccent.shade400;
    }
  }
}
