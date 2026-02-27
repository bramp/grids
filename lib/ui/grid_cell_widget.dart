import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class GridCellWidget extends StatelessWidget {
  const GridCellWidget({required this.point, super.key});
  final GridPoint point;

  @override
  Widget build(BuildContext context) {
    // Only rebuild this specific widget if its own lit state or error state
    // changes
    final isLit = context.select<LevelProvider, bool>(
      (p) => p.puzzle.isLit(point),
    );
    final hasError = context.select<LevelProvider, bool>(
      (p) => p.validation?.errors.any((e) => e.point == point) ?? false,
    );
    final mechanic = context.select<LevelProvider, Cell>(
      (p) => p.puzzle.getCell(point),
    );
    final isLocked = context.select<LevelProvider, bool>(
      (p) => p.puzzle.isLocked(point),
    );

    final theme = context.watch<ThemeProvider>().activeTheme;

    final mechanicWidget = switch (mechanic) {
      NumberCell() => theme.buildNumberMechanic(context, mechanic),
      DiamondCell() => theme.buildDiamondMechanic(context, mechanic),
      FlowerCell() => theme.buildFlowerMechanic(context, mechanic),
      DashCell() => theme.buildDashMechanic(context, mechanic),
      DiagonalDashCell() => theme.buildDiagonalDashMechanic(context, mechanic),
      BlankCell() => const SizedBox.shrink(),
      VoidCell() => const SizedBox.shrink(),
    };

    if (mechanic is VoidCell) {
      return mechanicWidget;
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
