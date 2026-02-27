import 'package:flutter_test/flutter_test.dart';
import 'package:grids/data/level_repository.dart';
import 'package:grids/engine/puzzle_validator.dart';

import 'matchers.dart';

void main() {
  final validator = PuzzleValidator();
  final levels = LevelRepository.levels;

  test('all puzzle IDs are unique', () {
    final ids = levels.map((p) => p.id).toList();
    final seen = <String>{};
    final duplicates = <String>[];
    for (final id in ids) {
      if (!seen.add(id)) {
        duplicates.add(id);
      }
    }
    expect(
      duplicates,
      isEmpty,
      reason: 'Duplicate puzzle IDs found: $duplicates',
    );
  });

  group('Known Solutions', () {
    for (final level in levels) {
      group(level.id, () {
        for (var i = 0; i < level.knownSolutions.length; i++) {
          test('solution #$i is valid', () {
            final solution = level.knownSolutions[i];
            final puzzle = level.puzzle.copyWith(state: solution);
            expect(
              puzzle,
              isValidPuzzle(validator),
            );
          });
        }
      });
    }
  });
}
