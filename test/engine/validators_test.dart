import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/validators.dart';

void main() {
  group('DiamondValidator', () {
    test('Zero diamonds is valid', () {
      final grid = GridState.fromAscii(
        '''
        . .
        . .
      ''',
        legend: const {'.': CellState()},
      );

      final area = {const GridPoint(0, 0), const GridPoint(0, 1)};

      final result = diamondValidator(grid, area);
      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('Exactly two diamonds of same color is valid', () {
      final grid = GridState.fromAscii(
        '''
        r . .
        . r .
        . . .
      ''',
        legend: const {
          'r': CellState(cell: DiamondCell(CellColor.red)),
          '.': CellState(),
        },
      );

      final area = {
        const GridPoint(0, 0),
        const GridPoint(0, 1),
        const GridPoint(1, 1),
      };

      final result = diamondValidator(grid, area);
      expect(result.isValid, isTrue);
    });

    test('One diamond is invalid', () {
      final grid = GridState.fromAscii(
        '''
        b . .
        . . .
        . . .
      ''',
        legend: const {
          'b': CellState(cell: DiamondCell(CellColor.black)),
          '.': CellState(),
        },
      );

      final area = {const GridPoint(0, 0), const GridPoint(0, 1)};

      final result = diamondValidator(grid, area);
      expect(result.isValid, isFalse);
      expect(result.errors, contains(const GridPoint(0, 0)));
    });

    test('Three diamonds of same color is invalid', () {
      final grid = GridState.fromAscii(
        '''
        r r .
        r . .
        . . .
      ''',
        legend: const {
          'r': CellState(cell: DiamondCell(CellColor.red)),
          '.': CellState(),
        },
      );

      final area = {
        const GridPoint(0, 0),
        const GridPoint(0, 1),
        const GridPoint(1, 0),
      };

      final result = diamondValidator(grid, area);
      expect(result.isValid, isFalse);
      expect(result.errors.length, 3);
    });

    test('Two red and two black in same area is valid', () {
      final grid = GridState.fromAscii(
        '''
        r r .
        b b .
        . . .
      ''',
        legend: const {
          'r': CellState(cell: DiamondCell(CellColor.red)),
          'b': CellState(cell: DiamondCell(CellColor.black)),
          '.': CellState(),
        },
      );

      final area = {
        const GridPoint(0, 0),
        const GridPoint(1, 0),
        const GridPoint(0, 1),
        const GridPoint(1, 1),
      };

      final result = diamondValidator(grid, area);
      expect(result.isValid, isTrue);
    });

    test('Two red and one black in same area is invalid for black', () {
      final grid = GridState.fromAscii(
        '''
        r r .
        b . .
        . . .
      ''',
        legend: const {
          'r': CellState(cell: DiamondCell(CellColor.red)),
          'b': CellState(cell: DiamondCell(CellColor.black)),
          '.': CellState(),
        },
      );

      final area = {
        const GridPoint(0, 0),
        const GridPoint(1, 0),
        const GridPoint(0, 1),
      };

      final result = diamondValidator(grid, area);
      expect(result.isValid, isFalse);
      // Validates ONLY the black diamond as the error, as the red ones are
      // successfully paired.
      expect(result.errors, [const GridPoint(0, 1)]);
    });
  });

  group('StrictNumberValidator', () {
    test('Area with no numbers is valid', () {
      final grid = GridState.fromAscii(
        '''
        . .
        . .
      ''',
        legend: const {'.': CellState()},
      );

      final area = {const GridPoint(0, 0), const GridPoint(0, 1)};

      final result = strictNumberValidator(grid, area);
      expect(result.isValid, isTrue);
    });

    test('Single number perfectly matching area size is valid', () {
      final grid = GridState.fromAscii(
        '''
        3 . .
        . . .
        . . .
      ''',
        legend: const {
          '3': CellState(cell: NumberCell(3)),
          '.': CellState(),
        },
      );

      // Area of exactly 3 cells
      final area = {
        const GridPoint(0, 0),
        const GridPoint(0, 1),
        const GridPoint(1, 0),
      };

      final result = strictNumberValidator(grid, area);
      expect(result.isValid, isTrue);
    });

    test('Single number too small for area size is invalid', () {
      final grid = GridState.fromAscii(
        '''
        2 . .
        . . .
        . . .
      ''',
        legend: const {
          '2': CellState(cell: NumberCell(2)),
          '.': CellState(),
        },
      );

      // Area of 3 cells, but number asks for 2
      final area = {
        const GridPoint(0, 0),
        const GridPoint(0, 1),
        const GridPoint(1, 0),
      };

      final result = strictNumberValidator(grid, area);
      expect(result.isValid, isFalse);
      expect(result.errors, [const GridPoint(0, 0)]);
    });

    test('Multiple numbers sum correctly', () {
      final grid = GridState.fromAscii(
        '''
        2 3 .
        . . .
        . . .
      ''',
        legend: const {
          '2': CellState(cell: NumberCell(2)),
          '3': CellState(cell: NumberCell(3)),
          '.': CellState(),
        },
      );

      // Area of 5 cells, exactly 2 + 3
      final area = {
        const GridPoint(0, 0),
        const GridPoint(0, 1),
        const GridPoint(1, 0),
        const GridPoint(1, 1),
        const GridPoint(2, 0),
      };

      final result = strictNumberValidator(grid, area);
      expect(result.isValid, isTrue);
    });
  });

  group('NumberColorValidator', () {
    test('Numbers of same color in area is valid', () {
      final grid = GridState.fromAscii(
        '''
        R1 R2 .
        .  .  .
      ''',
        legend: const {
          '1': CellState(cell: NumberCell(1)),
          '2': CellState(cell: NumberCell(2)),
          '.': CellState(),
        },
      );

      final area = {const GridPoint(0, 0), const GridPoint(1, 0)};
      final result = numberColorValidator(grid, area);
      expect(result.isValid, isTrue);
    });

    test('Numbers of different colors in area is invalid', () {
      final grid = GridState.fromAscii(
        '''
        R1 B2 .
        .  .  .
      ''',
        legend: const {
          '1': CellState(cell: NumberCell(1)),
          '2': CellState(cell: NumberCell(2)),
          '.': CellState(),
        },
      );

      final area = {const GridPoint(0, 0), const GridPoint(1, 0)};
      final result = numberColorValidator(grid, area);
      expect(result.isValid, isFalse);
      expect(result.errors.length, 2);
    });

    test('Color and null color mixed in area is invalid', () {
      final grid = GridState.fromAscii(
        '''
        R1 2 .
        .  . .
      ''',
        legend: const {
          '1': CellState(cell: NumberCell(1)),
          '2': CellState(cell: NumberCell(2)),
          '.': CellState(),
        },
      );

      final area = {const GridPoint(0, 0), const GridPoint(1, 0)};
      final result = numberColorValidator(grid, area);
      expect(result.isValid, isFalse);
    });
  });
}
