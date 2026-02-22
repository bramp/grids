import 'package:collection/collection.dart';
import 'package:grids/engine/area_extractor.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:meta/meta.dart';

/// Represents the immutable state of the puzzle grid using a bitset
/// for high performance.
@immutable
class GridState {
  /// Creates a completely blank grid of the specified dimensions.
  factory GridState.empty({required int width, required int height}) {
    return GridState._(
      width,
      height,
      List.filled(width * height, const BlankCell()),
      BigInt.zero,
    );
  }

  /// Internal constructor for high-performance initialization from raw bits.
  const GridState.fromRaw({
    required this.width,
    required this.height,
    required this.mechanics,
    required this.bits,
  });

  const GridState._(this.width, this.height, this.mechanics, this.bits);

  final int width;
  final int height;

  /// Mechanics for each cell. Stored in 1D: [y * width + x].
  final List<Cell> mechanics;

  /// A bitset representing the lit state of each cell.
  /// Bit position: y * width + x.
  final BigInt bits;

  /// Internal constructor for efficiency.
  GridState withBits(BigInt newBits) =>
      GridState._(width, height, mechanics, newBits);

  /// Returns a new GridState with the lit status of [pt] set to [isLit].
  GridState setLit(GridPoint pt, {required bool isLit}) {
    final mask = _getMask(pt);
    final currentLit = (bits & mask) != BigInt.zero;
    if (currentLit == isLit) return this;
    return GridState._(width, height, mechanics, bits ^ mask);
  }

  static final _bitMasks = List<BigInt>.generate(
    256, // Supports grids up to 16x16 or similar total cell counts
    (i) => BigInt.one << i,
    growable: false,
  );

  static BigInt _getMask(int index) {
    if (index < _bitMasks.length) return _bitMasks[index];
    return BigInt.one << index;
  }

  /// True if the grid cell at the given point is lit, false otherwise.
  bool isLit(GridPoint pt) => (bits & _getMask(pt)) != BigInt.zero;

  /// Returns the cell at the given point.
  Cell getMechanic(GridPoint pt) {
    if (pt < 0 || pt >= mechanics.length) return const BlankCell();
    return mechanics[pt];
  }

  /// Returns true if the cell at the given point is locked and cannot be
  /// toggled by the user.
  bool isLocked(GridPoint pt) {
    if (pt < 0 || pt >= mechanics.length) return false;
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

  /// Gets the X coordinate for a [GridPoint].
  int x(GridPoint pt) => pt % width;

  /// Gets the Y coordinate for a [GridPoint].
  int y(GridPoint pt) => pt ~/ width;

  /// Returns a new GridState with the given point toggled.
  /// If the cell is locked, returns the current state unchanged.
  GridState toggle(GridPoint pt) {
    if (isLocked(pt)) return this;
    return GridState._(width, height, mechanics, bits ^ _getMask(pt));
  }

  /// Helper method for tests/setup to place a cell immutably.
  GridState withMechanic(GridPoint pt, Cell cell) {
    final newMechanics = List<Cell>.from(mechanics);
    newMechanics[pt] = cell;
    return GridState._(width, height, newMechanics, bits);
  }

  static final _areaCache = Expando<List<List<GridPoint>>>();

  /// Returns all contiguous areas, where each area is a list of [GridPoint]
  /// indices.
  List<List<GridPoint>> extractContiguousAreas() {
    return _areaCache[this] ??= AreaExtractor.extract(this);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridState &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          bits == other.bits &&
          const ListEquality<Cell>().equals(mechanics, other.mechanics);

  @override
  int get hashCode =>
      width.hashCode ^
      height.hashCode ^
      bits.hashCode ^
      const ListEquality<Cell>().hash(mechanics);

  /// Returns a beautiful debug ASCII representation of the grid.
  String toAsciiString({bool useColor = false}) {
    return GridFormat.toAsciiString(this, useColor: useColor);
  }
}
