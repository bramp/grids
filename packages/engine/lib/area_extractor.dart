import 'dart:typed_data';
import 'package:grids_engine/cell.dart';
import 'package:grids_engine/grid_point.dart';
import 'package:grids_engine/puzzle.dart';

/// Utility class to extract contiguous areas of like-lit cells.
class AreaExtractor {
  /// Identifies all contiguous areas where cells share the same lit/unlit state.
  static List<List<GridPoint>> extract(Puzzle puzzle) {
    final width = puzzle.width;
    final height = puzzle.height;
    final size = width * height;

    final visited = Uint8List(size);
    final queue = Int32List(size);

    final areas = <List<GridPoint>>[];

    for (var i = 0; i < size; i++) {
      if (visited[i] == 1 || puzzle.getCell(GridPoint(i)) is VoidCell) {
        continue;
      }

      final targetLitState = puzzle.isLit(GridPoint(i));
      final currentArea = <GridPoint>[];

      var head = 0;
      var tail = 0;
      queue[tail++] = i;
      visited[i] = 1;

      while (head < tail) {
        final indexValue = queue[head++];
        final pt = GridPoint(indexValue);
        currentArea.add(pt);

        final cx = pt % width;
        final cy = pt ~/ width;

        // Check neighbors
        if (cy > 0) {
          final ni = indexValue - width;
          if (visited[ni] == 0 &&
              puzzle.getCell(GridPoint(ni)) is! VoidCell &&
              puzzle.isLit(GridPoint(ni)) == targetLitState) {
            visited[ni] = 1;
            queue[tail++] = ni;
          }
        }
        if (cy < height - 1) {
          final ni = indexValue + width;
          if (visited[ni] == 0 &&
              puzzle.getCell(GridPoint(ni)) is! VoidCell &&
              puzzle.isLit(GridPoint(ni)) == targetLitState) {
            visited[ni] = 1;
            queue[tail++] = ni;
          }
        }
        if (cx > 0) {
          final ni = indexValue - 1;
          if (visited[ni] == 0 &&
              puzzle.getCell(GridPoint(ni)) is! VoidCell &&
              puzzle.isLit(GridPoint(ni)) == targetLitState) {
            visited[ni] = 1;
            queue[tail++] = ni;
          }
        }
        if (cx < width - 1) {
          final ni = indexValue + 1;
          if (visited[ni] == 0 &&
              puzzle.getCell(GridPoint(ni)) is! VoidCell &&
              puzzle.isLit(GridPoint(ni)) == targetLitState) {
            visited[ni] = 1;
            queue[tail++] = ni;
          }
        }
      }
      areas.add(currentArea);
    }
    return areas;
  }
}
