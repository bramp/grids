import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/puzzle.dart';

import 'package:meta/meta.dart';

@immutable
class ValidationError {
  const ValidationError(this.point, this.message);

  final GridPoint point;
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationError &&
          runtimeType == other.runtimeType &&
          point == other.point &&
          message == other.message;

  @override
  int get hashCode => point.hashCode ^ message.hashCode;

  @override
  String toString() => 'ValidationError(point: $point, message: $message)';
}

/// The result returned from validating a specific region of the puzzle.
class ValidationResult {
  ValidationResult._(this.isValid, this.errors);

  factory ValidationResult.success() => ValidationResult._(true, []);

  /// Creates a failure result with a list of violating [ValidationError]s.
  factory ValidationResult.failure(List<ValidationError> errors) =>
      ValidationResult._(false, errors);

  final bool isValid;

  /// A list of [ValidationError]s indicating specifically which cells violated
  /// the rule.
  final List<ValidationError> errors;
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
