import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';

/// The result returned from validating a specific region of the grid.
class ValidationResult {
  ValidationResult._(this.isValid, this.errors);

  factory ValidationResult.success() => ValidationResult._(true, []);
  factory ValidationResult.failure(List<GridPoint> errs) =>
      ValidationResult._(false, errs);
  final bool isValid;

  /// A list of points indicating specifically which cells violated the rule.
  /// Used for UI feedback (e.g., flashing red when incorrect).
  final List<GridPoint> errors;
}

/// A function that validates a single contiguous area from a grid.
///
/// The [area] is guaranteed to be a completely contiguous run of cells that
/// all share the identical lit/unlit state within the [grid].
typedef RuleValidator =
    ValidationResult Function(
      GridState grid,
      Set<GridPoint> area,
    );
