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

    // We use a LayoutBuilder to ensure the grid cells remain perfectly square
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        final gridAspectRatio = width / height;
        final containerAspectRatio = maxWidth / maxHeight;

        var finalWidth = maxWidth;
        var finalHeight = maxHeight;

        if (containerAspectRatio > gridAspectRatio) {
          // Constrained by height
          finalWidth = maxHeight * gridAspectRatio;
        } else {
          // Constrained by width
          finalHeight = maxWidth / gridAspectRatio;
        }

        return Center(
          child: SizedBox(
            width: finalWidth,
            height: finalHeight,
            // Container adds the outer stroke of the entire game grid
            child: Listener(
              onPointerDown: (details) => _handleDrag(
                context,
                details.localPosition,
                finalWidth,
                finalHeight,
                width,
                height,
              ),
              onPointerMove: (details) => _handleDrag(
                context,
                details.localPosition,
                finalWidth,
                finalHeight,
                width,
                height,
              ),
              onPointerUp: (_) => context.read<LevelProvider>().endDrag(),
              onPointerCancel: (_) => context.read<LevelProvider>().endDrag(),
              behavior: HitTestBehavior.opaque,
              child: Container(
                key: ValueKey(puzzleId),
                padding: theme.gridPadding,
                decoration:
                    theme.gridBackgroundDecoration ??
                    BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
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
            ),
          ),
        );
      },
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
      provider.dragToggleCell(point);
    }
  }
}
