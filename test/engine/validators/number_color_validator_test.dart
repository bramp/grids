import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/validators.dart';

void main() {
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
