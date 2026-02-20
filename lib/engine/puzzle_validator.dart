import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/rule_validator.dart';
import 'package:grids/engine/validators.dart';

/// Aggregates all cells validation and outputs the final master state
/// of the full puzzle.
class PuzzleValidator {
  PuzzleValidator({
    this.validators = const [
      diamondValidator,
      strictNumberValidator,
      numberColorValidator,
    ],
  });
  final List<RuleValidator> validators;

  /// Evaluates an entire grid state.
  ///
  /// Returns a [ValidationResult] representing the entire board. If
  /// [ValidationResult.isValid] is true, the user has completely solved the
  /// puzzle.
  /// If [ValidationResult.isValid] is false, [ValidationResult.errors] will
  /// contain EVERY specific cell across all contiguous areas that currently
  /// violates a rule, allowing UI to highlight them.
  ValidationResult validate(GridState grid) {
    var allValid = true;
    final allErrors = <GridPoint>{};

    final areas = grid.extractContiguousAreas();

    // Evaluate every contiguous area against every rule cell
    for (final area in areas) {
      for (final validator in validators) {
        final result = validator(grid, area);
        if (!result.isValid) {
          allValid = false;
          allErrors.addAll(result.errors);
        }
      }
    }

    if (allValid) {
      return ValidationResult.success();
    }
    return ValidationResult.failure(allErrors.toList());
  }
}
