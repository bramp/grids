import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';

/// The result returned from validating a specific region of the grid.
class ValidationResult {
  ValidationResult._(this.isValid, this.errors);

  factory ValidationResult.success() => ValidationResult._(true, []);

  /// Creates a failure result with a list of violating [GridPoint]s.
  factory ValidationResult.failure(List<GridPoint> errs) =>
      ValidationResult._(false, errs);

  final bool isValid;

  /// A list of [GridPoint]s indicating specifically which cells violated
  /// the rule.
  final List<GridPoint> errors;
}

/// A rule that can be applied to a contiguous area of the grid.
abstract class RuleValidator {
  const RuleValidator();

  /// Validates a single contiguous area from a grid.
  ///
  /// Returns a [ValidationResult] indicating if the area satisfies the rule.
  ValidationResult validate(GridState grid, List<GridPoint> area);

  /// Returns true if this rule is relevant to the given [grid].
  ///
  /// For example, a diamond rule is only applicable if the grid contains
  /// at least one diamond cell.
  bool isApplicable(GridState grid);
}
