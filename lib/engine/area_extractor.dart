import 'dart:typed_data';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';

/// Utility class to extract contiguous areas of like-lit cells.
class AreaExtractor {
  static Uint8List _visitedBuffer = Uint8List(0);
  static Int32List _queueBuffer = Int32List(0);

  /// Identifies all contiguous areas where cells share the same lit/unlit state.
  static List<List<GridPoint>> extract(GridState grid) {
    final width = grid.width;
    final height = grid.height;
    final size = width * height;

    if (_visitedBuffer.length < size) {
      _visitedBuffer = Uint8List(size);
      _queueBuffer = Int32List(size);
    }

    final visited = _visitedBuffer;
    final queue = _queueBuffer;

    for (var i = 0; i < size; i++) {
      visited[i] = 0;
    }

    final areas = <List<GridPoint>>[];

    for (var i = 0; i < size; i++) {
      if (visited[i] == 1) continue;

      final targetLitState = grid.isLit(GridPoint(i));
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
          if (visited[ni] == 0 && grid.isLit(GridPoint(ni)) == targetLitState) {
            visited[ni] = 1;
            queue[tail++] = ni;
          }
        }
        if (cy < height - 1) {
          final ni = indexValue + width;
          if (visited[ni] == 0 && grid.isLit(GridPoint(ni)) == targetLitState) {
            visited[ni] = 1;
            queue[tail++] = ni;
          }
        }
        if (cx > 0) {
          final ni = indexValue - 1;
          if (visited[ni] == 0 && grid.isLit(GridPoint(ni)) == targetLitState) {
            visited[ni] = 1;
            queue[tail++] = ni;
          }
        }
        if (cx < width - 1) {
          final ni = indexValue + 1;
          if (visited[ni] == 0 && grid.isLit(GridPoint(ni)) == targetLitState) {
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
