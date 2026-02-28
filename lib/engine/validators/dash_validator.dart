import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/rule_validator.dart';

/// Validates that all dash cells of the same color are located in identically
/// shaped contiguous areas, with the dash situated in the exact same relative
/// position within the area.
class DashValidator extends RuleValidator {
  const DashValidator();

  @override
  ValidationResult validate(Puzzle puzzle, List<GridPoint> area) {
    final areaHasDash = area.any((pt) {
      final mechanic = puzzle.getCell(pt);
      return mechanic is DashCell || mechanic is DiagonalDashCell;
    });

    if (!areaHasDash) {
      return ValidationResult.success();
    }

    final errors = <ValidationError>[];
    final allAreas = puzzle.extractContiguousAreas();

    // Find all unique dash colors in THIS area to test
    final colorsToCheck = <CellColor>{};
    for (final pt in area) {
      final mechanic = puzzle.getCell(pt);
      if ((mechanic is DashCell || mechanic is DiagonalDashCell) &&
          mechanic.color != null) {
        colorsToCheck.add(mechanic.color!);
      }
    }

    // Helper functions for shape comparison
    // TODO(bramp): Should this be a Set<GridPoint> ?
    Set<(int, int)> getShape(GridPoint dashPt) {
      final dashArea = allAreas.firstWhere((a) => a.contains(dashPt));
      final (dashX, dashY) = puzzle.xy(dashPt);
      return dashArea.map((pt) {
        final (x, y) = puzzle.xy(pt);
        return (x - dashX, y - dashY);
      }).toSet();
    }

    String canonicalize(Set<(int, int)> shape) {
      final list = shape.toList()
        ..sort((a, b) {
          if (a.$1 != b.$1) return a.$1.compareTo(b.$1);
          return a.$2.compareTo(b.$2);
        });
      return list.map((p) => '${p.$1},${p.$2}').join(';');
    }

    List<Set<(int, int)>> getRotations(Set<(int, int)> shape) {
      final result = <Set<(int, int)>>[];
      var current = shape;
      for (var i = 0; i < 4; i++) {
        result.add(current);
        // Rotate 90 degrees clockwise: (x, y) -> (-y, x)
        current = current.map((p) => (-p.$2, p.$1)).toSet();
      }
      return result;
    }

    // Check for different color dash matches
    final allColorsOnBoard = <CellColor>{};
    for (var i = 0; i < puzzle.mechanics.length; i++) {
      final mechanic = puzzle.mechanics[i];
      if ((mechanic is DashCell || mechanic is DiagonalDashCell) &&
          mechanic.color != null) {
        allColorsOnBoard.add(mechanic.color!);
      }
    }

    // Pre-calculate signatures for all colors on the board
    final signaturesByColor = <CellColor, Set<String>>{};
    for (final boardColor in allColorsOnBoard) {
      final dashesOfColor = <GridPoint>[];
      var isDiagonal = false;
      for (var i = 0; i < puzzle.mechanics.length; i++) {
        final mechanic = puzzle.mechanics[i];
        if ((mechanic is DashCell || mechanic is DiagonalDashCell) &&
            mechanic.color == boardColor) {
          dashesOfColor.add(GridPoint(i));
          if (mechanic is DiagonalDashCell) isDiagonal = true;
        }
      }

      if (dashesOfColor.isEmpty) continue;

      final shape = getShape(dashesOfColor.first);
      if (isDiagonal) {
        signaturesByColor[boardColor] = getRotations(
          shape,
        ).map(canonicalize).toSet();
      } else {
        signaturesByColor[boardColor] = {canonicalize(shape)};
      }
    }

    for (final color in colorsToCheck) {
      // 1. Existing rule: Same-colored dashes must match
      final globalDashes = <GridPoint>[];
      for (var i = 0; i < puzzle.mechanics.length; i++) {
        final mechanic = puzzle.mechanics[i];
        if ((mechanic is DashCell || mechanic is DiagonalDashCell) &&
            mechanic.color == color) {
          globalDashes.add(GridPoint(i));
        }
      }

      if (globalDashes.isEmpty) continue;

      // Check if all dashes of THIS color match each other
      final allowedSigs = signaturesByColor[color]!;
      // Note: If color has both, the first type found by getShape in pre-calc
      // wins as the reference. But existing code already enforces consistency.

      var internalMatch = true;
      for (final pt in globalDashes) {
        final sig = canonicalize(getShape(pt));
        final mechanic = puzzle.getCell(pt);
        if (mechanic is DashCell) {
          // Strict dashes MUST match the specific orientation of the reference
          // (which for simplicity we take as the first one of its color)
          final refSig = canonicalize(getShape(globalDashes.first));
          if (sig != refSig) {
            internalMatch = false;
            break;
          }
        } else if (mechanic is DiagonalDashCell) {
          if (!allowedSigs.contains(sig)) {
            internalMatch = false;
            break;
          }
        }
      }

      if (!internalMatch) {
        final invalidDashes = area.where((pt) {
          final mechanic = puzzle.getCell(pt);
          return (mechanic is DashCell || mechanic is DiagonalDashCell) &&
              mechanic.color == color;
        });
        for (final pt in invalidDashes) {
          errors.add(
            ValidationError(
              pt,
              'Dash area shape or relative position does not match '
              'other dashes of color ${color.name}.',
            ),
          );
        }
        continue;
      }

      // 2. New rule: Different colored dashes must NOT match
      final mySigs = signaturesByColor[color]!;
      for (final otherColor in allColorsOnBoard) {
        if (otherColor == color) continue;

        final otherSigs = signaturesByColor[otherColor]!;
        final intersection = mySigs.intersection(otherSigs);

        if (intersection.isNotEmpty) {
          final invalidDashes = area.where((pt) {
            final mechanic = puzzle.getCell(pt);
            return (mechanic is DashCell || mechanic is DiagonalDashCell) &&
                mechanic.color == color;
          });
          for (final pt in invalidDashes) {
            errors.add(
              ValidationError(
                pt,
                'Dash area for color ${color.name} matches '
                'dash area for color ${otherColor.name}. '
                'Areas of different colored dashes must not match.',
              ),
            );
          }
          break; // Found one matching color, that's enough for an error
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
      puzzle.mechanics.any((c) => c is DashCell || c is DiagonalDashCell);
}

const dashValidator = DashValidator();
