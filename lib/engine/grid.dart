import 'package:collection/collection.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:meta/meta.dart';

/// Represents the static structure of a puzzle grid.
@immutable
class Grid {
  const Grid({
    required this.width,
    required this.height,
    required this.mechanics,
  }) : assert(
         mechanics.length == width * height,
         'Grid: mechanics length must match width * height',
       );

  /// Creates a completely blank grid of the specified dimensions.
  factory Grid.empty({required int width, required int height}) {
    return Grid(
      width: width,
      height: height,
      mechanics: List.filled(width * height, const BlankCell()),
    );
  }

  final int width;
  final int height;

  /// Mechanics for each cell. Stored in 1D: [y * width + x].
  final List<Cell> mechanics;

  /// Returns the cell at the given point.

  Cell getCell(GridPoint pt) {
    if (!isValid(pt)) return const VoidCell();
    return mechanics[pt];
  }

  /// Returns true if the cell at the given point is locked and cannot be
  /// toggled by the user.
  bool isLocked(GridPoint pt) {
    if (!isValid(pt)) return false;
    return mechanics[pt].isLocked;
  }

  /// Checks if the provided coordinates are strictly within the bounds.
  bool isValidXY(int x, int y) {
    return x >= 0 && x < width && y >= 0 && y < height;
  }

  /// Checks if the provided point (index) is within the grid bounds.
  bool isValid(GridPoint pt) => pt >= 0 && pt < mechanics.length;

  /// Returns a [GridPoint] (index) for the given coordinates.
  GridPoint pointAt(int x, int y) => GridPoint(y * width + x);

  /// Gets the (x, y) coordinates for a [GridPoint].
  (int, int) xy(GridPoint pt) => (pt % width, pt ~/ width);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Grid &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          const ListEquality<Cell>().equals(mechanics, other.mechanics);

  @override
  int get hashCode =>
      width.hashCode ^
      height.hashCode ^
      const ListEquality<Cell>().hash(mechanics);
}
