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
  List<Puzzle> solve(Puzzle puzzle, {bool deduplicate = true}) {
    // Optimize validation by only using rules relevant to this specific puzzle.
    final optimizedValidator = _validator.filter(puzzle);

    final playableIndices = <GridPoint>[];

    for (var i = 0; i < puzzle.mechanics.length; i++) {
      final pt = GridPoint(i);
      if (!puzzle.isLocked(pt)) {
        playableIndices.add(pt);
      }
    }

    final solutions = <Puzzle>[];
    final seenSignatures = <String>{};

    final bitMasks = playableIndices.map((pt) => BigInt.one << pt).toList();

    _backtrack(
      puzzle,
      bitMasks,
      0,
      puzzle.bits,
      solutions,
      seenSignatures,
      deduplicate,
      optimizedValidator,
    );

    return solutions;
  }

  void _backtrack(
    Puzzle basePuzzle,
    List<BigInt> bitMasks,
    int index,
    BigInt currentBits,
    List<Puzzle> solutions,
    Set<String> seenSignatures,
    bool deduplicate,
    PuzzleValidator validator,
  ) {
    if (index == bitMasks.length) {
      final current = basePuzzle.copyWith(
        state: GridState(
          width: basePuzzle.width,
          height: basePuzzle.height,
          bits: currentBits,
        ),
      );
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
      basePuzzle,
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
      basePuzzle,
      bitMasks,
      index + 1,
      currentBits | bit,
      solutions,
      seenSignatures,
      deduplicate,
      validator,
    );
  }

  String _getSignature(Puzzle puzzle) {
    final areas = puzzle.extractContiguousAreas();
    final mechanicAreas = <String>[];

    for (final area in areas) {
      final hasMechanic = area.any(
        (pt) => puzzle.getMechanic(pt) is! BlankCell,
      );
      if (hasMechanic) {
        final sortedPts = area.toList()..sort();
        final litState = puzzle.isLit(sortedPts.first) ? '1' : '0';
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
  Puzzle _normalize(Puzzle puzzle, PuzzleValidator validator) {
    var normalized = puzzle;
    final originalSignature = _getSignature(puzzle);

    final size = puzzle.mechanics.length;
    for (var i = 0; i < size; i++) {
      final pt = GridPoint(i);

      // Do not attempt to toggle locked cells, even if it leaves the
      // grid valid.
      // Locked cells must retain their initial state.
      if (puzzle.isLocked(pt)) {
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
