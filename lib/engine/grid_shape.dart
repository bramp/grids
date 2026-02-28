import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:meta/meta.dart';

/// Represents a distinct shape on the grid, defined by relative offsets from
/// a reference point.
@immutable
class GridShape {
  const GridShape(this.offsets);

  /// The relative offsets from the reference point that define this shape.
  final Set<(int, int)> offsets;

  /// Returns a canonical string representation of this shape.
  /// Identical shapes will have identical signatures regardless of the
  /// order in which offsets were added.
  String get signature {
    final list = offsets.toList()
      ..sort((a, b) {
        if (a.$1 != b.$1) return a.$1.compareTo(b.$1);
        return a.$2.compareTo(b.$2);
      });
    return list.map((p) => '${p.$1},${p.$2}').join(';');
  }

  /// Returns all four 90-degree rotations of this shape.
  List<GridShape> get rotations {
    final result = <GridShape>[];
    var current = offsets;
    for (var i = 0; i < 4; i++) {
      result.add(GridShape(current));
      // Rotate 90 degrees clockwise: (x, y) -> (-y, x)
      current = current.map((p) => (-p.$2, p.$1)).toSet();
    }
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridShape &&
          runtimeType == other.runtimeType &&
          signature == other.signature;

  @override
  int get hashCode => signature.hashCode;
}

/// A contiguous area on the grid.
class GridArea {
  const GridArea(this.points);

  /// The set of absolute points that make up this area.
  final List<GridPoint> points;

  /// Converts this area into a [GridShape] relative to a reference point.
  GridShape toShape(GridPoint refPt, Puzzle puzzle) {
    final (refX, refY) = puzzle.xy(refPt);
    return GridShape(
      points.map((pt) {
        final (x, y) = puzzle.xy(pt);
        return (x - refX, y - refY);
      }).toSet(),
    );
  }

  /// Returns true if this area contains the given point.
  bool contains(GridPoint pt) => points.contains(pt);
}
