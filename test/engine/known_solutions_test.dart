import 'package:flutter_test/flutter_test.dart';
import 'package:grids/data/level_repository.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/puzzle_validator.dart';

void main() {
  group('Known Solutions Verification', () {
    final validator = PuzzleValidator();
    final levels = LevelRepository.levels;

    for (final level in levels) {
      if (level.knownSolutions.isEmpty) continue;

      group('Level ${level.id}', () {
        for (var i = 0; i < level.knownSolutions.length; i++) {
          final solutionBits = level.knownSolutions[i];
          test('Solution #$i is valid', () {
            final solutionGrid = level.initialGrid.withBits(solutionBits);
            final result = validator.validate(solutionGrid);

            expect(
              result.isValid,
              isTrue,
              reason:
                  'Level ${level.id} logic should accept this solution:\n'
                  '${GridFormat.toAsciiString(solutionGrid)}',
            );
          });
        }
      });
    }
  });
}
