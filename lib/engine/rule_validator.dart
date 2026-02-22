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

/// A function that validates a single contiguous area from a grid.
typedef RuleValidator =
    ValidationResult Function(
      GridState grid,
      List<GridPoint> area,
    );
