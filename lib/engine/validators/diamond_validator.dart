import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/rule_validator.dart';

/// Validates that diamonds are always part of a pair of the same color.
///
/// If an area contains at least one diamond, the entire area follows the
/// "Pairing" rule: every color present in the area must have exactly two
/// mechanics (diamonds, numbers, dashes, etc.).
class DiamondValidator extends RuleValidator {
  const DiamondValidator();

  @override
  ValidationResult validate(GridState grid, List<GridPoint> area) {
    final colorMap = <CellColor, List<GridPoint>>{};
    var hasDiamond = false;

    for (final pt in area) {
      final cell = grid.getMechanic(pt);
      if (cell is DiamondCell) {
        hasDiamond = true;
        colorMap.putIfAbsent(cell.color, () => []).add(pt);
      } else if (cell is NumberCell) {
        colorMap.putIfAbsent(cell.color, () => []).add(pt);
      } else if (cell is DashCell) {
        colorMap.putIfAbsent(cell.color, () => []).add(pt);
      } else if (cell is DiagonalDashCell) {
        colorMap.putIfAbsent(cell.color, () => []).add(pt);
      } else if (cell is FlowerCell) {
        // A flower can be considered orange and purple for matching purposes
        // in diamond pairing areas.
        if (cell.orangePetals > 0) {
          colorMap.putIfAbsent(CellColor.orange, () => []).add(pt);
        }
        if (cell.purplePetals > 0) {
          colorMap.putIfAbsent(CellColor.purple, () => []).add(pt);
        }
      }
    }

    // This rule only triggers for areas that contain at least one diamond.
    if (!hasDiamond) {
      return ValidationResult.success();
    }

    final errors = <GridPoint>[];

    // Every color present in a diamond area must have exactly two members.
    for (final entry in colorMap.entries) {
      if (entry.value.length != 2) {
        errors.addAll(entry.value);
      }
    }

    if (errors.isNotEmpty) {
      return ValidationResult.failure(errors);
    }

    return ValidationResult.success();
  }

  @override
  bool isApplicable(GridState grid) =>
      grid.mechanics.any((cell) => cell is DiamondCell);
}

const diamondValidator = DiamondValidator();
