import 'package:flutter_test/flutter_test.dart';

import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/puzzle_validator.dart';

import 'matchers.dart';

void main() {
  group('PuzzleValidator', () {
    test('Blank grid is instantly valid', () {
      final puzzle = Puzzle.empty(width: 3, height: 3);
      final validator = PuzzleValidator();

      expect(puzzle, isValidPuzzle(validator));
    });

    test('Complex valid puzzle combination', () {
      final puzzle = GridFormat.parse('''
        3 *  *.
        . *R *.
        . *. *R
      ''');

      final validator = PuzzleValidator();
      expect(puzzle, isValidPuzzle(validator));
    });

    test(
      'Complex invalid puzzle combination '
      '(multiple rules fail independently across areas)',
      () {
        final puzzle = GridFormat.parse('''
          R . .
          . . .
          . . 3
        '''); // By default all unlit, making an area of 9

        final validator = PuzzleValidator();
        final result = validator.validate(puzzle);

        expect(result.isValid, isFalse);
        expect(
          result.errors.map((e) => e.point),
          containsAll([
            puzzle.pointAt(0, 0), // Red diamond rule failure
            puzzle.pointAt(
              2,
              2,
            ), // Black diamond rule / number cell rule failure
          ]),
        );
      },
    );
  });
}
