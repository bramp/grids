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

      final area = [const GridPoint(0), const GridPoint(3)]; // (0,0), (0,1)

      final result = diamondValidator.validate(grid, area);
      expect(result.isValid, isFalse);
      expect(result.errors, contains(const GridPoint(0)));
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
      ]; // (0,0), (1,0), (0,1)

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
      expect(result.errors, [const GridPoint(3)]);
    });
  });

  group('StrictNumberValidator', () {
    test('Area with no numbers is valid', () {
      final grid = GridFormat.parse(
        '''
        . .
        . .
      ''',
      );

      final result = strictNumberValidator.validate(grid, [const GridPoint(0)]);
      expect(result.isValid, isTrue);
    });

    test('Single number perfectly matching area size is valid', () {
      final grid = GridFormat.parse(
        '''
        3 . .
        . . .
        . . .
      ''',
      );

      // Area of exactly 3 cells
      final area = [const GridPoint(0), const GridPoint(3), const GridPoint(1)];

      final result = strictNumberValidator.validate(grid, area);
      expect(result.isValid, isTrue);
    });

    test('Single number too small for area size is invalid', () {
      final grid = GridFormat.parse(
        '''
        2 . .
        . . .
        . . .
      ''',
      );

      // Area of 3 cells, but number asks for 2
      final area = [const GridPoint(0), const GridPoint(3), const GridPoint(1)];

      final result = strictNumberValidator.validate(grid, area);
      expect(result.isValid, isFalse);
      expect(result.errors, [const GridPoint(0)]);
    });

    test('Multiple numbers sum correctly', () {
      final grid = GridFormat.parse(
        '''
        2 3 .
        . . .
        . . .
      ''',
      );

      // Area of 5 cells, exactly 2 + 3
      final area = [
        const GridPoint(0),
        const GridPoint(1),
        const GridPoint(3),
        const GridPoint(4),
        const GridPoint(2),
      ];

      final result = strictNumberValidator.validate(grid, area);
      expect(result.isValid, isTrue);
    });

    test('Negative numbers reduce required area size', () {
      final grid = GridFormat.parse(
        '''
        5 -1 .
        . . .
      ''',
      );

      // Area of 4 cells, which is 5 + (-1)
      final area = [
        const GridPoint(0),
        const GridPoint(1),
        const GridPoint(3),
        const GridPoint(4),
      ];

      final result = strictNumberValidator.validate(grid, area);
      expect(result.isValid, isTrue);
    });

    test('Net zero sum allows any area size', () {
      final grid = GridFormat.parse(
        '''
        1 -1 .
        .  . .
      ''',
      );

      // Area of 3 cells
      final area = [const GridPoint(0), const GridPoint(1), const GridPoint(2)];
      final result1 = strictNumberValidator.validate(grid, area);
      expect(
        result1.isValid,
        isTrue,
        reason: 'Area of 3 should be valid for sum 0',
      );

      // Area of 1 cell
      final area2 = [const GridPoint(0)];
      final result2 = strictNumberValidator.validate(grid, area2);
      expect(
        result2.isValid,
        isTrue,
        reason: 'Area of 1 should be valid for sum 0',
      );
    });

    test('Net negative sum is always invalid', () {
      final grid = GridFormat.parse(
        '''
        -1 . .
        .  . .
      ''',
      );

      final area = [const GridPoint(0)];
      final result = strictNumberValidator.validate(grid, area);
      expect(result.isValid, isFalse);
      expect(result.errors, [const GridPoint(0)]);
    });

    test('Net negative sum (multiple cells) is always invalid', () {
      final grid = GridFormat.parse(
        '''
        1 -2 .
        .  . .
      ''',
      );

      final area = [const GridPoint(0), const GridPoint(1)];
      final result = strictNumberValidator.validate(grid, area);
      expect(result.isValid, isFalse);
      expect(
        result.errors,
        containsAll([const GridPoint(0), const GridPoint(1)]),
      );
    });
  });

  group('NumberColorValidator', () {
    test('Numbers of same color in area is valid', () {
      final grid = GridFormat.parse(
        '''
        R1 R2 .
        .  .  .
      ''',
      );

      final area = [const GridPoint(0), const GridPoint(1)];
      final result = numberColorValidator.validate(grid, area);
      expect(result.isValid, isTrue);
    });

    test('Numbers of different colors in area is invalid', () {
      final grid = GridFormat.parse(
        '''
        R1 B2 .
        .  .  .
      ''',
      );

      final area = [const GridPoint(0), const GridPoint(1)];
      final result = numberColorValidator.validate(grid, area);
      expect(result.isValid, isFalse);
      expect(result.errors.length, 2);
    });

    test('Color and null color mixed in area is invalid', () {
      final grid = GridFormat.parse(
        '''
        R1 2 .
        .  . .
      ''',
      );

      final area = [const GridPoint(0), const GridPoint(1)];
      final result = numberColorValidator.validate(grid, area);
      expect(result.isValid, isFalse);
    });
  });
}
