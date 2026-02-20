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
  /// Note: This is a brute-force solver. Puzzles with many playable cells (>25)
  /// will take significant time to solve.
  List<GridState> solve(Puzzle puzzle) {
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
    _backtrack(grid, playablePoints, 0, solutions);
    return solutions;
  }

  void _backtrack(
    GridState current,
    List<GridPoint> points,
    int index,
    List<GridState> solutions,
  ) {
    if (index == points.length) {
      if (_validator.validate(current).isValid) {
        solutions.add(current);
      }
      return;
    }

    final pt = points[index];

    // Try both states for the current point
    _backtrack(current.setLit(pt, isLit: false), points, index + 1, solutions);
    _backtrack(current.setLit(pt, isLit: true), points, index + 1, solutions);
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
