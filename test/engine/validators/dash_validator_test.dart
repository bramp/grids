import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/validators.dart';

void main() {
  group('DashValidator', () {
    test('Single dash is always valid', () {
      final grid = GridFormat.parse(
        '''
        -  .  .
        .  .  .
        .  .  .
      ''',
      );

      final result = dashValidator.validate(grid, [const GridPoint(0)]);
      expect(result.isValid, isTrue);
    });

    test('Two strict dashes with identical shapes and positions are valid', () {
      final grid = GridFormat.parse(
        '''
        -  .  .*
        .* .* .*
        -  .  .*
      ''',
      );
      // Row 0 is unlit 2-cell area: (0,0), (1,0)
      // Row 2 is unlit 2-cell area: (0,2), (1,2)
      final area1 = [const GridPoint(0), const GridPoint(1)];
      final area2 = [const GridPoint(6), const GridPoint(7)];

      final result1 = dashValidator.validate(grid, area1);
      final result2 = dashValidator.validate(grid, area2);
      expect(result1.isValid, isTrue);
      expect(result2.isValid, isTrue);
    });

    test('Two strict dashes with different shapes are invalid', () {
      final grid = GridFormat.parse(
        '''
        -  .  .*
        .* .* .*
        -  .* .*
      ''',
      );
      // Top row is 2-cell: (0,0), (1,0)
      // Bottom row is 1-cell: (0,2)
      final area1 = [const GridPoint(0), const GridPoint(1)];

      final result = dashValidator.validate(grid, area1);
      expect(result.isValid, isFalse);
      expect(result.errors.map((e) => e.point), [const GridPoint(0)]);
    });

    test(
      'Two strict dashes with same shape but different relative position '
      'are invalid',
      () {
        final grid = GridFormat.parse(
          '''
        -  .  .*
        .  -  .*
        .* .* .*
      ''',
        );
        // Row 0 is 2-cell: dash at left
        // Row 1 is 2-cell: dash at right
        final area1 = [const GridPoint(0), const GridPoint(1)];

        final result = dashValidator.validate(grid, area1);
        expect(result.isValid, isFalse);
        expect(result.errors.map((e) => e.point), [const GridPoint(0)]);
      },
    );

    test('Rotations of strict dash are invalid for another strict dash', () {
      final grid = GridFormat.parse(
        '''
        -  .  .*
        .* .* -
        .* .* .
      ''',
      );
      // Top row is horizontal 2-cell: dash at left
      // Right col is vertical 2-cell: dash at top
      final area1 = [const GridPoint(0), const GridPoint(1)];
      final result = dashValidator.validate(grid, area1);
      expect(result.isValid, isFalse);
      expect(result.errors.map((e) => e.point), [const GridPoint(0)]);
    });

    test('Diagonal dash can match rotated strict dash', () {
      final grid = GridFormat.parse(
        '''
        -  .  .*
        .* .* /
        .* .* .
      ''',
      );
      // Horizontal strict -, vertical diag / (rotated 90 deg)
      final area1 = [const GridPoint(0), const GridPoint(1)];
      final result = dashValidator.validate(grid, area1);
      expect(result.isValid, isTrue);
    });

    test('Diagonal dash cannot match non-rotation of strict dash', () {
      // Let's make an invalid shape, like a 3-cell L shape vs 2-cell.
      final grid2 = GridFormat.parse(
        '''
        -  .  .
        .* .* .*
        .* /  .
      ''',
      );
      final area1 = [
        const GridPoint(0),
        const GridPoint(1),
        const GridPoint(2),
      ];
      final result = dashValidator.validate(grid2, area1);
      expect(result.isValid, isFalse);
    });

    test('Two diagonal dashes can be rotations of each other', () {
      final grid = GridFormat.parse(
        '''
        /  .  .*
        .* .* /
        .* .* .
      ''',
      );
      // Top is 2x1 horizontal. Right is 1x2 vertical.
      final area1 = [const GridPoint(0), const GridPoint(1)];
      final result = dashValidator.validate(grid, area1).isValid;
      expect(result, isTrue);
    });

    test('Different colored dashes must NOT have matching areas', () {
      final grid = GridFormat.parse(
        '''
        R-  .  .*
        .* .* .*
        B-  .  .*
        .* .* .*
      ''',
      );
      // Top row is 2-cell Red dash area
      // Bottom row is 2-cell Blue dash area (Identical shape/relative position)
      final areaRed = [const GridPoint(0), const GridPoint(1)];
      final areaBlue = [const GridPoint(6), const GridPoint(7)];

      final resultRed = dashValidator.validate(grid, areaRed);
      final resultBlue = dashValidator.validate(grid, areaBlue);

      // This currently passes! It should fail.
      expect(
        resultRed.isValid,
        isFalse,
        reason: 'Red dash area matches Blue dash area',
      );
      expect(
        resultBlue.isValid,
        isFalse,
        reason: 'Blue dash area matches Red dash area',
      );
    });

    test('Diagonal dash area matching another color rotated (Invalid)', () {
      final grid = GridFormat.parse(
        '''
        R/  .  .*
        .* .* .*
        B-  .* .*
        B.  .* .*
      ''',
      );
      // Top row is 2-cell Red Diagonal dash area (horizontal)
      // Bottom left is 2-cell Blue Strict dash area (vertical)
      // Red has 4 signatures (including vertical one).
      // Blue has 1 signature (vertical).
      // They match!
      final areaRed = [const GridPoint(0), const GridPoint(1)];
      final areaBlue = [const GridPoint(6), const GridPoint(9)];

      final resultRed = dashValidator.validate(grid, areaRed);
      final resultBlue = dashValidator.validate(grid, areaBlue);

      expect(resultRed.isValid, isFalse);
      expect(resultBlue.isValid, isFalse);
    });
  });
}
