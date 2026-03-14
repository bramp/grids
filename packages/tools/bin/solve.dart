// CLI tool.
// ignore_for_file: avoid_print
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:grids_engine/data/level_repository.dart';
import 'package:grids_engine/puzzle.dart';
import 'package:grids_tools/solver/logical_solver.dart';
import 'package:grids_tools/solver/puzzle_metrics.dart';
import 'package:grids_tools/solver/solve_cache.dart';
import 'package:grids_tools/solver/solve_reporter.dart';
import 'package:grids_tools/solver/solver.dart';

void main(List<String> args) {
  final maskMode = args.contains('--mask');
  final noColor = args.contains('--no-color');
  final csvMode = args.contains('--csv');
  final quickMode = args.contains('--quick');
  final filteredArgs = args
      .where(
        (a) =>
            a != '--mask' &&
            a != '--no-color' &&
            a != '--csv' &&
            a != '--quick',
      )
      .toList();

  final levels = LevelRepository.levels;
  final solver = PuzzleSolver();
  final logicSolver = LogicalSolver();
  final cache = SolveCache();

  final reporter = csvMode ? CsvReporter() : CommandLineReporter();

  if (filteredArgs.isNotEmpty) {
    final targetId = filteredArgs[0];
    final level = levels.firstWhereOrNull((l) => l.id == targetId);

    if (level == null) {
      print('Error: Level "$targetId" not found.');
      print('Available IDs: ${levels.map((l) => l.id).join(', ')}');
      return;
    }

    final puzzle = level.puzzle;

    final playable = countPlayable(puzzle);
    final searchSpace = pow(2, playable).toInt();

    reporter.beginSingleSolve(level, playable, searchSpace);

    late final List<Puzzle> solutions;
    late final int solveTimeMs;
    SolveResult? result;
    late final LogicalSolveResult logicResult;

    if (quickMode) {
      final sw = Stopwatch()..start();
      logicResult = logicSolver.solve(puzzle);
      sw.stop();
      solutions = logicResult.solutions;
      solveTimeMs = sw.elapsedMilliseconds;
    } else {
      final cached = cache.solve(
        solver,
        puzzle,
        analyze: true,
      );
      result = cached.result;
      solutions = cached.solutions;
      solveTimeMs = cached.solveTimeMs;

      // Also trace logical to gather single solve metrics if applicable
      logicResult = logicSolver.solve(puzzle);
    }

    reporter.reportSingleSolve(
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
    return;
  }

  reporter.beginSummary(levels, quickMode: quickMode);

  for (var li = 0; li < levels.length; li++) {
    final level = levels[li];
    final puzzle = level.puzzle;
    final playable = countPlayable(puzzle);
    final searchSpace = pow(2, playable).toInt();

    reporter.reportSummaryProgress(li + 1, levels.length, level, playable);

    var solveTimeMs = 0;
    var numSolutions = 0;
    SolveResult? result;

    if (!quickMode) {
      final cached = cache.solve(
        solver,
        puzzle,
        analyze: true,
      );
      solveTimeMs = cached.solveTimeMs;
      numSolutions = cached.result.solutions.length;
      result = cached.result;
    }

    final sw = Stopwatch()..start();
    final logicResult = logicSolver.solve(puzzle);
    sw.stop();

    if (quickMode) {
      solveTimeMs = sw.elapsedMilliseconds;
      numSolutions = logicResult.solutions.length;
    }

    reporter.reportSummaryRow(
      level: level,
      playable: playable,
      searchSpace: searchSpace,
      numSolutions: numSolutions,
      solveTimeMs: solveTimeMs,
      result: result,
      logicResult: logicResult,
      quickMode: quickMode,
    );
  }

  reporter.endSummary();
}
