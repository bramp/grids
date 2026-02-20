import 'package:flutter_test/flutter_test.dart';
import 'package:grids/data/level_repository.dart';
import 'package:grids/engine/solver.dart';

void main() {
  group('PuzzleSolver', () {
    final solver = PuzzleSolver();
    final levels = LevelRepository.levels;

    // We test the solver on a few small, fast puzzles to verify its logic
    // without running the full battery on every test pass.
    final fastPuzzles = ['shrine_1', 'shrine_2', 'shrine_5'];

    for (final id in fastPuzzles) {
      final level = levels.firstWhere((l) => l.id == id);

      test('finds solutions for $id', () {
        final solutions = solver.solve(level);
        expect(solutions, isNotEmpty);
      });
    }

    test('finds correct number of solutions for shrine_1', () {
      final level = levels.firstWhere((l) => l.id == 'shrine_1');
      final solutions = solver.solve(level);
      // We know shrine_1 has 2 solutions after deduplicating empty cells.
      expect(solutions.length, equals(2));
    });
  });
}
