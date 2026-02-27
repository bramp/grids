import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/validators.dart';

void main() {
  group('FlowerValidator', () {
    test('Flower with F0 matching 0 neighbors of same state is valid', () {
      final grid = GridFormat.parse(
        '''
        .* .* .*
        .* F0 .*
        .* .* .*
      ''',
      );
      // F0 is unlit. All neighbors are lit (*).
      // Zero neighbors share the same "unlit" state.
      // So it should be valid for F0.

      final result = flowerValidator.validate(grid, [const GridPoint(4)]);
      expect(result.isValid, isTrue);
    });

    test('Flower with F0 matching > 0 neighbors is invalid', () {
      final grid = GridFormat.parse(
        '''
        .* .  .*
        .* F0 .*
        .* .* .*
      ''',
      );
      // F0 is unlit. The top neighbor (point 1) is also unlit.
      // So 1 neighbor matches. F0 requires 0.

      final result = flowerValidator.validate(grid, [const GridPoint(4)]);
      expect(result.isValid, isFalse);
      expect(result.errors.map((e) => e.point), [const GridPoint(4)]);
    });

    test('Flower with F1 matching exactly 1 neighbor of same state', () {
      final grid = GridFormat.parse(
        '''
        .* .  .*
        .* F1 .*
        .* .* .*
      ''',
      );
      // F1 is unlit. Top neighbor is unlit. So 1 match. F1 requires 1.
      final result = flowerValidator.validate(grid, [const GridPoint(4)]);
      expect(result.isValid, isTrue);
    });

    test('Flower with F4 matching 4 neighbors of same state', () {
      final grid = GridFormat.parse(
        '''
        .  .  .
        .  F4 .
        .  .  .
      ''',
      );
      // F4 is unlit. All 4 neighbors are unlit. So 4 matches. F4 requires 4.
      final result = flowerValidator.validate(grid, [const GridPoint(4)]);
      expect(result.isValid, isTrue);
    });

    test('Lit Flower matching lit neighbors', () {
      final grid = GridFormat.parse(
        '''
        .* .* .*
        .* F4* .*
        .* .* .*
      ''',
      );
      // F4 is lit (*). All 4 neighbors are lit (*). 4 matches. Required 4.
      final result = flowerValidator.validate(grid, [const GridPoint(4)]);
      expect(result.isValid, isTrue);
    });

    test('Edges are ignored, do not count as matching', () {
      final grid = GridFormat.parse(
        '''
        F2* .*
        .*  .
      ''',
      );
      // F2 is at (0,0), lit (*).
      // Right neighbor is lit (*). Bottom neighbor is lit (*).
      // No top/left neighbors. Matches = 2. F2 requires 2.
      final result = flowerValidator.validate(grid, [const GridPoint(0)]);
      expect(result.isValid, isTrue);
    });

    test('Corners require fewer neighbors', () {
      final grid = GridFormat.parse(
        '''
        F3* .*
        .*  .
      ''',
      );
      // F3 requires 3 matching neighbors, but it is in a corner with only
      // 2 neighbors maximum. So this must fail.
      final result = flowerValidator.validate(grid, [const GridPoint(0)]);
      expect(result.isValid, isFalse);
      expect(result.errors.map((e) => e.point), [const GridPoint(0)]);
    });

    test('Void cells (missing tiles) are ignored', () {
      // Grid:
      //   x   .   x
      //   .   F2  .
      //   x   .   x
      // (1,1) has 4 neighbors: (1,0), (1,2), (0,1), (2,1).
      // But (0,0), (2,0), (0,2), (2,2) are void.
      // (1,1) neighbors are:
      // Up (1,0): Blank (.) - Match (unlit)
      // Left (0,1): Blank (.) - Match (unlit)
      // Right (2,1): Blank (.) - Match (unlit)
      // Down (1,2): Blank (.) - Match (unlit)
      // All 4 neighbors match unlit state. Matches = 4. F2 requires 2.
      // Wait, let's make it pass.
      final grid2 = GridFormat.parse(
        '''
        x   .*  x
        .*  F2  .*
        x   .   x
      ''',
      );
      // (1,1) neighbors:
      // Up (1,1) is F2 (unlit).
      // Up (1,0): .* (lit) - No Match
      // Left (0,1): .* (lit) - No Match
      // Right (2,1): .* (lit) - No Match
      // Down (1,2): . (unlit) - Match
      // Total matches = 1. F2 should fail.
      expect(
        flowerValidator.validate(grid2, [const GridPoint(4)]).isValid,
        isFalse,
      );

      final grid3 = GridFormat.parse(
        '''
        x   .*  x
        .   F2  .
        x   .   x
      ''',
      );
      // (1,1) neighbors:
      // Up (1,0): .* (lit) - No Match
      // Left (0,1): . (unlit) - Match
      // Right (2,1): . (unlit) - Match
      // Down (1,2): . (unlit) - Match
      // Total matches = 3. F2 should fail.
      expect(
        flowerValidator.validate(grid3, [const GridPoint(4)]).isValid,
        isFalse,
      );

      final grid4 = GridFormat.parse(
        '''
        x   .*  x
        .   F2  .
        x   .*  x
      ''',
      );
      // (1,1) neighbors:
      // Up (1,0): .* (lit) - No Match
      // Left (0,1): . (unlit) - Match
      // Right (2,1): . (unlit) - Match
      // Down (1,2): .* (lit) - No Match
      // Total matches = 2. F2 should pass.
      expect(
        flowerValidator.validate(grid4, [const GridPoint(4)]).isValid,
        isTrue,
      );
    });
  });
}
