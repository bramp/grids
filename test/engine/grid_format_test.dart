import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/grid_point.dart';

void main() {
  group('GridFormat Consistency', () {
    void testRoundTrip(String label, String ascii) {
      test(label, () {
        // Parse the input ASCII
        final grid = GridFormat.parse(ascii);

        // Convert it back to ASCII
        final backToAscii = GridFormat.toAsciiString(grid);

        // Parse the converted ASCII back to a second grid
        final grid2 = GridFormat.parse(backToAscii);

        // Both grids should be equal
        expect(
          grid2,
          grid,
          reason: 'Grid state should be preserved after round-trip',
        );

        // The converted ASCII should also be stable (idempotent)
        final backToAscii2 = GridFormat.toAsciiString(grid2);
        expect(
          _normalizeOutput(backToAscii2),
          _normalizeOutput(backToAscii),
          reason: 'toAsciiString should be stable',
        );
      });
    }

    testRoundTrip('Simple 2x2 grid', '''
      . .
      . .
    ''');

    testRoundTrip('Numbers and Colors', '''
      R1 K2
      Y3 B4
    ''');

    testRoundTrip('Diamonds', '''
      Ro Ko
      Yo Bo
    ''');

    testRoundTrip('Flowers', '''
      F0 F1
      F2 F3
    ''');

    testRoundTrip('Dashes', '''
      R- K-
      Y/ B/
    ''');

    testRoundTrip('Locked and Lit', '''
      (*) (R1)
      (*Ro) .
    ''');

    testRoundTrip('Void Cells (x)', '''
      . x .
      x . x
      . x .
    ''');

    testRoundTrip('Mixed complex grid', '''
      (F1) (*)  Ro
      Y/   x    B-
      (2)  Yo*  .
    ''');

    testRoundTrip('Multiple colors', '''
      Ro Go Yo Co Po
      Wo K- B/ R1 G2
    ''');

    testRoundTrip('Spaces in parentheses', '''
      ( F1 )  ( * )
      ( R o ) ( x )
    ''');

    testRoundTrip('Asterisk on both sides', '''
      *R1*  *o*
      .*    *.
    ''');

    test('toMaskString consistency', () {
      const ascii = '''
        . * .
        * . *
        . * .
      ''';
      final grid = GridFormat.parse(ascii);
      final mask = GridFormat.toMaskString(grid.state);

      // parseMask should return the same bits
      final solution = GridFormat.parseMask(mask);
      expect(
        solution.bits,
        grid.bits,
        reason: 'parseMask should match the original grid bits',
      );

      // toMaskString output should be parseable
      final gridFromMask = GridFormat.parse(mask);
      expect(gridFromMask.bits, grid.bits);
    });

    test('Locked Lit Empty vs Locked Lit Blank', () {
      // Both should result in BlankCell(lockedLit)
      final grid1 = GridFormat.parse('(*)');
      final grid2 = GridFormat.parse('(.*)');

      expect(grid1.getCell(const GridPoint(0)), isA<BlankCell>());
      expect(grid1.isLocked(const GridPoint(0)), isTrue);
      expect(grid1.isLit(const GridPoint(0)), isTrue);
      expect(grid1.mechanics[0], grid2.mechanics[0]);
    });

    group('Strict Color Parsing', () {
      test('reject invalid input with trailing dots', () {
        expect(
          () => GridFormat.parse('Y3.'),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains("Unknown symbol '3.'"),
            ),
          ),
        );
      });

      test('allow lone color prefix as Diamond', () {
        final grid = GridFormat.parse('Y');
        final cell = grid.mechanics[0];
        expect(cell, isA<DiamondCell>());
        expect((cell as DiamondCell).color, CellColor.yellow);
      });

      test('allow colored symbol with no separator', () {
        final grid = GridFormat.parse('Y1');
        final cell = grid.mechanics[0];
        expect(cell, isA<NumberCell>());
        expect((cell as NumberCell).color, CellColor.yellow);
        expect(cell.number, 1);
      });

      test('allow colored diamond with o symbol', () {
        final grid = GridFormat.parse('Yo');
        final cell = grid.mechanics[0];
        expect(cell, isA<DiamondCell>());
        expect((cell as DiamondCell).color, CellColor.yellow);
      });

      test('allow colored locked Diamond in parentheses', () {
        final grid = GridFormat.parse('(Y)');
        final cell = grid.mechanics[0];
        expect(cell, isA<DiamondCell>());
        expect((cell as DiamondCell).color, CellColor.yellow);
        expect(cell.isLocked, isTrue);
      });
    });
  });
}

/// Normalizes the ASCII output for comparison by trimming lines and
/// removing extra whitespace.
String _normalizeOutput(String output) {
  return output
      .trim()
      .split('\n')
      .map((line) => line.trim().replaceAll(RegExp(r'\s+'), ' '))
      .join('\n');
}
