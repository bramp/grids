import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/rule_validator.dart';

/// Validates that no locked cell has been toggled from its original state.
///
/// This is really to catch UI / Testing bugs.
class LockedCellValidator extends RuleValidator {
  const LockedCellValidator();

  @override
  ValidationResult validate(Puzzle puzzle, List<GridPoint> area) {
    final errors = <ValidationError>[];

    for (final pt in area) {
      final cell = puzzle.getCell(pt);
      if (cell.isLocked) {
        // If the cell is locked, it must match its intended lit state.
        if (puzzle.isLit(pt) != cell.lockedLit!) {
          errors.add(
            ValidationError(
              pt,
              'Locked cell at $pt must be '
              '${cell.lockedLit == true ? 'lit' : 'unlit'}.',
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
      puzzle.mechanics.any((cell) => cell.isLocked);
}

const lockedCellValidator = LockedCellValidator();
