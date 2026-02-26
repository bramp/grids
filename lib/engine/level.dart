import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/puzzle.dart';

/// Represents a level in the game, consisting of metadata
/// and the puzzle itself.
class Level {
  const Level({
    required this.id,
    required this.puzzle,
    this.knownSolutions = const [],
    this.note,
    this.metadata = const {},
  });

  /// Unique identifier for the puzzle.
  final String id;

  /// The puzzle itself (the grid and its state).
  final Puzzle puzzle;

  /// A list of known valid solutions.
  final List<GridState> knownSolutions;

  /// Optional developer note for context about the puzzle
  /// (e.g. unsupported mechanics, design intent, source).
  /// Not shown to the player.
  final String? note;

  /// Additional optional metadata (e.g. difficulty, author).
  final Map<String, dynamic> metadata;
}
