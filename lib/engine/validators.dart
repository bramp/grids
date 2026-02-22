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
/// the area precisely matches the sum of all number cells inside it.
ValidationResult strictNumberValidator(GridState grid, List<GridPoint> area) {
  // Collect all number cells within this specific area.
  final numbers = <GridPoint>[];

  for (final pt in area) {
    final cell = grid.getMechanic(pt);
    if (cell is NumberCell) {
      numbers.add(pt);
    }
  }

  // If there are no number cells at all in this area, it is automatically
  // valid.
  if (numbers.isEmpty) {
    return ValidationResult.success();
  }

  // Sum up the numbers requested.
  var requiredAreaSize = 0;
  for (final pt in numbers) {
    final cell = grid.getMechanic(pt) as NumberCell;
    requiredAreaSize += cell.number;
  }

  if (area.length != requiredAreaSize) {
    // The total area isn't the required size; all number blocks are wrong.
    return ValidationResult.failure(numbers);
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
