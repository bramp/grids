import 'package:grids_engine/cell.dart';
import 'package:grids_engine/grid_point.dart';
import 'package:grids_engine/grid_state.dart';
import 'package:grids_engine/puzzle.dart';
import 'package:grids_engine/puzzle_validator.dart';

/// The result of running a [LogicalSolver].
class LogicalSolveResult {
  const LogicalSolveResult(
    this.solutions, {
    this.errorHistogram = const {},
    this.deadEnds = 0,
    this.logicMoves = 0,
    this.guessMoves = 0,
    this.constraintDensity = 0.0,
  });

  final List<Puzzle> solutions;
  final Map<int, int> errorHistogram;

  final int deadEnds;
  final int logicMoves;
  final int guessMoves;
  final double constraintDensity;

  double get logicVsGuessingRatio => (logicMoves + guessMoves) == 0
      ? 1.0
      : logicMoves / (logicMoves + guessMoves);

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

/// Shared mutable state for a single [LogicalSolver.solve] invocation.
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

  int deadEnds = 0;
  int logicMoves = 0;
  int guessMoves = 0;
}

/// A simple brute-force backtracking solver for Grids puzzles.
class LogicalSolver {
  LogicalSolver({PuzzleValidator? validator})
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
  LogicalSolveResult solve(
    Puzzle puzzle, {
    bool deduplicate = true,
    bool analyze = false,
  }) {
    // Optimize validation by only using rules relevant to this specific puzzle.
    final optimizedValidator = _validator.filter(puzzle);

    final playableIndices = <GridPoint>[];
    var mechanicCount = 0;
    var initialKnownBits = BigInt.zero;

    for (var i = 0; i < puzzle.mechanics.length; i++) {
      final pt = GridPoint(i);
      final cell = puzzle.getCell(pt);

      if (cell is! BlankCell) {
        mechanicCount++;
      }

      if (!puzzle.isLocked(pt)) {
        playableIndices.add(pt);
      } else {
        initialKnownBits |= BigInt.one << i;
      }
    }

    final constraintDensity = mechanicCount / puzzle.mechanics.length;

    final ctx = _SolveContext(
      basePuzzle: puzzle,
      bitMasks: playableIndices.map((pt) => BigInt.one << pt).toList(),
      deduplicate: deduplicate,
      analyze: analyze,
      validator: optimizedValidator,
    );

    _branch(ctx, initialKnownBits, puzzle.bits);

    return LogicalSolveResult(
      ctx.solutions,
      errorHistogram: ctx.errorHistogram,
      deadEnds: ctx.deadEnds,
      logicMoves: ctx.logicMoves,
      guessMoves: ctx.guessMoves,
      constraintDensity: constraintDensity,
    );
  }

  Iterable<int> _getNeighbors(Puzzle puzzle, int index) sync* {
    final w = puzzle.width;
    final h = puzzle.height;
    final cx = index % w;
    final cy = index ~/ w;

    if (cy > 0) yield index - w;
    if (cy < h - 1) yield index + w;
    if (cx > 0) yield index - 1;
    if (cx < w - 1) yield index + 1;
  }

  void _branch(
    _SolveContext ctx,
    BigInt initialKnownBits,
    BigInt initialStateBits,
  ) {
    var knownBits = initialKnownBits;
    var stateBits = initialStateBits;
    bool changed;
    var isValid = true;
    final puzzle = ctx.basePuzzle;
    final totalCells = puzzle.mechanics.length;

    // --- 1. Deductive Logic Loop ---
    do {
      changed = false;

      for (var i = 0; i < totalCells; i++) {
        final cell = puzzle.getCell(GridPoint(i));

        // Deduction Rule: StrictNumber(1)
        // If a cell is a '1' and we know its state,
        // all neighbors must be the opposite state!
        if (cell is NumberCell && cell.number == 1) {
          final mask = BigInt.one << i;
          final isKnown = (knownBits & mask) != BigInt.zero;

          if (isKnown) {
            final isOn = (stateBits & mask) != BigInt.zero;

            for (final neighbor in _getNeighbors(puzzle, i)) {
              final nMask = BigInt.one << neighbor;
              final nIsKnown = (knownBits & nMask) != BigInt.zero;
              final nIsOn = (stateBits & nMask) != BigInt.zero;

              if (!nIsKnown) {
                // Deduce state! MUST be opposite
                knownBits |= nMask;
                if (!isOn) {
                  stateBits |= nMask; // Turn it ON
                } else {
                  stateBits &= ~nMask; // Turn it OFF
                }
                ctx.logicMoves++;
                changed = true;
              } else if (nIsOn == isOn) {
                // Contradiction detected!
                isValid = false;
                break;
              }
            }
          }
        }
        if (!isValid) break;
      }
    } while (changed && isValid);

    if (!isValid) {
      ctx.deadEnds++;
      return;
    }

    // --- 2. Check Completeness / Gather branches ---
    var guessIndex = -1;

    // We iterate over the bitMasks (which represent playable cells).
    // Find the first playable cell whose state is NOT known yet.
    for (var i = 0; i < ctx.bitMasks.length; i++) {
      final mask = ctx.bitMasks[i];
      if ((knownBits & mask) == BigInt.zero) {
        // Find the actual grid index of this mask snippet
        for (var j = 0; j < totalCells; j++) {
          if ((BigInt.one << j) == mask) {
            guessIndex = j;
            break;
          }
        }
        break;
      }
    }

    if (guessIndex == -1) {
      // Board is fully populated! Send it to the massive validator payload.
      final current = ctx.basePuzzle.copyWith(
        state: GridState(
          width: ctx.basePuzzle.width,
          height: ctx.basePuzzle.height,
          bits: stateBits,
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
      } else {
        ctx.deadEnds++;
      }
      return;
    }

    // --- 3. Branch / Guess ---
    ctx.guessMoves++;
    final guessMask = BigInt.one << guessIndex;

    // Try bit off
    _branch(ctx, knownBits | guessMask, stateBits & ~guessMask);

    // Try bit on
    _branch(ctx, knownBits | guessMask, stateBits | guessMask);
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
