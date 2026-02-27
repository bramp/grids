import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/validators.dart';

void main() {
  group('DiamondValidator', () {
    test('Zero diamonds is valid', () {
      final grid = GridFormat.parse(
        '''
        . .
        . .
      ''',
      );

      final area = [
        const GridPoint(0),
        const GridPoint(2),
      ]; // (0,0) and (0,1) for width 2

      final result = diamondValidator.validate(grid, area);
      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('Exactly two diamonds of same color is valid', () {
      final grid = GridFormat.parse(
        '''
        Ro . .
        . Ro .
        . . .
      ''',
      );

      final area = [
        const GridPoint(0),
        const GridPoint(4),
        const GridPoint(1),
      ]; // (0,0), (1,1), (1,0) - width 3

      final result = diamondValidator.validate(grid, area);
      expect(result.isValid, isTrue);
    });

    test('One diamond is invalid', () {
      final grid = GridFormat.parse(
        '''
        Ko . .
        . . .
        . . .
      ''',
      );

      final area = [const GridPoint(0), const GridPoint(3)];

      final result = diamondValidator.validate(grid, area);
      expect(result.isValid, isFalse);
      expect(result.errors.map((e) => e.point), contains(const GridPoint(0)));
    });

    test('Three diamonds of same color is invalid', () {
      final grid = GridFormat.parse(
        '''
        Ro Ro .
        Ro . .
        . . .
      ''',
      );

      final area = [
        const GridPoint(0),
        const GridPoint(1),
        const GridPoint(3),
      ];

      final result = diamondValidator.validate(grid, area);
      expect(result.isValid, isFalse);
      expect(result.errors.length, 3);
    });

    test('Two diamonds of different colors is NOT a match', () {
      final grid = GridFormat.parse(
        '''
        Ro Bo .
        . . .
      ''',
      );

      final area = [const GridPoint(0), const GridPoint(1)];

      final result = diamondValidator.validate(grid, area);
      expect(result.isValid, isFalse);
    });

    test('Paired colors pass even if another color is unpaired', () {
      final grid = GridFormat.parse(
        '''
        Ro Ro .
        Bo . .
        . . .
      ''',
      );

      final area = [const GridPoint(0), const GridPoint(1), const GridPoint(3)];

      final result = diamondValidator.validate(grid, area);
      expect(result.isValid, isFalse);
      // Validates ONLY the blue diamond as the error (index 3)
      expect(result.errors.map((e) => e.point), [const GridPoint(3)]);
    });

    test('Dashes and Numbers pair properly with diamonds', () {
      final grid = GridFormat.parse(
        '''
        Ro R- .
        R1 . .
        .  . .
      ''',
      );

      // Contains red diamond, red dash, red number. Total = 3. Should fail.
      final area = [const GridPoint(0), const GridPoint(1), const GridPoint(3)];

      final result = diamondValidator.validate(grid, area);
      expect(result.isValid, isFalse);
      expect(result.errors.length, 3);
    });
  });
}
