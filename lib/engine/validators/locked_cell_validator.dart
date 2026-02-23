import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/rule_validator.dart';

/// Validates that no locked cell has been toggled from its original state.
class LockedCellValidator extends RuleValidator {
  const LockedCellValidator();

  @override
  ValidationResult validate(GridState grid, List<GridPoint> area) {
    final errors = <GridPoint>[];

    for (final pt in area) {
      final cell = grid.getMechanic(pt);
      if (cell.isLocked) {
        // If the cell is locked, it must match its intended lit state.
        if (grid.isLit(pt) != cell.lockedLit) {
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
      grid.mechanics.any((cell) => cell.isLocked);
}

const lockedCellValidator = LockedCellValidator();
