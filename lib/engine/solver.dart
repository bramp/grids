import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/puzzle_validator.dart';

/// The result of running a [PuzzleSolver].
class SolveResult {
  const SolveResult(this.solutions, {this.errorHistogram = const {}});

  final List<Puzzle> solutions;
  final Map<int, int> errorHistogram;

  /// Returns the total number of states evaluated.
  int get totalStatesEvaluated =>
      errorHistogram.values.fold(0, (a, b) => a + b);

  /// Returns the average number of erroneous cells across all evaluated states.
  double get averageErrors {
    final total = totalStatesEvaluated;
    if (total == 0) return 0;
    var sum = 0;
    for (final e in errorHistogram.entries) {
      sum += e.key * e.value;
    }
    return sum / total;
  }

  /// Returns the median (50th percentile) number of erroneous cells.
  double get medianErrors => percentileErrors(0.5);

  /// Returns the given percentile (0.0 to 1.0) for the number of erroneous
  /// cells.
  double percentileErrors(double percentile) {
    if (errorHistogram.isEmpty) return 0;
    final sortedCounts = <int>[];
    for (final e in errorHistogram.entries) {
      for (var i = 0; i < e.value; i++) {
        sortedCounts.add(e.key);
      }
    }
    sortedCounts.sort();
    final index = (sortedCounts.length * percentile).floor().clamp(
      0,
      sortedCounts.length - 1,
    );
    return sortedCounts[index].toDouble();
  }
}

/// Shared mutable state for a single [PuzzleSolver.solve] invocation.
class _SolveContext {
  _SolveContext({
    required this.basePuzzle,
    required this.bitMasks,
    required this.deduplicate,
    required this.analyze,
    required this.validator,
  });

  final Puzzle basePuzzle;
  final List<BigInt> bitMasks;
  final bool deduplicate;
  final bool analyze;
  final PuzzleValidator validator;

  final List<Puzzle> solutions = [];
  final Set<String> seenSignatures = {};
  final Map<int, int> errorHistogram = {};
}

/// A simple brute-force backtracking solver for Grids puzzles.
class PuzzleSolver {
  PuzzleSolver({PuzzleValidator? validator})
    : _validator = validator ?? PuzzleValidator();

  // TODO(bramp): Based on the puzzle, we can enable/disable validators.
  final PuzzleValidator _validator;

  /// Returns all valid solutions and an analysis histogram for a given
  /// [puzzle].
  ///
  /// If [deduplicate] is true, solutions that differ only in areas containing
  /// no mechanic (e.g., isolated checkerboard islands of blanks) are considered
  /// identical and omitted.
  ///
  /// If [analyze] is true, it evaluates all possible states and constructs a
  /// histogram of how many unique cells are explicitly erroneous.
  ///
  /// Note: This is a brute-force solver. Puzzles with many playable cells (>25)
  /// will take significant time to solve.
  SolveResult solve(
    Puzzle puzzle, {
    bool deduplicate = true,
    bool analyze = false,
  }) {
    // Optimize validation by only using rules relevant to this specific puzzle.
    final optimizedValidator = _validator.filter(puzzle);

    final playableIndices = <GridPoint>[];

    for (var i = 0; i < puzzle.mechanics.length; i++) {
      final pt = GridPoint(i);
      if (!puzzle.isLocked(pt)) {
        playableIndices.add(pt);
      }
    }

    final ctx = _SolveContext(
      basePuzzle: puzzle,
      bitMasks: playableIndices.map((pt) => BigInt.one << pt).toList(),
      deduplicate: deduplicate,
      analyze: analyze,
      validator: optimizedValidator,
    );

    _backtrack(ctx, 0, puzzle.bits);

    return SolveResult(ctx.solutions, errorHistogram: ctx.errorHistogram);
  }

  void _backtrack(_SolveContext ctx, int index, BigInt currentBits) {
    if (index == ctx.bitMasks.length) {
      final current = ctx.basePuzzle.copyWith(
        state: GridState(
          width: ctx.basePuzzle.width,
          height: ctx.basePuzzle.height,
          bits: currentBits,
        ),
      );
      final result = ctx.validator.validate(current);
      if (ctx.analyze) {
        final uniqueErrorCells = result.errors
            .map((e) => e.point)
            .toSet()
            .length;
        ctx.errorHistogram[uniqueErrorCells] =
            (ctx.errorHistogram[uniqueErrorCells] ?? 0) + 1;
      }
      if (result.isValid) {
        if (!ctx.deduplicate) {
          ctx.solutions.add(current);
          return;
        }

        final signature = _getSignature(current);
        if (ctx.seenSignatures.add(signature)) {
          ctx.solutions.add(_normalize(current, ctx.validator));
        }
      }
      return;
    }

    final bit = ctx.bitMasks[index];

    // Try bit off
    _backtrack(ctx, index + 1, currentBits & ~bit);

    // Try bit on
    _backtrack(ctx, index + 1, currentBits | bit);
  }

  String _getSignature(Puzzle puzzle) {
    final areas = puzzle.extractContiguousAreas();
    final mechanicAreas = <String>[];

    for (final area in areas) {
      final hasMechanic = area.any(
        (pt) => puzzle.getCell(pt) is! BlankCell,
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
