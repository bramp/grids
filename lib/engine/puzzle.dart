import 'package:grids/engine/grid_state.dart';
import 'package:meta/meta.dart';

/// Represents a specific level or puzzle in the game.
@immutable
class Puzzle {
  const Puzzle({
    required this.id,
    required this.initialGrid,
    this.knownSolutions = const [],
    this.metadata = const {},
  });

  /// Unique identifier for the puzzle.
  final String id;

  /// The starting layout of the grid, including all mechanics.
  final GridState initialGrid;

  /// A list of known valid solutions in ASCII symbolic notation.
  final List<String> knownSolutions;

  /// Additional optional metadata (e.g. difficulty, author).
  final Map<String, dynamic> metadata;
}
