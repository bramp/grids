import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';
import 'package:grids/ui/widgets/dice_dots_widget.dart';

class CasinoTheme extends PuzzleTheme {
  const CasinoTheme();

  @override
  String get name => 'Casino';

  @override
  Color get backgroundColor => const Color(0xff094b28); // Felt green

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
    Color surfaceColor;
    Color borderColor;

    if (hasError) {
      surfaceColor = Colors.red.shade900;
      borderColor = Colors.redAccent;
    } else if (isLocked) {
      surfaceColor = isLit ? const Color(0xff2a2a2a) : const Color(0xff111111);
      borderColor = const Color(0xffd4af37); // Gold edge for Chips
    } else {
      surfaceColor = isLit ? const Color(0xff333333) : const Color(0xff1a1a1a);
      borderColor = isLit ? Colors.white54 : Colors.white12;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: surfaceColor,
        shape: isLocked
            ? BoxShape.circle
            : BoxShape.rectangle, // Locked chips are round
        borderRadius: isLocked ? null : BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: isLocked ? 4 : 1),
        boxShadow: hasError
            ? [const BoxShadow(color: Colors.red, blurRadius: 10)]
            : null,
      ),
      child: child,
    );
  }

  @override
  Widget buildNumberMechanic(BuildContext context, NumberCell cell) {
    return DiceDotsWidget(
      number: cell.number,
      dotColor: cell.color != null ? _getColor(cell.color!) : Colors.white,
    );
  }

  @override
  Widget buildDiamondMechanic(BuildContext context, DiamondCell cell) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          transform: Matrix4.rotationZ(0.785398),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: _getColor(cell.color),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white24, width: 2),
            boxShadow: [
              BoxShadow(
                color: _getColor(cell.color).withValues(alpha: 0.6),
                blurRadius: 8,
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
        return const Color(0xffee2222);
      case CellColor.black:
        return Colors.black; // Jet black
      case CellColor.blue:
        return const Color(0xff2266ee);
      case CellColor.yellow:
        return const Color(0xffeedd22);
      case CellColor.purple:
        return const Color(0xff8822ee);
      case CellColor.white:
        return Colors.white;
      case CellColor.cyan:
        return const Color(0xff22eeee);
    }
  }
}
