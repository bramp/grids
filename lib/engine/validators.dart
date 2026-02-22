import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/rule_validator.dart';

/// Validates that diamonds are always part of a pair of the same color.
///
/// If an area contains at least one diamond, the entire area follows the
/// "Pairing" rule: every color present in the area must have exactly two
/// mechanics (diamonds or numbers).
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
        if (y > 0 && grid.isLit(grid.pointAt(x, y - 1)) == isLit) {
          matchingNeighbors++;
        }
        if (y < grid.height - 1 &&
            grid.isLit(grid.pointAt(x, y + 1)) == isLit) {
          matchingNeighbors++;
        }
        if (x > 0 && grid.isLit(grid.pointAt(x - 1, y)) == isLit) {
          matchingNeighbors++;
        }
        if (x < grid.width - 1 && grid.isLit(grid.pointAt(x + 1, y)) == isLit) {
          matchingNeighbors++;
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

/// Validates that all dash cells of the same color are located in identically
/// shaped contiguous areas, with the dash situated in the exact same relative
/// position within the area.
class DashValidator extends RuleValidator {
  const DashValidator();

  @override
  ValidationResult validate(GridState grid, List<GridPoint> area) {
    final areaHasDash = area.any((pt) => grid.getMechanic(pt) is DashCell);
    if (!areaHasDash) {
      return ValidationResult.success();
    }

    final errors = <GridPoint>[];
    final allAreas = grid.extractContiguousAreas();

    // Find all unique dash colors in THIS area to test
    final colorsToCheck = <CellColor>{};
    for (final pt in area) {
      final mechanic = grid.getMechanic(pt);
      if (mechanic is DashCell) {
        colorsToCheck.add(mechanic.color);
      }
    }

    for (final color in colorsToCheck) {
      // Find all dashes of this color on the ENTIRE board
      final globalDashes = <GridPoint>[];
      for (var i = 0; i < grid.mechanics.length; i++) {
        final mechanic = grid.mechanics[i];
        if (mechanic is DashCell && mechanic.color == color) {
          globalDashes.add(GridPoint(i));
        }
      }

      // If this is the only dash of its color, it trivially satisfies the rule
      if (globalDashes.length <= 1) {
        continue;
      }

      // Compute the shape of the area relative to each dash
      Set<String> getShapeStrings(GridPoint dashPt) {
        final dashArea = allAreas.firstWhere((a) => a.contains(dashPt));
        final dashX = grid.x(dashPt);
        final dashY = grid.y(dashPt);
        return dashArea.map((pt) {
          return '${grid.x(pt) - dashX},${grid.y(pt) - dashY}';
        }).toSet();
      }

      final referenceShape = getShapeStrings(globalDashes.first);
      var allMatch = true;

      for (var i = 1; i < globalDashes.length; i++) {
        final shape = getShapeStrings(globalDashes[i]);
        if (shape.length != referenceShape.length ||
            !shape.containsAll(referenceShape)) {
          allMatch = false;
          break;
        }
      }

      // If any dashes of this color don't match exactly, all dashes of this
      // color in the CURRENT area are marked as errors. (Other areas will
      // catch theirs)
      if (!allMatch) {
        errors.addAll(
          area.where((pt) {
            final mechanic = grid.getMechanic(pt);
            return mechanic is DashCell && mechanic.color == color;
          }),
        );
      }
    }

    if (errors.isNotEmpty) {
      return ValidationResult.failure(errors);
    }

    return ValidationResult.success();
  }

  @override
  bool isApplicable(GridState grid) =>
      grid.mechanics.any((cell) => cell is DashCell);
}

const dashValidator = DashValidator();
