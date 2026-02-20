import 'package:flutter_test/flutter_test.dart';
import 'package:grids/data/level_repository.dart';
import 'package:grids/engine/solver.dart';

void main() {
  group('Level Solvability Tests', () {
    final solver = PuzzleSolver();
    final levels = LevelRepository.levels;

    for (final level in levels) {
      test('Level ${level.id} is solvable', () {
        final solutions = solver.solve(level);
        expect(
          solutions,
          isNotEmpty,
          reason: 'Level ${level.id} should have at least one valid solution.',
        );
      });
    }
  });
}
