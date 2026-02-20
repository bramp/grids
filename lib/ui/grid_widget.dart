import 'package:flutter/material.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/providers/puzzle_provider.dart';
import 'package:grids/ui/grid_cell_widget.dart';
import 'package:provider/provider.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Read dimensions from the provider, listening for changes
    final width = context.select<PuzzleProvider, int>((p) => p.grid.width);
    final height = context.select<PuzzleProvider, int>((p) => p.grid.height);

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
            child: GestureDetector(
              onPanStart: (details) => _handleDrag(
                context,
                details.localPosition,
                finalWidth,
                finalHeight,
                width,
                height,
              ),
              onPanUpdate: (details) => _handleDrag(
                context,
                details.localPosition,
                finalWidth,
                finalHeight,
                width,
                height,
              ),
              onPanEnd: (_) => context.read<PuzzleProvider>().endDrag(),
              behavior: HitTestBehavior.opaque,
              child: Container(
                decoration: BoxDecoration(
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
                              child: GridCellWidget(point: GridPoint(x, y)),
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

    final point = GridPoint(x, y);
    final provider = context.read<PuzzleProvider>();

    if (provider.grid.isValid(point)) {
      provider.dragToggleCell(point);
    }
  }
}
