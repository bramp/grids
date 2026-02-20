import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/puzzle_validator.dart';

void main() {
  group('PuzzleValidator', () {
    test('Blank grid is instantly valid', () {
      final grid = GridState.empty(width: 3, height: 3);
      final puzzle = PuzzleValidator();

      final result = puzzle.validate(grid);
      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('Complex valid puzzle combination', () {
      // Let's create a 3x3 grid.
      // We'll leave the left column (0,y) unlit.
      // We'll light the middle column (1,y) and right column (2,y).
      // Left column is area size 3. Middle/Right is area size 6.
      var grid = GridState.empty(width: 3, height: 3)
          .toggle(const GridPoint(1, 0))
          .toggle(const GridPoint(2, 0))
          .toggle(const GridPoint(1, 1))
          .toggle(const GridPoint(2, 1))
          .toggle(const GridPoint(1, 2))
          .toggle(const GridPoint(2, 2));

      grid = grid
          // A number '3' inside the unlit column (size 3)
          .withMechanic(const GridPoint(0, 0), const NumberCell(3))
          // Two red diamonds in the lit area (size 6)
          .withMechanic(const GridPoint(1, 1), const DiamondCell(CellColor.red))
          .withMechanic(
            const GridPoint(2, 2),
            const DiamondCell(CellColor.red),
          );

      final puzzle = PuzzleValidator();
      final result = puzzle.validate(grid);

      expect(result.isValid, isTrue);
    });

    test(
      'Complex invalid puzzle combination '
      '(multiple rules fail independently across areas)',
      () {
        // Create a totally blank 3x3 grid (1 unlit area of size 9)
        final grid = GridState.empty(width: 3, height: 3)
            // Fails: One single black diamond
            .withMechanic(
              const GridPoint(0, 0),
              const DiamondCell(CellColor.black),
            )
            // Fails: Tries to be a '3' block but is in an area of 9
            .withMechanic(const GridPoint(2, 2), const NumberCell(3));

        final puzzle = PuzzleValidator();
        final result = puzzle.validate(grid);

        expect(result.isValid, isFalse);
        expect(
          result.errors,
          containsAll([const GridPoint(0, 0), const GridPoint(2, 2)]),
        );
      },
    );
  });
}
