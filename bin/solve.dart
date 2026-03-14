// ignore_for_file: avoid_print, Print is allowed in CLI tools.
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:grids/data/level_repository.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/solver.dart';

/// Returns the number of playable (non-locked) cells in the grid.
int _countPlayable(Puzzle puzzle) {
  var count = 0;
  for (var i = 0; i < puzzle.mechanics.length; i++) {
    if (!puzzle.isLocked(GridPoint(i))) {
      count++;
    }
  }
  return count;
}

/// Returns a difficulty rating based on solution density and grid complexity.
///
/// Heuristic: score = playableCells - log2(solutionCount)
/// This represents "how many bits of information you need to find a solution."
/// Higher = harder.
String _difficulty(int solutionCount, int playableCells) {
  if (playableCells == 0) return '⬜ trivial';
  if (solutionCount == 0) return '🚫 impossible';

  final searchSpace = pow(2, playableCells);
  final density = solutionCount / searchSpace;
  final score = -log(density) / ln2;

  if (score <= 4) return '🟢 easy';
  if (score <= 8) return '🟡 medium';
  if (score <= 14) return '🟠 hard';
  return '🔴 expert';
}

/// Escapes a value for CSV output, quoting if it contains commas or quotes.
String _csvEscape(String value) {
  if (value.contains(',') || value.contains('"') || value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

void main(List<String> args) {
  final maskMode = args.contains('--mask');
  final noColor = args.contains('--no-color');
  final csvMode = args.contains('--csv');
  final filteredArgs = args
      .where((a) => a != '--mask' && a != '--no-color' && a != '--csv')
      .toList();

  final levels = LevelRepository.levels;
  final solver = PuzzleSolver();

  if (filteredArgs.isNotEmpty) {
    final targetId = filteredArgs[0];
    final level = levels.firstWhereOrNull((l) => l.id == targetId);

    if (level == null) {
      print('Error: Level "$targetId" not found.');
      print('Available IDs: ${levels.map((l) => l.id).join(', ')}');
      return;
    }

    final puzzle = level.puzzle;

    final playable = _countPlayable(puzzle);
    final searchSpace = pow(2, playable);

    print(
      'Solving ${level.id} '
      '(${puzzle.width}x${puzzle.height}, '
      '$playable playable cells, '
      '$searchSpace possible states)...',
    );

    final stopwatch = Stopwatch()..start();
    final result = solver.solve(puzzle, analyze: true);
    final solutions = result.solutions;
    stopwatch.stop();

    final density = searchSpace > 0
        ? (solutions.length / searchSpace * 100).toStringAsFixed(4)
        : 'N/A';
    final difficulty = _difficulty(solutions.length, playable);

    print(
      'Found ${solutions.length} solution(s) in '
      '${stopwatch.elapsedMilliseconds}ms',
    );
    print('Solution density: ${solutions.length}/$searchSpace ($density%)');
    print('Difficulty: $difficulty');
    print('Average Error Cells: ${result.averageErrors.toStringAsFixed(2)}');
    print('Median Error Cells: ${result.medianErrors.toStringAsFixed(2)}');
    print(
      'P90 Error Cells: ${result.percentileErrors(0.9).toStringAsFixed(2)}',
    );

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
    return;
  }

  // Summary mode (when no args provided)
  if (!csvMode) {
    print('Grids Solver Summary');
    print('Usage: dart run bin/solve.dart [--mask] [--csv] [puzzle_id]');
    print(
      '       --mask   Print solutions as parseMask strings for copy-pasting',
    );
    print('       --csv    Print summary as CSV with histogram data');
    print('');
  }

  const maxErrorCount = 10;

  if (csvMode) {
    // CSV header
    final columns = [
      'id',
      'width',
      'height',
      'playable',
      'search_space',
      'solutions',
      'density_pct',
      'difficulty',
      'avg_err',
      'median_err',
      'p90_err',
      'time_ms',
      for (var i = 0; i <= maxErrorCount; i++) 'errors_$i',
    ];
    print(columns.join(','));
  } else {
    final header =
        '${'ID'.padRight(15)}'
        '${'Size'.padRight(6)}'
        '${'Play'.padRight(6)}'
        '${'Search Space'.padRight(14)}'
        '${'Solns'.padRight(7)}'
        '${'Density'.padRight(10)}'
        '${'Difficulty'.padRight(14)}'
        '${'Avg Err'.padRight(9)}'
        'Time';
    print(header);
    print('─' * header.length);
  }

  for (var li = 0; li < levels.length; li++) {
    final level = levels[li];
    final puzzle = level.puzzle;
    final playable = _countPlayable(puzzle);
    final searchSpace = pow(2, playable);

    // Print progress on stderr below stdout output. The \r lets each
    // progress line overwrite the previous one without scrolling.
    stderr.write(
      '\r\x1B[K[${li + 1}/${levels.length}] Solving ${level.id} '
      '($playable playable)...',
    );

    final stopwatch = Stopwatch()..start();
    final result = solver.solve(puzzle, analyze: true);
    final solutions = result.solutions;
    stopwatch.stop();

    final density = searchSpace > 0
        ? '${(solutions.length / searchSpace * 100).toStringAsFixed(2)}%'
        : 'N/A';
    final difficulty = _difficulty(solutions.length, playable);

    // Clear the stderr progress line before printing stdout row.
    stderr.write('\r\x1B[K');

    if (csvMode) {
      final densityNum = searchSpace > 0
          ? (solutions.length / searchSpace * 100).toStringAsFixed(4)
          : '';
      final row = [
        _csvEscape(level.id),
        puzzle.width,
        puzzle.height,
        playable,
        searchSpace,
        solutions.length,
        densityNum,
        _csvEscape(difficulty),
        result.averageErrors.toStringAsFixed(2),
        result.medianErrors.toStringAsFixed(2),
        result.percentileErrors(0.9).toStringAsFixed(2),
        stopwatch.elapsedMilliseconds,
        for (var i = 0; i <= maxErrorCount; i++) result.errorHistogram[i] ?? 0,
      ];
      print(row.join(','));
    } else {
      final size = '${puzzle.width}x${puzzle.height}';
      print(
        '${level.id.padRight(15)}'
        '${size.padRight(6)}'
        '${playable.toString().padRight(6)}'
        '${searchSpace.toString().padRight(14)}'
        '${solutions.length.toString().padRight(7)}'
        '${density.padRight(10)}'
        '${difficulty.padRight(14)}'
        '${result.averageErrors.toStringAsFixed(2).padRight(9)}'
        '${stopwatch.elapsedMilliseconds}ms',
      );
    }
  }
  stderr.writeln();
}
