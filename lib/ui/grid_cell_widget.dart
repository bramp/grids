import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/providers/puzzle_provider.dart';
import 'package:grids/providers/theme_provider.dart';
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

    final theme = context.watch<ThemeProvider>().activeTheme;

    Widget mechanicWidget = const SizedBox.shrink();
    if (mechanic is NumberCell) {
      mechanicWidget = theme.buildNumberMechanic(context, mechanic);
    } else if (mechanic is DiamondCell) {
      mechanicWidget = theme.buildDiamondMechanic(context, mechanic);
    } else if (mechanic is FlowerCell) {
      mechanicWidget = theme.buildFlowerMechanic(context, mechanic);
    } else if (mechanic is DashCell) {
      mechanicWidget = theme.buildDashMechanic(context, mechanic);
    } else if (mechanic is DiagonalDashCell) {
      mechanicWidget = theme.buildDiagonalDashMechanic(context, mechanic);
    }

    final paddedCell = Padding(
      padding: EdgeInsets.all(theme.cellPadding),
      child: theme.buildCellBackground(
        context,
        mechanic: mechanic,
        isLocked: isLocked,
        isLit: isLit,
        hasError: hasError,
        child: Center(child: mechanicWidget),
      ),
    );

    return paddedCell;
  }
}
