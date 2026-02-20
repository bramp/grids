import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';

class ClassicTheme extends PuzzleTheme {
  const ClassicTheme();

  @override
  String get name => 'Classic';

  @override
  Color get backgroundColor => const Color(0xff121212);

  @override
  double get cellPadding => 0; // Tightly packed

  @override
  Widget buildCellBackground(
    BuildContext context, {
    required Cell mechanic,
    required bool isLocked,
    required bool isLit,
    required bool hasError,
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        border: Border.all(
          color: isLocked ? Colors.white54 : Colors.white12,
          width: isLocked ? 2 : 1,
        ),
        color: hasError
            ? Colors.red.withValues(alpha: isLit ? 0.9 : 0.4)
            : isLit
            ? (isLocked ? Colors.indigoAccent : Colors.blueAccent)
            : (isLocked ? Colors.black : Colors.grey[900]),
        borderRadius: isLocked ? BorderRadius.circular(4) : null,
      ),
      child: child,
    );
  }

  @override
  Widget buildNumberMechanic(BuildContext context, NumberCell cell) {
    return Text(
      cell.number.toString(),
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: cell.color != null ? _getColor(cell.color!) : Colors.white,
      ),
    );
  }

  @override
  Widget buildDiamondMechanic(BuildContext context, DiamondCell cell) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          // Rotate a square 45 degrees to make a diamond
          transform: Matrix4.rotationZ(0.785398), // 45 degrees in radians
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: _getColor(cell.color),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(2, 2),
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
        return Colors.redAccent;
      case CellColor.black:
        return Colors.black87;
      case CellColor.blue:
        return Colors.blueAccent;
      case CellColor.yellow:
        return Colors.amber;
    }
  }
}
