import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/puzzle_validator.dart';

/// A simple brute-force backtracking solver for Grids puzzles.
class PuzzleSolver {
  PuzzleSolver({PuzzleValidator? validator})
    : _validator = validator ?? PuzzleValidator();

  // TODO(bramp): Based on the puzzle, we can enable/disable validators.
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

    // Optimize validation by only using rules relevant to this specific puzzle.
    final optimizedValidator = _validator.filter(grid);

    final playableIndices = <GridPoint>[];

    for (var i = 0; i < grid.mechanics.length; i++) {
      final pt = GridPoint(i);
      if (!grid.isLocked(pt)) {
        playableIndices.add(pt);
      }
    }

    final solutions = <GridState>[];
    final seenSignatures = <String>{};

    final bitMasks = playableIndices.map((pt) => BigInt.one << pt).toList();

    _backtrack(
      grid,
      bitMasks,
      0,
      grid.bits,
      solutions,
      seenSignatures,
      deduplicate,
      optimizedValidator,
    );

    return solutions;
  }

  void _backtrack(
    GridState initialGrid,
    List<BigInt> bitMasks,
    int index,
    BigInt currentBits,
    List<GridState> solutions,
    Set<String> seenSignatures,
    bool deduplicate,
    PuzzleValidator validator,
  ) {
    if (index == bitMasks.length) {
      final current = initialGrid.withBits(currentBits);
      if (validator.validate(current).isValid) {
        if (!deduplicate) {
          solutions.add(current);
          return;
        }

        final signature = _getSignature(current);
        if (seenSignatures.add(signature)) {
          solutions.add(_normalize(current, validator));
        }
      }
      return;
    }

    final bit = bitMasks[index];

    // Try bit off
    _backtrack(
      initialGrid,
      bitMasks,
      index + 1,
      currentBits & ~bit,
      solutions,
      seenSignatures,
      deduplicate,
      validator,
    );

    // Try bit on
    _backtrack(
      initialGrid,
      bitMasks,
      index + 1,
      currentBits | bit,
      solutions,
      seenSignatures,
      deduplicate,
      validator,
    );
  }

  String _getSignature(GridState grid) {
    final areas = grid.extractContiguousAreas();
    final mechanicAreas = <String>[];

    for (final area in areas) {
      final hasMechanic = area.any((pt) => grid.getMechanic(pt) is! BlankCell);
      if (hasMechanic) {
        final sortedPts = area.toList()..sort();
        final litState = grid.isLit(sortedPts.first) ? '1' : '0';
        final pointsStr = sortedPts.join('|');
        mechanicAreas.add('$litState:$pointsStr');
      }
    }

    mechanicAreas.sort();
    return mechanicAreas.join(';');
  }

  /// Returns a clean copy of the grid where unnecessary lit cells are turned
  /// off. It verifies that any change does not break validity or the core
  /// mechanic signature.
  GridState _normalize(GridState grid, PuzzleValidator validator) {
    var normalized = grid;
    final originalSignature = _getSignature(grid);

    final size = grid.mechanics.length;
    for (var i = 0; i < size; i++) {
      final pt = GridPoint(i);

      // Do not attempt to toggle locked cells, even if it leaves the
      // grid valid.
      // Locked cells must retain their initial state.
      if (grid.isLocked(pt)) {
        continue;
      }

      if (normalized.isLit(pt)) {
        final testGrid = normalized.setLit(pt, isLit: false);
        if (validator.validate(testGrid).isValid &&
            _getSignature(testGrid) == originalSignature) {
          normalized = testGrid;
        }
      }
    }

    assert(
      validator.validate(normalized).isValid,
      'Normalization broke grid validity!',
    );
    return normalized;
  }
}
