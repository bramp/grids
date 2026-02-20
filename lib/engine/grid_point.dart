import 'package:meta/meta.dart';

/// Represents a distinct coordinate on the puzzle grid.
@immutable
class GridPoint {
  const GridPoint(this.x, this.y);
  final int x;
  final int y;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridPoint &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => '($x, $y)';
}
