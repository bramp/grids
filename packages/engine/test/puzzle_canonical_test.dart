import 'package:grids_engine/cell.dart';
import 'package:grids_engine/grid_format.dart';
import 'package:grids_engine/grid_point.dart';
import 'package:grids_engine/puzzle_canonical.dart';
import 'package:test/test.dart';

void main() {
  group('PuzzleCanonical.rotate', () {
    test('rotate 0 returns identical puzzle', () {
      final p = GridFormat.parse('''
        . Ro
        . .
      ''');
      final r = PuzzleCanonical.rotate(p, 0);
      expect(r, equals(p));
    });

    test('rotate 4 returns identical puzzle', () {
      final p = GridFormat.parse('''
        . Ro
        . .
      ''');
      final r = PuzzleCanonical.rotate(p, 4);
      expect(r.grid, equals(p.grid));
      expect(r.state, equals(p.state));
    });

    test('rotate 1 (90° CW) on 2x2', () {
      // Original:
      //   A B
      //   C D
      //
      // 90° CW:
      //   C A
      //   D B
      final p = GridFormat.parse('''
        Ro Bo
        Ko Yo
      ''');
      final r = PuzzleCanonical.rotate(p, 1);

      expect(r.width, 2);
      expect(r.height, 2);

      // (0,0) should be what was at (0,1) = Ko
      expect(r.getCell(const GridPoint(0)), isA<DiamondCell>());
      expect(
        (r.getCell(const GridPoint(0)) as DiamondCell).color,
        CellColor.black,
      );

      // (1,0) should be what was at (0,0) = Ro
      expect(
        (r.getCell(const GridPoint(1)) as DiamondCell).color,
        CellColor.red,
      );

      // (0,1) should be what was at (1,1) = Yo
      expect(
        (r.getCell(const GridPoint(2)) as DiamondCell).color,
        CellColor.yellow,
      );

      // (1,1) should be what was at (1,0) = Bo
      expect(
        (r.getCell(const GridPoint(3)) as DiamondCell).color,
        CellColor.blue,
      );
    });

    test('rotate 2 (180°) on 2x2', () {
      // Original:
      //   A B
      //   C D
      //
      // 180°:
      //   D C
      //   B A
      final p = GridFormat.parse('''
        Ro Bo
        Ko Yo
      ''');
      final r = PuzzleCanonical.rotate(p, 2);

      expect(r.width, 2);
      expect(r.height, 2);
      expect(
        (r.getCell(const GridPoint(0)) as DiamondCell).color,
        CellColor.yellow,
      );
      expect(
        (r.getCell(const GridPoint(1)) as DiamondCell).color,
        CellColor.black,
      );
      expect(
        (r.getCell(const GridPoint(2)) as DiamondCell).color,
        CellColor.blue,
      );
      expect(
        (r.getCell(const GridPoint(3)) as DiamondCell).color,
        CellColor.red,
      );
    });

    test('rotate preserves lit state', () {
      final p = GridFormat.parse('''
        *. .
         . .
      ''');
      expect(p.isLit(const GridPoint(0)), isTrue);

      final r = PuzzleCanonical.rotate(p, 1);
      // (0,0) was lit. After 90° CW on 2x2: (0,0)→(1,0)
      expect(r.isLit(const GridPoint(0)), isFalse);
      expect(r.isLit(const GridPoint(1)), isTrue);
    });

    test('rotate rectangular grid swaps dimensions', () {
      final p = GridFormat.parse('''
        . . .
        . . .
      ''');
      expect(p.width, 3);
      expect(p.height, 2);

      final r = PuzzleCanonical.rotate(p, 1);
      expect(r.width, 2);
      expect(r.height, 3);
    });
  });

  group('PuzzleCanonical.signature', () {
    test('identical puzzles have same signature', () {
      final a = GridFormat.parse('''
        . Ro
        . .
      ''');
      final b = GridFormat.parse('''
        . Ro
        . .
      ''');
      expect(
        PuzzleCanonical.signature(a),
        equals(PuzzleCanonical.signature(b)),
      );
    });

    test('rotated puzzles have same signature', () {
      // Original:
      //   .  Ro
      //   .   .
      final original = GridFormat.parse('''
        . Ro
        . .
      ''');

      // 90° CW rotation:
      //   .  .
      //   Ro .
      final rotated90 = GridFormat.parse('''
        . .
        Ro .
      ''');

      expect(
        PuzzleCanonical.signature(original),
        equals(PuzzleCanonical.signature(rotated90)),
      );

      // The manually constructed 180° is actually:
      //   .   .
      //   Ro  .
      // Real 180° of original is:
      //   .   .
      //   Ro  .
      final actualRotated180 = PuzzleCanonical.rotate(original, 2);
      expect(
        PuzzleCanonical.signature(original),
        equals(PuzzleCanonical.signature(actualRotated180)),
      );
    });

    test('all four rotations have same signature', () {
      final p = GridFormat.parse('''
        Ro . Bo
        .  . .
      ''');

      final sigs = [
        for (var r = 0; r < 4; r++)
          PuzzleCanonical.signature(PuzzleCanonical.rotate(p, r)),
      ];

      expect(sigs[1], equals(sigs[0]));
      expect(sigs[2], equals(sigs[0]));
      expect(sigs[3], equals(sigs[0]));
    });

    test('color-swapped puzzles have same signature', () {
      final allRed = GridFormat.parse('''
        Ro Ro
        .  .
      ''');
      final allBlue = GridFormat.parse('''
        Bo Bo
        .  .
      ''');
      expect(
        PuzzleCanonical.signature(allRed),
        equals(PuzzleCanonical.signature(allBlue)),
      );
    });

    test('multi-color swap produces same signature', () {
      // Puzzle with red and blue diamonds
      final rb = GridFormat.parse('''
        Ro Bo
        Bo Ro
      ''');
      // Same structure but green and yellow
      final gy = GridFormat.parse('''
        Go Yo
        Yo Go
      ''');
      expect(
        PuzzleCanonical.signature(rb),
        equals(PuzzleCanonical.signature(gy)),
      );
    });

    test('different structure produces different signature', () {
      final a = GridFormat.parse('''
        Ro .
        .  .
      ''');
      final c = GridFormat.parse('''
        Ro Ro
        .  .
      ''');
      // a has one diamond, c has two — must differ
      expect(
        PuzzleCanonical.signature(a),
        isNot(equals(PuzzleCanonical.signature(c))),
      );
    });

    test('flower petal swap with color swap produces same signature', () {
      // 3 yellow, 1 purple
      final a = GridFormat.parse('''
        F3
      ''');
      // 1 yellow, 3 purple (equivalent under yellow↔purple swap)
      final b = GridFormat.parse('''
        F1
      ''');
      expect(
        PuzzleCanonical.signature(a),
        equals(PuzzleCanonical.signature(b)),
      );
    });

    test('flower with same petal count but different structure differs', () {
      // F3 next to a yellow diamond
      final a = GridFormat.parse('''
        F3 Yo
      ''');
      // F3 next to a purple diamond — different relationship
      // because the 3-petal color matches the diamond in (a) but not (b)
      final b = GridFormat.parse('''
        F3 Po
      ''');
      // After normalization: in (a), yellow→0 (from F3's 3 yellow), purple→1,
      // and diamond has same color (0) as majority petals.
      // In (b), yellow→0, purple→1, diamond is color 1 (minority petals).
      // So they should differ.
      expect(
        PuzzleCanonical.signature(a),
        isNot(equals(PuzzleCanonical.signature(b))),
      );

      // But F3 + Yo should equal F1 + Po (swap yellow↔purple in both)
      final c = GridFormat.parse('''
        F1 Po
      ''');
      expect(
        PuzzleCanonical.signature(a),
        equals(PuzzleCanonical.signature(c)),
      );
    });

    test('locked cells are distinguished', () {
      final unlocked = GridFormat.parse('''
        .  Ro
      ''');
      final locked = GridFormat.parse('''
        . (Ro)
      ''');
      expect(
        PuzzleCanonical.signature(unlocked),
        isNot(equals(PuzzleCanonical.signature(locked))),
      );
    });

    test('lit state is distinguished', () {
      final unlit = GridFormat.parse('''
        . .
      ''');
      final lit = GridFormat.parse('''
        *. .
      ''');
      expect(
        PuzzleCanonical.signature(unlit),
        isNot(equals(PuzzleCanonical.signature(lit))),
      );
    });

    test('number cells preserve number but normalize color', () {
      final redThree = GridFormat.parse('''
        R3
      ''');
      final blueThree = GridFormat.parse('''
        B3
      ''');
      final redFour = GridFormat.parse('''
        R4
      ''');
      expect(
        PuzzleCanonical.signature(redThree),
        equals(PuzzleCanonical.signature(blueThree)),
      );
      expect(
        PuzzleCanonical.signature(redThree),
        isNot(equals(PuzzleCanonical.signature(redFour))),
      );
    });

    test('dash cells normalize color', () {
      final redDash = GridFormat.parse('''
        R-
      ''');
      final blueDash = GridFormat.parse('''
        B-
      ''');
      expect(
        PuzzleCanonical.signature(redDash),
        equals(PuzzleCanonical.signature(blueDash)),
      );
    });

    test('diagonal dash cells normalize color', () {
      final redDiag = GridFormat.parse('''
        R/
      ''');
      final blueDiag = GridFormat.parse('''
        B/
      ''');
      expect(
        PuzzleCanonical.signature(redDiag),
        equals(PuzzleCanonical.signature(blueDiag)),
      );
    });

    test('void cells are preserved', () {
      final a = GridFormat.parse('''
        x .
        . .
      ''');
      final b = GridFormat.parse('''
        . .
        . .
      ''');
      expect(
        PuzzleCanonical.signature(a),
        isNot(equals(PuzzleCanonical.signature(b))),
      );
    });

    test('blank-only puzzle: all rotations match', () {
      final p = GridFormat.parse('''
        . . .
        . . .
        . . .
      ''');
      final sig = PuzzleCanonical.signature(p);
      for (var r = 1; r < 4; r++) {
        expect(
          PuzzleCanonical.signature(PuzzleCanonical.rotate(p, r)),
          equals(sig),
        );
      }
    });

    test('rotation + color swap combined', () {
      // Red diamond at top-left
      final a = GridFormat.parse('''
        Ro .
        .  .
      ''');
      // Blue diamond at bottom-right (180° rotation + red→blue)
      final b = GridFormat.parse('''
        .  .
        .  Bo
      ''');
      expect(
        PuzzleCanonical.signature(a),
        equals(PuzzleCanonical.signature(b)),
      );
    });

    test('1x1 puzzle', () {
      final a = GridFormat.parse('Ro');
      final b = GridFormat.parse('Bo');
      expect(
        PuzzleCanonical.signature(a),
        equals(PuzzleCanonical.signature(b)),
      );
    });
  });
}
