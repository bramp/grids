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
      final mechanic = puzzle.getMechanic(pt);
      return mechanic is DashCell || mechanic is DiagonalDashCell;
    });

    if (!areaHasDash) {
      return ValidationResult.success();
    }

    final errors = <GridPoint>[];
    final allAreas = puzzle.extractContiguousAreas();

    // Find all unique dash colors in THIS area to test
    final colorsToCheck = <CellColor>{};
    for (final pt in area) {
      final mechanic = puzzle.getMechanic(pt);
      if (mechanic is DashCell) {
        colorsToCheck.add(mechanic.color);
      } else if (mechanic is DiagonalDashCell) {
        colorsToCheck.add(mechanic.color);
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

    for (final color in colorsToCheck) {
      // Find all dashes of this color on the ENTIRE board
      final globalDashes = <GridPoint>[];
      for (var i = 0; i < puzzle.mechanics.length; i++) {
        final mechanic = puzzle.mechanics[i];
        if ((mechanic is DashCell && mechanic.color == color) ||
            (mechanic is DiagonalDashCell && mechanic.color == color)) {
          globalDashes.add(GridPoint(i));
        }
      }

      // If this is the only dash of its color, it trivially satisfies the rule
      if (globalDashes.length <= 1) continue;

      // Find the reference shape.
      // If there are strict dashes (-), the first one becomes the absolute
      // reference. Its rotations are allowed ONLY for DiagonalDashCells.
      // If there are only DiagonalDashCells, any can be the reference,
      // and all must match one of its rotations.
      GridPoint? strictRefPt;
      GridPoint? diagRefPt;
      for (final pt in globalDashes) {
        if (puzzle.getMechanic(pt) is DashCell) {
          strictRefPt ??= pt;
        } else {
          diagRefPt ??= pt;
        }
      }

      final refPt = strictRefPt ?? diagRefPt!;
      final refShape = getShape(refPt);
      final strictSig = canonicalize(refShape);

      final allowedDiagSigs = getRotations(
        refShape,
      ).map(canonicalize).toSet();

      var allMatch = true;
      for (final pt in globalDashes) {
        final shape = getShape(pt);
        final sig = canonicalize(shape);
        final mechanic = puzzle.getMechanic(pt);
        if (mechanic is DashCell) {
          if (sig != strictSig) {
            allMatch = false;
            break;
          }
        } else if (mechanic is DiagonalDashCell) {
          if (!allowedDiagSigs.contains(sig)) {
            allMatch = false;
            break;
          }
        }
      }

      // If any dashes of this color don't match exactly, all dashes of this
      // color in the CURRENT area are marked as errors. (Other areas will
      // catch theirs)
      if (!allMatch) {
        errors.addAll(
          area.where((pt) {
            final mechanic = puzzle.getMechanic(pt);
            return (mechanic is DashCell && mechanic.color == color) ||
                (mechanic is DiagonalDashCell && mechanic.color == color);
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
  bool isApplicable(Puzzle puzzle) =>
      puzzle.mechanics.any((c) => c is DashCell || c is DiagonalDashCell);
}

const dashValidator = DashValidator();
