import 'package:grids/engine/area_extractor.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:meta/meta.dart';

/// Represents a specific playable board state (grid structure + active state).
@immutable
class Puzzle {
  /// Constructor for a puzzle composed of a grid and its state.
  const Puzzle({
    required this.grid,
    required this.state,
  });

  /// Factory for a completely empty puzzle, used mainly for testing.
  factory Puzzle.empty({required int width, required int height}) {
    return Puzzle(
      grid: Grid.empty(width: width, height: height),
      state: GridState(width: width, height: height, bits: BigInt.zero),
    );
  }

  /// The static structural layout of the puzzle.
  final Grid grid;

  /// The transient mutable state (which cells are lit).
  final GridState state;

  // Forwarders for convenience
  int get width => grid.width;
  int get height => grid.height;
  List<Cell> get mechanics => grid.mechanics;
  Cell getCell(GridPoint pt) => grid.getCell(pt);
  bool isLocked(GridPoint pt) => grid.isLocked(pt);
  bool isValidXY(int x, int y) => grid.isValidXY(x, y);
  bool isValid(GridPoint pt) => grid.isValid(pt);
  GridPoint pointAt(int x, int y) => grid.pointAt(x, y);
  (int, int) xy(GridPoint pt) => grid.xy(pt);

  /// Helper method for tests/setup to place a cell immutably.
  /// This actually modifies the underlying structural [Grid], so use
  /// cautiously in a gameplay setting to avoid structurally mutating puzzles!
  @visibleForTesting
  Puzzle withMechanic(GridPoint pt, Cell cell) {
    final newMechanics = List<Cell>.from(grid.mechanics);
    newMechanics[pt] = cell;
    return copyWith(
      grid: Grid(width: width, height: height, mechanics: newMechanics),
    );
  }

  bool isLit(GridPoint pt) => state.isLit(pt);
  BigInt get bits => state.bits;

  Puzzle setLit(GridPoint pt, {required bool isLit}) {
    if (isLocked(pt)) return this;
    return Puzzle(
      grid: grid,
      state: state.setLit(pt, isLit: isLit),
    );
  }

  Puzzle toggle(GridPoint pt) {
    if (isLocked(pt)) return this;
    return Puzzle(
      grid: grid,
      state: state.toggle(pt),
    );
  }

  Puzzle copyWith({
    Grid? grid,
    GridState? state,
  }) {
    return Puzzle(
      grid: grid ?? this.grid,
      state: state ?? this.state,
    );
  }

  static final _areaCache = Expando<List<List<GridPoint>>>();

  List<List<GridPoint>> extractContiguousAreas() {
    return _areaCache[this] ??= AreaExtractor.extract(this);
  }

  String toAsciiString({bool useColor = false}) {
    return GridFormat.toAsciiString(this, useColor: useColor);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Puzzle &&
          runtimeType == other.runtimeType &&
          grid == other.grid &&
          state == other.state;

  @override
  int get hashCode => grid.hashCode ^ state.hashCode;
}
