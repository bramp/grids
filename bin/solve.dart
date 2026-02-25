// ignore_for_file: avoid_print, Print is allowed in CLI tools.
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:grids/data/level_repository.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/solver.dart';

/// Returns the number of playable (non-locked) cells in the grid.
int _countPlayable(GridState grid) {
  var count = 0;
  for (var i = 0; i < grid.mechanics.length; i++) {
    if (!grid.isLocked(GridPoint(i))) {
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

void main(List<String> args) {
  final maskMode = args.contains('--mask');
  final noColor = args.contains('--no-color');
  final filteredArgs = args
      .where((a) => a != '--mask' && a != '--no-color')
      .toList();

  final levels = LevelRepository.levels;
  final solver = PuzzleSolver();

  if (filteredArgs.isNotEmpty) {
    final targetId = filteredArgs[0];
    final puzzle = levels.firstWhereOrNull((l) => l.id == targetId);

    if (puzzle == null) {
      print('Error: Puzzle "$targetId" not found.');
      print('Available IDs: ${levels.map((l) => l.id).join(', ')}');
      return;
    }

    final grid = puzzle.initialGrid;
    final playable = _countPlayable(grid);
    final searchSpace = pow(2, playable);

    print(
      'Solving ${puzzle.id} '
      '(${grid.width}x${grid.height}, '
      '$playable playable cells, '
      '$searchSpace possible states)...',
    );

    final stopwatch = Stopwatch()..start();
    final solutions = solver.solve(puzzle);
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
  print('Grids Solver Summary');
  print('Usage: dart run bin/solve.dart [--mask] [puzzle_id]');
  print(
    '       --mask   Print solutions as parseMask strings for copy-pasting',
  );
  print('');

  final header =
      '${'ID'.padRight(15)}'
      '${'Size'.padRight(6)}'
      '${'Play'.padRight(6)}'
      '${'Search Space'.padRight(14)}'
      '${'Solns'.padRight(7)}'
      '${'Density'.padRight(10)}'
      '${'Difficulty'.padRight(14)}'
      'Time';
  print(header);
  print('─' * header.length);

  for (final puzzle in levels) {
    final grid = puzzle.initialGrid;
    final playable = _countPlayable(grid);
    final searchSpace = pow(2, playable);

    final stopwatch = Stopwatch()..start();
    final solutions = solver.solve(puzzle);
    stopwatch.stop();

    final density = searchSpace > 0
        ? '${(solutions.length / searchSpace * 100).toStringAsFixed(2)}%'
        : 'N/A';
    final difficulty = _difficulty(solutions.length, playable);
    final size = '${grid.width}x${grid.height}';
    final time = '${stopwatch.elapsedMilliseconds}ms';

    print(
      '${puzzle.id.padRight(15)}'
      '${size.padRight(6)}'
      '${playable.toString().padRight(6)}'
      '${searchSpace.toString().padRight(14)}'
      '${solutions.length.toString().padRight(7)}'
      '${density.padRight(10)}'
      '${difficulty.padRight(14)}'
      '$time',
    );
  }
}
