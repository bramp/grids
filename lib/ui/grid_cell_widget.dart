import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/providers/puzzle_provider.dart';
import 'package:grids/ui/cell_symbol_renderer.dart';
import 'package:provider/provider.dart';

class GridCellWidget extends StatelessWidget {
  const GridCellWidget({required this.point, super.key});
  final GridPoint point;

  @override
  Widget build(BuildContext context) {
    // Only rebuild this specific widget if its own lit state or error state
    // changes
    final isLit = context.select<PuzzleProvider, bool>(
      (p) => p.grid.isLit(point),
    );
    final hasError = context.select<PuzzleProvider, bool>(
      (p) => p.validation?.errors.contains(point) ?? false,
    );
    final mechanic = context.select<PuzzleProvider, Cell>(
      (p) => p.grid.getMechanic(point),
    );
    final isLocked = context.select<PuzzleProvider, bool>(
      (p) => p.grid.isLocked(point),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        // Subtle border for the grid lines
        border: Border.all(
          color: isLocked ? Colors.white54 : Colors.white12,
          width: isLocked ? 2 : 1,
        ),
        // Change color based on lit state, highlighting failing cells as red
        color: hasError
            ? Colors.red.withValues(alpha: isLit ? 0.9 : 0.4)
            : isLit
            ? (isLocked ? Colors.indigoAccent : Colors.blueAccent)
            : (isLocked ? Colors.black : Colors.grey[900]),
        borderRadius: isLocked ? BorderRadius.circular(4) : null,
      ),
      child: Center(
        child: CellSymbolRenderer(cell: mechanic),
      ),
    );
  }
}
