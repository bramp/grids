import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/puzzle_validator.dart';
import 'package:grids/engine/validators.dart';

import '../matchers.dart';

void main() {
  group('FlowerValidator', () {
    final validator = PuzzleValidator(validators: const [flowerValidator]);

    test('Flower with F0 matching 0 neighbors of same state is valid', () {
      final puzzle = GridFormat.parse(
        '''
        .* .* .*
        .* F0 .*
        .* .* .*
      ''',
      );
      expect(puzzle, isValidPuzzle(validator));
    });

    test('Flower with F0 matching > 0 neighbors is invalid', () {
      final puzzle = GridFormat.parse(
        '''
        .* .  .*
        .* F0 .*
        .* .* .*
      ''',
      );
      final result = validator.validate(puzzle);
      expect(result.isValid, isFalse);
      expect(result.errors.map((e) => e.point), contains(const GridPoint(4)));
    });

    test('Flower with F1 matching exactly 1 neighbor of same state', () {
      final puzzle = GridFormat.parse(
        '''
        .* .  .*
        .* F1 .*
        .* .* .*
      ''',
      );
      expect(puzzle, isValidPuzzle(validator));
    });

    test('Flower with F4 matching 4 neighbors of same state', () {
      final puzzle = GridFormat.parse(
        '''
        .  .  .
        .  F4 .
        .  .  .
      ''',
      );
      expect(puzzle, isValidPuzzle(validator));
    });

    test('Lit Flower matching lit neighbors', () {
      final puzzle = GridFormat.parse(
        '''
        .* .* .*
        .* F4* .*
        .* .* .*
      ''',
      );
      expect(puzzle, isValidPuzzle(validator));
    });

    test('Edges are ignored, do not count as matching', () {
      final puzzle = GridFormat.parse(
        '''
        F2* .*
        .*  .
      ''',
      );

      expect(puzzle, isValidPuzzle(validator));
    });

    test('Flower requiring more matches than available neighbors fails', () {
      final puzzle = GridFormat.parse(
        '''
        F3* .*
        .*  .
      ''',
      );

      final result = validator.validate(puzzle);
      expect(result.isValid, isFalse);
      expect(result.errors.map((e) => e.point), contains(const GridPoint(0)));
    });

    test('Void cells (missing tiles) are ignored', () {
      final grid1 = GridFormat.parse(
        '''
        .   x   .
        .*  F2  .*
        .   x   .
      ''',
      );

      expect(validator.validate(grid1).isValid, isFalse);

      final grid2 = GridFormat.parse(
        '''
        .   x   .
        .*  F0  .*
        .   x   .
      ''',
      );

      expect(grid2, isValidPuzzle(validator));

      final grid3 = GridFormat.parse(
        '''
        .   .   .
        x   F2  x
        .   .   .
      ''',
      );

      expect(grid3, isValidPuzzle(validator));
    });
  });
}
