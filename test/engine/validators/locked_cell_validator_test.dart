import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/validators.dart';

void main() {
  group('LockedCellValidator', () {
    test('Area with no locked cells is valid', () {
      final grid = GridFormat.parse(
        '''
        1 .
        . .
      ''',
      );

      final result = lockedCellValidator.validate(grid, [const GridPoint(0)]);
      expect(result.isValid, isTrue);
    });

    test('Locked unlit cell that is unlit is valid', () {
      final grid = GridFormat.parse(
        '''
        (1) .
        .  .
      ''',
      );

      final result = lockedCellValidator.validate(grid, [const GridPoint(0)]);
      expect(result.isValid, isTrue);
    });

    test('Locked lit cell that is lit is valid', () {
      final grid = GridFormat.parse(
        '''
        (1*) .
        .    .
      ''',
      );

      final result = lockedCellValidator.validate(grid, [const GridPoint(0)]);
      expect(result.isValid, isTrue);
    });

    test('Locked unlit cell that is toggled lit is invalid', () {
      final grid = GridFormat.parse(
        '''
        (1) .
        .   .
      ''',
      ).setLit(const GridPoint(0), isLit: true);

      final result = lockedCellValidator.validate(grid, [const GridPoint(0)]);
      expect(result.isValid, isFalse);
      expect(result.errors, [const GridPoint(0)]);
    });

    test('Locked lit cell that is toggled unlit is invalid', () {
      final grid = GridFormat.parse(
        '''
        (1*) .
        .    .
      ''',
      ).setLit(const GridPoint(0), isLit: false);

      final result = lockedCellValidator.validate(grid, [const GridPoint(0)]);
      expect(result.isValid, isFalse);
      expect(result.errors, [const GridPoint(0)]);
    });
  });
}
