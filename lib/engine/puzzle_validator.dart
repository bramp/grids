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
      lockedCellValidator,
      flowerValidator,
      dashValidator,
    ],
  });

  /// The list of rules to be applied to each contiguous area.
  final List<RuleValidator> validators;

  /// Returns a new [PuzzleValidator] containing only the rules relevant to
  /// the given [grid].
  ///
  /// This optimizes validation by skipping rules for mechanics that are not
  /// present in the puzzle.
  PuzzleValidator filter(GridState grid) {
    final relevant = validators.where((v) => v.isApplicable(grid)).toList();
    return PuzzleValidator(validators: relevant);
  }

  /// Evaluates an entire grid state.
  ///
  /// Returns a [ValidationResult] representing the entire board.
  ValidationResult validate(GridState grid) {
    var allValid = true;
    final allErrors = <GridPoint>{};

    final areas = grid.extractContiguousAreas();

    // Evaluate every contiguous area against every rule cell
    for (final area in areas) {
      for (final validator in validators) {
        final result = validator.validate(grid, area);
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
