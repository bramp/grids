import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';

class PixelTheme extends PuzzleTheme {
  const PixelTheme();

  @override
  String get name => 'Pixel Art';

  @override
  Color get backgroundColor => const Color(0xff222034); // PICO-8 dark blue/grey

  @override
  double get cellPadding => 2;

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
    if (hasError) {
      surfaceColor = isLit ? const Color(0xffac3232) : const Color(0xffdf7126);
    } else if (isLit) {
      surfaceColor = isLocked
          ? const Color(0xff5b6ee1)
          : const Color(0xff639bff);
    } else {
      surfaceColor = isLocked
          ? const Color(0xff37946e)
          : const Color(0xff45283c);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100), // snappy like a game
      decoration: BoxDecoration(
        color: surfaceColor,
        // Sharp inner borders simulating bevel
        border: Border(
          top: BorderSide(
            color: isLit
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.3),
            width: 3,
          ),
          left: BorderSide(
            color: isLit
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.3),
            width: 3,
          ),
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.5),
            width: 3,
          ),
          right: BorderSide(
            color: Colors.black.withValues(alpha: 0.5),
            width: 3,
          ),
        ),
      ),
      child: child,
    );
  }

  @override
  Widget buildNumberMechanic(BuildContext context, NumberCell cell) {
    return Text(
      cell.number.toString(),
      style: TextStyle(
        fontFamily: 'Courier', // Fallback to monospace for blocky retro feel
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: cell.color != null
            ? _getColor(cell.color!)
            : const Color(0xffffffff),
        shadows: const [
          Shadow(
            offset: Offset(2, 2),
          ),
        ],
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
          // For pixel art, keep it square instead of rotating
          decoration: BoxDecoration(
            color: _getColor(cell.color),
            border: Border.all(width: 2),
            boxShadow: const [
              BoxShadow(
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              color: Colors.white.withValues(
                alpha: 0.8,
              ), // Inner highlight highlight
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(CellColor color) {
    switch (color) {
      case CellColor.red:
        return const Color(0xffd95763);
      case CellColor.black:
        return const Color(0xff140c1c);
      case CellColor.blue:
        return const Color(0xff5bc9e5);
      case CellColor.yellow:
        return const Color(0xfffbf236);
    }
  }
}
