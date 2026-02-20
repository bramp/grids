// ignore_for_file: avoid_print, Print is allowed in CLI tools.
import 'package:collection/collection.dart';
import 'package:grids/data/level_repository.dart';
import 'package:grids/engine/solver.dart';

void main(List<String> args) {
  final levels = LevelRepository.levels;
  final solver = PuzzleSolver();

  if (args.isNotEmpty) {
    final targetId = args[0];
    final puzzle = levels.firstWhereOrNull((l) => l.id == targetId);

    if (puzzle == null) {
      print('Error: Puzzle "$targetId" not found.');
      print('Available IDs: ${levels.map((l) => l.id).join(', ')}');
      return;
    }

    print(
      'Solving ${puzzle.id} '
      '(${puzzle.initialGrid.width}x${puzzle.initialGrid.height})...',
    );
    final solutions = solver.solve(puzzle);
    print('Found ${solutions.length} solution(s):');

    for (var i = 0; i < solutions.length; i++) {
      print('\n--- Solution #${i + 1} ---');
      print(solutions[i].toAsciiString(useColor: true));
    }
    return;
  }

  // Summary mode (when no args provided)
  print('Grids Solver Summary');
  print('Usage: dart run bin/solve.dart [puzzle_id]');
  print('=' * 30);

  for (final puzzle in levels) {
    final solutions = solver.solve(puzzle);
    print('${puzzle.id.padRight(12)} | ${solutions.length} solution(s)');
  }
}
