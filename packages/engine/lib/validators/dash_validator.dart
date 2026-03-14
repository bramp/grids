import 'package:grids_engine/cell.dart';
import 'package:grids_engine/grid_point.dart';
import 'package:grids_engine/grid_shape.dart';
import 'package:grids_engine/puzzle.dart';
import 'package:grids_engine/rule_validator.dart';

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
    final allGridAreas = puzzle
        .extractContiguousAreas()
        .map<GridArea>(GridArea.new)
        .toList();

    // Find all unique dash colors in THIS area to test
    final colorsToCheck = <CellColor>{};
    for (final pt in area) {
      final mechanic = puzzle.getCell(pt);
      if ((mechanic is DashCell || mechanic is DiagonalDashCell) &&
          mechanic.color != null) {
        colorsToCheck.add(mechanic.color!);
      }
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

    GridShape getShape(GridPoint pt) {
      final area = allGridAreas.firstWhere((a) => a.contains(pt));
      return area.toShape(pt, puzzle);
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
        signaturesByColor[boardColor] = shape.rotations
            .map((s) => s.signature)
            .toSet();
      } else {
        signaturesByColor[boardColor] = {shape.signature};
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

      var internalMatch = true;
      for (final pt in globalDashes) {
        final sig = getShape(pt).signature;
        final mechanic = puzzle.getCell(pt);
        if (mechanic is DashCell) {
          final refSig = getShape(globalDashes.first).signature;
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
