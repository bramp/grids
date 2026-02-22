import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/rule_validator.dart';

/// Validates that within any contiguous area, there must be exactly two
/// diamonds of the same color (or zero diamonds for a given color).
ValidationResult diamondValidator(GridState grid, List<GridPoint> area) {
  // Collect all diamond cells within this specific area, mapped by color.
  final colorMap = <CellColor, List<GridPoint>>{};

  for (final pt in area) {
    final cell = grid.getMechanic(pt);
    if (cell is DiamondCell) {
      colorMap.putIfAbsent(cell.color, () => []).add(pt);
    }
  }

  final errors = <GridPoint>[];

  // For every color present in this area, there MUST be exactly TWO diamonds
  for (final entry in colorMap.entries) {
    final colorPts = entry.value;
    if (colorPts.length != 2) {
      errors.addAll(colorPts);
    }
  }

  if (errors.isNotEmpty) {
    return ValidationResult.failure(errors);
  }

  return ValidationResult.success();
}

/// Validates that within any contiguous area containing numbers, the size of
/// the area precisely matches the sum of all number cells of the same color.
///
/// Negative numbers reduce the required area size for their color group.
/// For example, a K6 and a K-2 in the same area require a total of 4 cells.
///
/// Each distinct color group is validated independently. All number cells
/// in the area (across all colors) must sum to the area's actual size.
// TODO(bramp): Decide if a lone negative number (e.g. K-2 alone in an area)
// is valid. It would imply a required size of -2, which is impossible.
// Current behaviour: treated as invalid (required size <= 0 fails).
ValidationResult strictNumberValidator(GridState grid, List<GridPoint> area) {
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
  // Negative numbers within a color group reduce the total.
  var requiredAreaSize = 0;
  final errors = <GridPoint>[];

  for (final entry in byColor.entries) {
    var colorSum = 0;
    for (final pt in entry.value) {
      colorSum += (grid.getMechanic(pt) as NumberCell).number;
    }
    // TODO(bramp): Decide if a net-negative color group (e.g. only K-2)
    // should be an immediate error or contribute a negative to the total.
    requiredAreaSize += colorSum;
  }

  if (area.length != requiredAreaSize) {
    // The total area isn't the required size; mark all number cells as errors.
    byColor.values.forEach(errors.addAll);
    return ValidationResult.failure(errors);
  }

  return ValidationResult.success();
}

/// Validates that within any contiguous area containing numbers, all numbers
/// must share the identical color (including null).
ValidationResult numberColorValidator(GridState grid, List<GridPoint> area) {
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
