import 'package:flutter/material.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:grids/ui/grid_cell_widget.dart';
import 'package:provider/provider.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Read dimensions from the provider, listening for changes
    // TODO(bramp): Should we be selecting on both width and height?
    final width = context.select<LevelProvider, int>((p) => p.puzzle.width);
    final height = context.select<LevelProvider, int>((p) => p.puzzle.height);
    final theme = context.watch<ThemeProvider>().activeTheme;
    final puzzleId = context.select<LevelProvider, String>(
      (p) => p.currentLevel.id,
    );
    final isSolved = context.select<LevelProvider, bool>((p) => p.isSolved);

    return Center(
      child: theme.buildGridBackground(
        context,
        isSolved: isSolved,
        child: AspectRatio(
          aspectRatio: width / height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Listener(
                onPointerDown: (details) => _handleDrag(
                  context,
                  details.localPosition,
                  constraints.maxWidth,
                  constraints.maxHeight,
                  width,
                  height,
                ),
                onPointerMove: (details) => _handleDrag(
                  context,
                  details.localPosition,
                  constraints.maxWidth,
                  constraints.maxHeight,
                  width,
                  height,
                ),
                onPointerUp: (_) => context.read<LevelProvider>().endDrag(),
                onPointerCancel: (_) => context.read<LevelProvider>().endDrag(),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  key: ValueKey(puzzleId),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Column(
                      children: List.generate(
                        height,
                        (y) => Expanded(
                          child: Row(
                            children: List.generate(
                              width,
                              (x) => Expanded(
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
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleDrag(
    BuildContext context,
    Offset localPosition,
    double finalWidth,
    double finalHeight,
    int gridWidth,
    int gridHeight,
  ) {
    // Determine which cell we are currently hovering over
    final cellWidth = finalWidth / gridWidth;
    final cellHeight = finalHeight / gridHeight;

    final x = (localPosition.dx / cellWidth).floor();
    final y = (localPosition.dy / cellHeight).floor();

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
