import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/cell.dart';
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
      final state = GridState.empty(width: 3, height: 3);
      var grid = state
          .toggle(state.pointAt(1, 0))
          .toggle(state.pointAt(2, 0))
          .toggle(state.pointAt(1, 1))
          .toggle(state.pointAt(2, 1))
          .toggle(state.pointAt(1, 2))
          .toggle(state.pointAt(2, 2));

      grid = grid
          // A number '3' inside the unlit column (size 3)
          .withMechanic(state.pointAt(0, 0), const NumberCell(3))
          // Two red diamonds in the lit area (size 6)
          .withMechanic(state.pointAt(1, 1), const DiamondCell(CellColor.red))
          .withMechanic(
            state.pointAt(2, 2),
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
        final state = GridState.empty(width: 3, height: 3);
        final grid = state
            // Fails: One single red diamond.
            // Under new pairing rules, since a diamond exists in the area,
            // ALL colors in the area (Red and Black) must be pairs.
            .withMechanic(
              state.pointAt(0, 0),
              const DiamondCell(CellColor.red),
            )
            // Fails:
            // 1. Diamond rule: Black color (from NumberCell) is not a pair.
            // 2. Number rule: Tries to be a '3' block but is in an area of 9.
            .withMechanic(state.pointAt(2, 2), const NumberCell(3));

        final puzzle = PuzzleValidator();
        final result = puzzle.validate(grid);

        expect(result.isValid, isFalse);
        expect(
          result.errors,
          containsAll([state.pointAt(0, 0), state.pointAt(2, 2)]),
        );
      },
    );
  });
}
