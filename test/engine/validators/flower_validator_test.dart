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
      expect(result.errors, [const GridPoint(4)]);
    });

    test('Flower with F1 matching exactly 1 neighbor', () {
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

    test('Flower with F4 matching 4 neighbors', () {
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
      expect(result.errors, [const GridPoint(0)]);
    });
  });
}
