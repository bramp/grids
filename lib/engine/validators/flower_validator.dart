import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/rule_validator.dart';

/// Validates that each flower cell has the correct number of adjacent cells
/// (up/down/left/right) matching its color.
///
/// A flower cell with `orangePetals` N must have exactly N adjacent cells
/// that share its current lit/unlit state. Cells that are off the edge of
/// the grid are ignored.
class FlowerValidator extends RuleValidator {
  const FlowerValidator();

  @override
  ValidationResult validate(Puzzle puzzle, List<GridPoint> area) {
    final errors = <ValidationError>[];

    for (final pt in area) {
      final cell = puzzle.getCell(pt);
      if (cell is FlowerCell) {
        final isLit = puzzle.isLit(pt);
        var matchingNeighbors = 0;
        final (x, y) = puzzle.xy(pt);

        // Check the 4 orthogonal neighbors
        if (y > 0) {
          final neighbor = puzzle.pointAt(x, y - 1);
          if (puzzle.isValid(neighbor) && puzzle.isLit(neighbor) == isLit) {
            matchingNeighbors++;
          }
        }
        if (y < puzzle.height - 1) {
          final neighbor = puzzle.pointAt(x, y + 1);
          if (puzzle.isValid(neighbor) && puzzle.isLit(neighbor) == isLit) {
            matchingNeighbors++;
          }
        }
        if (x > 0) {
          final neighbor = puzzle.pointAt(x - 1, y);
          if (puzzle.isValid(neighbor) && puzzle.isLit(neighbor) == isLit) {
            matchingNeighbors++;
          }
        }
        if (x < puzzle.width - 1) {
          final neighbor = puzzle.pointAt(x + 1, y);
          if (puzzle.isValid(neighbor) && puzzle.isLit(neighbor) == isLit) {
            matchingNeighbors++;
          }
        }

        if (matchingNeighbors != cell.orangePetals) {
          errors.add(
            ValidationError(
              pt,
              'Flower cell at $pt requires exactly ${cell.orangePetals} '
              'neighbors matching its ${isLit ? 'lit' : 'unlit'} state, but '
              'found $matchingNeighbors.',
            ),
          );
        }
      }
    }

    if (errors.isNotEmpty) {
      return ValidationResult.failure(errors);
    }

    return ValidationResult.success();
  }

  @override
  bool isApplicable(Puzzle puzzle) =>
      puzzle.mechanics.any((cell) => cell is FlowerCell);
}

const flowerValidator = FlowerValidator();
