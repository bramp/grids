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
    final elementsByColor = <CellColor, List<GridPoint>>{};
    final colorsWithDiamonds = <CellColor>{};

    for (final pt in area) {
      final cell = puzzle.getCell(pt);

      for (final color in cell.colors) {
        elementsByColor.putIfAbsent(color, () => []).add(pt);
        if (cell is DiamondCell) {
          colorsWithDiamonds.add(color);
        }
      }
    }

    if (colorsWithDiamonds.isEmpty) {
      return ValidationResult.success();
    }

    final errors = <ValidationError>[];

    // Every color that HAS a diamond must have EXACTLY two members in the area.
    for (final color in colorsWithDiamonds) {
      final elements = elementsByColor[color]!;
      if (elements.length != 2) {
        final colorName = color.name;
        for (final pt in elements) {
          errors.add(
            ValidationError(
              pt,
              'Area with diamonds must have exactly 2 mechanics of color '
              '$colorName, but found ${elements.length}.',
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
