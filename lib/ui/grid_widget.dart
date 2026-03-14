import 'package:flutter/material.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:grids/ui/grid_cell_widget.dart';
import 'package:provider/provider.dart';

/// Reference size in logical pixels for a single grid cell.
///
/// The entire puzzle is rendered at this fixed scale, then a [FittedBox]
/// scales it to fit the available space. This keeps padding, borders,
/// and decorations proportional regardless of grid dimensions.
///
/// Note: 1px hairline borders may appear slightly soft after scaling since
/// they no longer land on exact device-pixel boundaries. If a pixel-perfect
/// focus ring is ever needed, draw it *outside* the [FittedBox].
const double _referenceCellSize = 100;

class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Read dimensions from the provider, listening for changes
    final width = context.select<LevelProvider, int>((p) => p.puzzle.width);
    final height = context.select<LevelProvider, int>((p) => p.puzzle.height);
    final theme = context.watch<ThemeProvider>().activeTheme;
    final puzzleId = context.select<LevelProvider, String>(
      (p) => p.currentLevel.id,
    );
    final isSolved = context.select<LevelProvider, bool>((p) => p.isSolved);

    return FittedBox(
      child: theme.buildGridBackground(
        context,
        isSolved: isSolved,
        child: SizedBox(
          width: width * _referenceCellSize,
          height: height * _referenceCellSize,
          child: Listener(
            onPointerDown: (details) => _handleDrag(
              context,
              details.localPosition,
              width,
              height,
            ),
            onPointerMove: (details) => _handleDrag(
              context,
              details.localPosition,
              width,
              height,
            ),
            onPointerUp: (_) => context.read<LevelProvider>().endDrag(),
            onPointerCancel: (_) => context.read<LevelProvider>().endDrag(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              key: ValueKey(puzzleId),
              child: Column(
                children: List.generate(
                  height,
                  (y) => SizedBox(
                    height: _referenceCellSize,
                    child: Row(
                      children: List.generate(
                        width,
                        (x) => SizedBox(
                          width: _referenceCellSize,
                          height: _referenceCellSize,
                          child: GridCellWidget(
                            point: GridPoint(y * width + x),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDrag(
    BuildContext context,
    Offset localPosition,
    int gridWidth,
    int gridHeight,
  ) {
    final x = (localPosition.dx / _referenceCellSize).floor();
    final y = (localPosition.dy / _referenceCellSize).floor();

    // Ignore pointer events outside the grid bounds (e.g. dragging past
    // the last column would otherwise wrap to the first cell of the next row).
    if (x < 0 || x >= gridWidth || y < 0 || y >= gridHeight) {
      context.read<LevelProvider>().setHoveredDragPoint(null);
      return;
    }

    final point = GridPoint(y * gridWidth + x);
    final provider = context.read<LevelProvider>();

    if (provider.puzzle.isValid(point)) {
      provider
        ..setHoveredDragPoint(point)
        ..dragToggleCell(point);
    } else {
      provider.setHoveredDragPoint(null);
    }
  }
}
