// Command line tools need to print to the standard outputs.
// ignore_for_file: avoid_print
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:grids_engine/grid_format.dart';
import 'package:grids_engine/level.dart';
import 'package:grids_engine/puzzle.dart';
import 'package:grids_tools/solver/duration_format.dart';
import 'package:grids_tools/solver/logical_solver.dart';
import 'package:grids_tools/solver/puzzle_metrics.dart';
import 'package:grids_tools/solver/solver.dart';

abstract class SolveReporter {
  void reportUsage();

  void beginSingleSolve(Level level, int playable, int searchSpace);

  void reportSingleSolve({
    required Level level,
    required List<Puzzle> solutions,
    required int solveTimeMs,
    required SolveResult? result,
    required LogicalSolveResult logicResult,
    required int playable,
    required int searchSpace,
    required bool quickMode,
    required bool maskMode,
    required bool noColor,
  });

  void beginSummary(List<Level> levels, {required bool quickMode});

  void reportSummaryProgress(
    int currentIndex,
    int totalLevels,
    Level level,
    int playable,
  );

  void reportSummaryRow({
    required Level level,
    required int playable,
    required int searchSpace,
    required int numSolutions,
    required int solveTimeMs,
    required SolveResult? result,
    required LogicalSolveResult logicResult,
    required bool quickMode,
  });

  void endSummary();
}

class CommandLineReporter implements SolveReporter {
  @override
  void reportUsage() {
    print('Grids Solver Summary');
    print(
      'Usage: dart run bin/solve.dart [--mask] [--csv] [--quick] [puzzle_id]',
    );
    print(
      '       --mask   Print solutions as parseMask strings for copy-pasting',
    );
    print('       --csv    Print summary as CSV with histogram data');
    print('       --quick  Skip the slow brute force analysis pass');
    print('');
  }

  @override
  void beginSingleSolve(Level level, int playable, int searchSpace) {
    print(
      'Solving ${level.id} '
      '(${level.puzzle.width}x${level.puzzle.height}, '
      '$playable playable cells, '
      '$searchSpace possible states)...',
    );
  }

  @override
  void reportSingleSolve({
    required Level level,
    required List<Puzzle> solutions,
    required int solveTimeMs,
    required SolveResult? result,
    required LogicalSolveResult logicResult,
    required int playable,
    required int searchSpace,
    required bool quickMode,
    required bool maskMode,
    required bool noColor,
  }) {
    final density = searchSpace > 0
        ? (solutions.length / searchSpace * 100).toStringAsFixed(4)
        : 'N/A';
    final diff = difficulty(solutions.length, playable);

    print(
      'Found ${solutions.length} solution(s) in '
      '${formatDuration(Duration(milliseconds: solveTimeMs))}',
    );
    print('Solution density: ${solutions.length}/$searchSpace ($density%)');
    print('Difficulty: $diff');

    if (!quickMode && result != null) {
      print('Average Error Cells: ${result.averageErrors.toStringAsFixed(2)}');
      print('Median Error Cells: ${result.medianErrors.toStringAsFixed(2)}');
      print(
        'P90 Error Cells: ${result.percentileErrors(0.9).toStringAsFixed(2)}',
      );
    } else {
      print('Dead Ends Evaluated: ${logicResult.deadEnds}');
      print('Logic Moves: ${logicResult.logicMoves}');
      print('Guess Moves: ${logicResult.guessMoves}');
      final ratio =
          '${(logicResult.logicVsGuessingRatio * 100).toStringAsFixed(1)}%';
      print('Logic vs Guessing Ratio: $ratio');
      print(
        'Constraint Density: '
        '${logicResult.constraintDensity.toStringAsFixed(4)}',
      );
    }

    for (var i = 0; i < solutions.length; i++) {
      print('\n--- Solution #${i + 1} ---');
      if (maskMode) {
        print("        GridFormat.parseMask('''");
        print(GridFormat.toMaskString(solutions[i], useColor: !noColor));
        print("        '''),");
      } else {
        print(solutions[i].toAsciiString(useColor: !noColor));
      }
    }
  }

  @override
  void beginSummary(List<Level> levels, {required bool quickMode}) {
    reportUsage();

    final header =
        '${'ID'.padRight(15)}'
        '${'Size'.padRight(6)}'
        '${'Play'.padRight(6)}'
        '${'Search Space'.padRight(14)}'
        '${'Solns'.padRight(7)}'
        '${'Density'.padRight(10)}'
        '${'Difficulty'.padRight(14)}'
        '${'Avg Err'.padRight(9)}'
        '${'L/G Ratio'.padRight(12)}'
        'Time';
    print(header);
    print('─' * header.length);
  }

  @override
  void reportSummaryProgress(
    int currentIndex,
    int totalLevels,
    Level level,
    int playable,
  ) {
    // Print progress on stderr below stdout output.
    stderr.write(
      '\r\x1B[K[$currentIndex/$totalLevels] Solving ${level.id} '
      '($playable playable)...',
    );
  }

  @override
  void reportSummaryRow({
    required Level level,
    required int playable,
    required int searchSpace,
    required int numSolutions,
    required int solveTimeMs,
    required SolveResult? result,
    required LogicalSolveResult logicResult,
    required bool quickMode,
  }) {
    final density = searchSpace > 0
        ? '${(numSolutions / searchSpace * 100).toStringAsFixed(2)}%'
        : 'N/A';
    final diff = difficulty(numSolutions, playable);
    final lRatio =
        '${(logicResult.logicVsGuessingRatio * 100).toStringAsFixed(1)}%';

    final avgErr = (!quickMode && result != null)
        ? result.averageErrors.toStringAsFixed(2)
        : 'N/A';

    stderr.write('\r\x1B[K');

    final size = '${level.puzzle.width}x${level.puzzle.height}';
    print(
      '${level.id.padRight(15)}'
      '${size.padRight(6)}'
      '${playable.toString().padRight(6)}'
      '${searchSpace.toString().padRight(14)}'
      '${numSolutions.toString().padRight(7)}'
      '${density.padRight(10)}'
      '${diff.padRight(14)}'
      '${avgErr.padRight(9)}'
      '${lRatio.padRight(12)}'
      '${formatDuration(Duration(milliseconds: solveTimeMs))}',
    );
  }

  @override
  void endSummary() {
    stderr.writeln();
  }
}

class CsvReporter implements SolveReporter {
  static const CsvEncoder _csvEncoder = CsvEncoder();
  static const int maxErrorCount = 10;

  @override
  void reportUsage() {
    // No-op for CSV
  }

  @override
  void beginSingleSolve(Level level, int playable, int searchSpace) {
    // Usually CSV mode is for summary, but we can do a no-op or print text.
    print(
      'Solving ${level.id} '
      '(${level.puzzle.width}x${level.puzzle.height}, '
      '$playable playable cells, '
      '$searchSpace possible states)...',
    );
  }

  @override
  void reportSingleSolve({
    required Level level,
    required List<Puzzle> solutions,
    required int solveTimeMs,
    required SolveResult? result,
    required LogicalSolveResult logicResult,
    required int playable,
    required int searchSpace,
    required bool quickMode,
    required bool maskMode,
    required bool noColor,
  }) {
    // Fall back to print for single solve in CSV mode to display solutions
    CommandLineReporter().reportSingleSolve(
      level: level,
      solutions: solutions,
      solveTimeMs: solveTimeMs,
      result: result,
      logicResult: logicResult,
      playable: playable,
      searchSpace: searchSpace,
      quickMode: quickMode,
      maskMode: maskMode,
      noColor: noColor,
    );
  }

  @override
  void beginSummary(List<Level> levels, {required bool quickMode}) {
    final columns = [
      'id',
      'width',
      'height',
      'playable',
      'search_space',
      'solns',
      'density_pct',
      'difficulty',
      'avg_err',
      'median_err',
      'p90_err',
      'time_ms',
      'logic_dead_ends',
      'logic_moves',
      'guess_moves',
      'logic_ratio',
      'mechanic_density',
      for (var i = 0; i <= maxErrorCount; i++) 'errors_$i',
    ];
    print(_csvEncoder.convert([columns]).trimRight());
  }

  @override
  void reportSummaryProgress(
    int currentIndex,
    int totalLevels,
    Level level,
    int playable,
  ) {
    // Print progress on stderr so it doesn't corrupt stdout CSV
    stderr.write(
      '\r\x1B[K[$currentIndex/$totalLevels] Solving ${level.id} '
      '($playable playable)...',
    );
  }

  @override
  void reportSummaryRow({
    required Level level,
    required int playable,
    required int searchSpace,
    required int numSolutions,
    required int solveTimeMs,
    required SolveResult? result,
    required LogicalSolveResult logicResult,
    required bool quickMode,
  }) {
    stderr.write('\r\x1B[K');

    final densityNum = searchSpace > 0
        ? (numSolutions / searchSpace * 100).toStringAsFixed(4)
        : '';

    final diff = difficulty(numSolutions, playable);

    final avgErr = (!quickMode && result != null)
        ? result.averageErrors.toStringAsFixed(2)
        : 'N/A';
    final medErr = (!quickMode && result != null)
        ? result.medianErrors.toStringAsFixed(2)
        : 'N/A';
    final p90Err = (!quickMode && result != null)
        ? result.percentileErrors(0.9).toStringAsFixed(2)
        : 'N/A';
    final errorHistogram = (!quickMode && result != null)
        ? result.errorHistogram
        : <int, int>{};

    final row = [
      level.id,
      level.puzzle.width,
      level.puzzle.height,
      playable,
      searchSpace,
      numSolutions,
      densityNum,
      diff,
      avgErr,
      medErr,
      p90Err,
      solveTimeMs,
      logicResult.deadEnds,
      logicResult.logicMoves,
      logicResult.guessMoves,
      logicResult.logicVsGuessingRatio.toStringAsFixed(4),
      logicResult.constraintDensity.toStringAsFixed(4),
      for (var i = 0; i <= maxErrorCount; i++) errorHistogram[i] ?? 0,
    ];
    print(_csvEncoder.convert([row]).trimRight());
  }

  @override
  void endSummary() {
    stderr.writeln();
  }
}
