import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/puzzle.dart';

/// The result returned from validating a specific region of the puzzle.
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

/// A rule that can be applied to a contiguous area of the puzzle.
abstract class RuleValidator {
  const RuleValidator();

  /// Validates a single contiguous area from a puzzle.
  ///
  /// Returns a [ValidationResult] indicating if the area satisfies the rule.
  ValidationResult validate(Puzzle puzzle, List<GridPoint> area);

  /// Returns true if this rule is relevant to the given [puzzle].
  ///
  /// For example, a diamond rule is only applicable if the grid contains
  /// at least one diamond cell.
  bool isApplicable(Puzzle puzzle);
}
