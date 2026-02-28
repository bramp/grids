import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/puzzle.dart';

/// Represents a level in the game, consisting of metadata
/// and the puzzle itself.
class Level {
  Level({
    required this.id,
    required this.puzzle,
    this.knownSolutions = const [],
    this.note,
  }) {
    _validateSolutions(puzzle, knownSolutions, id);
  }

  /// Unique identifier for the puzzle.
  final String id;

  /// The puzzle itself (the grid and its state).
  final Puzzle puzzle;

  /// A list of known valid solutions.
  final List<GridState> knownSolutions;

  static void _validateSolutions(
    Puzzle puzzle,
    List<GridState> solutions,
    String levelId,
  ) {
    for (final solution in solutions) {
      if (puzzle.width != solution.width || puzzle.height != solution.height) {
        throw ArgumentError(
          'Solution size mismatch for level $levelId: '
          'Puzzle is ${puzzle.width}x${puzzle.height}, '
          'Solution is ${solution.width}x${solution.height}',
        );
      }
      for (var i = 0; i < puzzle.mechanics.length; i++) {
        final pt = GridPoint(i);
        if (puzzle.getCell(pt) is VoidCell && solution.isLit(pt)) {
          throw ArgumentError(
            'Void cell is lit in level $levelId at $pt. '
            'Cells marked as void in the puzzle must be unlit in solutions.',
          );
        }
      }
    }
  }

  /// Optional developer note for context about the puzzle
  /// (e.g. unsupported mechanics, design intent, source).
  /// Not shown to the player.
  final String? note;
}
