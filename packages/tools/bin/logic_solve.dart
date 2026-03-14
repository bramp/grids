// This script is purely meant for debugging output to the console.
// ignore_for_file: avoid_print
// CLI tool for testing the logical solver directly.
import 'package:collection/collection.dart';
import 'package:grids_engine/data/level_repository.dart';
import 'package:grids_tools/solver/duration_format.dart';
import 'package:grids_tools/solver/logical_solver.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart run bin/logic_solve.dart [puzzle_id]');
    return;
  }

  final targetId = args[0];
  final levels = LevelRepository.levels;
  final level = levels.firstWhereOrNull((l) => l.id == targetId);

  if (level == null) {
    print(r'Error: Level "$targetId" not found.');
    return;
  }

  final puzzle = level.puzzle;
  final solver = LogicalSolver();

  print('Logic solving ${level.id} (${puzzle.width}x${puzzle.height})...');

  final stopwatch = Stopwatch()..start();
  final result = solver.solve(puzzle);
  stopwatch.stop();

  print(
    'Found ${result.solutions.length} solution(s) in '
    '${formatDuration(Duration(milliseconds: stopwatch.elapsedMilliseconds))}',
  );
  print('Dead Ends Evaluated: ${result.deadEnds}');
  print('Logic Moves Forced: ${result.logicMoves}');
  print('Guess Moves Made: ${result.guessMoves}');
  print(
    'Logic/Guess Ratio: ${(result.logicVsGuessingRatio * 100).toStringAsFixed(2)}%',
  );
  print(
    'Mechanic Density: ${(result.constraintDensity * 100).toStringAsFixed(2)}%',
  );

  for (var i = 0; i < result.solutions.length; i++) {
    print('\n--- Solution #${i + 1} ---');
    print(result.solutions[i].toAsciiString(useColor: true));
  }
}
