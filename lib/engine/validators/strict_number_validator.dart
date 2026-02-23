import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/rule_validator.dart';

/// Validates that within any contiguous area containing numbers, the size of
/// the area precisely matches the sum of all number cells in that area, and
/// that all number cells within that area share the identical color.
///
/// If there are different colors of numbers in the same area, it's invalid.
///
/// Negative numbers reduce the required area size.
/// For example, a K6 and a K-2 in the same area require a total of 4 cells.
///
/// If the sum is zero (e.g., K-2 and K2 in the same area), the area can
/// be any size. Negative sums (net negative) are never allowed.
class StrictNumberValidator extends RuleValidator {
  const StrictNumberValidator();

  @override
  ValidationResult validate(GridState grid, List<GridPoint> area) {
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

    // If there is more than 1 color, it strictly violates the NumberColor rule
    if (byColor.length > 1) {
      return ValidationResult.failure(byColor.values.expand((v) => v).toList());
    }

    // At this point we have exactly 1 color group
    final numberPoints = byColor.values.first;

    var requiredAreaSize = 0;
    for (final pt in numberPoints) {
      requiredAreaSize += (grid.getMechanic(pt) as NumberCell).number;
    }

    if (requiredAreaSize < 0) {
      // Negative regions are never allowed.
      return ValidationResult.failure(numberPoints);
    }

    if (requiredAreaSize > 0 && area.length != requiredAreaSize) {
      // Area isn't the required size; mark all number cells as errors.
      return ValidationResult.failure(numberPoints);
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
