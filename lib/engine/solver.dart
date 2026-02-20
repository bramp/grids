import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/puzzle_validator.dart';

/// A simple brute-force backtracking solver for Grids puzzles.
class PuzzleSolver {
  PuzzleSolver({PuzzleValidator? validator})
    : _validator = validator ?? PuzzleValidator();

  final PuzzleValidator _validator;

  /// Returns all valid solutions for a given [puzzle].
  ///
  /// If [deduplicate] is true, solutions that differ only in areas containing
  /// no mechanic (e.g., isolated checkerboard islands of blanks) are considered
  /// identical and omitted.
  ///
  /// Note: This is a brute-force solver. Puzzles with many playable cells (>25)
  /// will take significant time to solve.
  List<GridState> solve(Puzzle puzzle, {bool deduplicate = true}) {
    final grid = puzzle.initialGrid;
    final playablePoints = <GridPoint>[];

    for (var y = 0; y < grid.height; y++) {
      for (var x = 0; x < grid.width; x++) {
        final pt = GridPoint(x, y);
        if (!grid.isLocked(pt)) {
          playablePoints.add(pt);
        }
      }
    }

    final solutions = <GridState>[];
    final seenSignatures = <String>{};
    _backtrack(grid, playablePoints, 0, solutions, seenSignatures, deduplicate);
    return solutions;
  }

  void _backtrack(
    GridState current,
    List<GridPoint> points,
    int index,
    List<GridState> solutions,
    Set<String> seenSignatures,
    bool deduplicate,
  ) {
    if (index == points.length) {
      if (_validator.validate(current).isValid) {
        if (!deduplicate) {
          solutions.add(current);
          return;
        }

        final signature = _getSignature(current);
        if (seenSignatures.add(signature)) {
          solutions.add(_normalize(current));
        }
      }
      return;
    }

    final pt = points[index];

    // Try both states for the current point
    _backtrack(
      current.setLit(pt, isLit: false),
      points,
      index + 1,
      solutions,
      seenSignatures,
      deduplicate,
    );
    _backtrack(
      current.setLit(pt, isLit: true),
      points,
      index + 1,
      solutions,
      seenSignatures,
      deduplicate,
    );
  }

  String _getSignature(GridState grid) {
    final areas = grid.extractContiguousAreas();
    final mechanicAreas = <String>[];

    for (final area in areas) {
      final hasMechanic = area.any((pt) => grid.getMechanic(pt) is! BlankCell);
      if (hasMechanic) {
        final sortedPts = area.toList()
          ..sort(
            (a, b) => a.x != b.x ? a.x.compareTo(b.x) : a.y.compareTo(b.y),
          );
        final litState = grid.isLit(sortedPts.first) ? '1' : '0';
        final pointsStr = sortedPts.map((p) => '${p.x},${p.y}').join('|');
        mechanicAreas.add('$litState:$pointsStr');
      }
    }

    mechanicAreas.sort();
    return mechanicAreas.join(';');
  }

  /// Returns a clean copy of the grid where unnecessary lit cells are turned
  /// off. It verifies that any change does not break validity or the core
  /// mechanic signature.
  GridState _normalize(GridState grid) {
    var normalized = grid;
    final originalSignature = _getSignature(grid);

    // Greedily try to unlight cells that aren't strictly necessary.
    for (var y = 0; y < grid.height; y++) {
      for (var x = 0; x < grid.width; x++) {
        final pt = GridPoint(x, y);
        if (normalized.isLit(pt)) {
          final testGrid = normalized.setLit(pt, isLit: false);
          if (_validator.validate(testGrid).isValid &&
              _getSignature(testGrid) == originalSignature) {
            normalized = testGrid;
          }
        }
      }
    }

    assert(
      _validator.validate(normalized).isValid,
      'Normalization broke grid validity!',
    );
    return normalized;
  }
}

extension on GridState {
  GridState setLit(GridPoint pt, {required bool isLit}) {
    if (this.isLit(pt) == isLit) return this;

    final newCells = List<List<CellState>>.generate(
      width,
      (x) => List<CellState>.from(cells[x]),
    );
    newCells[pt.x][pt.y] = cells[pt.x][pt.y].copyWith(isLit: isLit);
    return GridState.fromCells(newCells);
  }
}
