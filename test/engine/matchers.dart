import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/puzzle_validator.dart';
import 'package:grids/engine/rule_validator.dart';

/// A matcher that asserts a [Puzzle] is valid when evaluated by a
/// [PuzzleValidator].
/// If it is invalid, it prints all the associated validation errors with (x, y)
/// coordinates.
Matcher isValidPuzzle(PuzzleValidator validator) => _IsValidPuzzle(validator);

class _IsValidPuzzle extends Matcher {
  const _IsValidPuzzle(this.validator);

  final PuzzleValidator validator;

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) {
    if (item is Puzzle) {
      final result = validator.validate(item);
      matchState['result'] = result;
      return result.isValid;
    }
    return false;
  }

  @override
  Description describe(Description description) {
    return description.add('a valid Puzzle according to the PuzzleValidator');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is Puzzle) {
      final result = matchState['result'] as ValidationResult?;
      if (result != null) {
        mismatchDescription
            .add('has validation errors:\n')
            .add(
              GridFormat.toAsciiString(
                item,
                useColor: true,
                errors: result.errors.map((e) => e.point).toSet(),
              ),
            )
            .add('\n');
        for (final error in result.errors) {
          mismatchDescription.add(
            ' - ${item.xy(error.point)}: ${error.message}\n',
          );
        }

        return mismatchDescription;
      }
    }
    return mismatchDescription.add('is not a Puzzle');
  }
}
