import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/rule_validator.dart';

/// Validates that within any contiguous area containing numbers, all numbers
/// must share the identical color (including null).
class NumberColorValidator extends RuleValidator {
  const NumberColorValidator();

  @override
  ValidationResult validate(GridState grid, List<GridPoint> area) {
    final numberPoints = <GridPoint>[];
    final colors = <CellColor?>{};

    for (final pt in area) {
      final cell = grid.getMechanic(pt);
      if (cell is NumberCell) {
        numberPoints.add(pt);
        colors.add(cell.color);
      }
    }

    // If there are different colors (or color + null) in the same area, it's an
    // error.
    if (colors.length > 1) {
      return ValidationResult.failure(numberPoints);
    }

    return ValidationResult.success();
  }

  @override
  bool isApplicable(GridState grid) =>
      grid.mechanics.any((cell) => cell is NumberCell);
}

const numberColorValidator = NumberColorValidator();
