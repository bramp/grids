import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/rule_validator.dart';

/// Validates that diamonds are always part of a pair of the same color.
///
/// If an area contains at least one diamond, the entire area follows the
/// "Pairing" rule: every color present in the area must have exactly two
/// mechanics (diamonds, numbers, dashes, etc.).
class DiamondValidator extends RuleValidator {
  const DiamondValidator();

  @override
  ValidationResult validate(Puzzle puzzle, List<GridPoint> area) {
    final colorMap = <CellColor, List<GridPoint>>{};
    var hasDiamond = false;

    for (final pt in area) {
      final cell = puzzle.getCell(pt);
      if (cell is DiamondCell) {
        hasDiamond = true;
      }
      for (final color in cell.colors) {
        colorMap.putIfAbsent(color, () => []).add(pt);
      }
    }

    // This rule only triggers for areas that contain at least one diamond.
    if (!hasDiamond) {
      return ValidationResult.success();
    }

    final errors = <ValidationError>[];

    // Every color present in a diamond area must have exactly two members.
    for (final entry in colorMap.entries) {
      if (entry.value.length != 2) {
        final colorName = entry.key.name;
        for (final pt in entry.value) {
          errors.add(
            ValidationError(
              pt,
              'Area with diamonds must have exactly 2 mechanics of color '
              '$colorName, but found ${entry.value.length}.',
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
      puzzle.mechanics.any((cell) => cell is DiamondCell);
}

const diamondValidator = DiamondValidator();
