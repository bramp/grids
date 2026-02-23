import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/rule_validator.dart';

/// Validates that within any contiguous area containing numbers, the size of
/// the area precisely matches the sum of all number cells of the same color.
///
/// Negative numbers reduce the required area size for their color group.
/// For example, a K6 and a K-2 in the same area require a total of 4 cells.
///
/// Each distinct color group is validated independently. All number cells
/// in the area (across all colors) must sum to the area's actual size.
///
/// If the sum is zero (e.g., K-2 and K2 in the same area), the area can
/// be any size. Negative sums (net negative) are never allowed.
class StrictNumberValidator extends RuleValidator {
  const StrictNumberValidator();

  @override
  ValidationResult validate(GridState grid, List<GridPoint> area) {
    // Collect all number cells within this specific area, grouped by color.
    final byColor = <CellColor, List<GridPoint>>{};

    for (final pt in area) {
      final cell = grid.getMechanic(pt);
      if (cell is NumberCell) {
        byColor.putIfAbsent(cell.color, () => []).add(pt);
      }
    }

    // If no number cells at all, the area is automatically valid.
    if (byColor.isEmpty) {
      return ValidationResult.success();
    }

    // Sum all numbers across all color groups to get the required area size.
    var requiredAreaSize = 0;
    final errors = <GridPoint>[];

    for (final entry in byColor.entries) {
      var colorSum = 0;
      for (final pt in entry.value) {
        colorSum += (grid.getMechanic(pt) as NumberCell).number;
      }
      requiredAreaSize += colorSum;
    }

    if (requiredAreaSize < 0) {
      // Negative regions are never allowed.
      byColor.values.forEach(errors.addAll);
      return ValidationResult.failure(errors);
    }

    if (requiredAreaSize > 0 && area.length != requiredAreaSize) {
      // Area isn't the required size; mark all number cells as errors.
      byColor.values.forEach(errors.addAll);
      return ValidationResult.failure(errors);
    }

    // If requiredAreaSize == 0, the sum of negative and positive is zero.
    // In this case, the area can be any size.
    return ValidationResult.success();
  }

  @override
  bool isApplicable(GridState grid) =>
      grid.mechanics.any((cell) => cell is NumberCell);
}

const strictNumberValidator = StrictNumberValidator();
