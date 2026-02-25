import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
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
  ValidationResult validate(GridState grid, List<GridPoint> area) {
    final errors = <GridPoint>[];

    for (final pt in area) {
      final cell = grid.getMechanic(pt);
      if (cell is FlowerCell) {
        final isLit = grid.isLit(pt);
        var matchingNeighbors = 0;
        final x = grid.x(pt);
        final y = grid.y(pt);

        // Check the 4 orthogonal neighbors
        if (y > 0) {
          final neighbor = grid.pointAt(x, y - 1);
          if (grid.getMechanic(neighbor) is! VoidCell &&
              grid.isLit(neighbor) == isLit) {
            matchingNeighbors++;
          }
        }
        if (y < grid.height - 1) {
          final neighbor = grid.pointAt(x, y + 1);
          if (grid.getMechanic(neighbor) is! VoidCell &&
              grid.isLit(neighbor) == isLit) {
            matchingNeighbors++;
          }
        }
        if (x > 0) {
          final neighbor = grid.pointAt(x - 1, y);
          if (grid.getMechanic(neighbor) is! VoidCell &&
              grid.isLit(neighbor) == isLit) {
            matchingNeighbors++;
          }
        }
        if (x < grid.width - 1) {
          final neighbor = grid.pointAt(x + 1, y);
          if (grid.getMechanic(neighbor) is! VoidCell &&
              grid.isLit(neighbor) == isLit) {
            matchingNeighbors++;
          }
        }

        if (matchingNeighbors != cell.orangePetals) {
          errors.add(pt);
        }
      }
    }

    if (errors.isNotEmpty) {
      return ValidationResult.failure(errors);
    }

    return ValidationResult.success();
  }

  @override
  bool isApplicable(GridState grid) =>
      grid.mechanics.any((cell) => cell is FlowerCell);
}

const flowerValidator = FlowerValidator();
