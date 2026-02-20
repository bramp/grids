import 'package:flutter/foundation.dart';
import 'package:grids/engine/grid_state.dart';

/// Represents a specific level or puzzle in the game.
@immutable
class Puzzle {
  const Puzzle({
    required this.id,
    required this.initialGrid,
    this.metadata = const {},
  });

  /// Unique identifier for the puzzle.
  final String id;

  /// The starting layout of the grid, including all mechanics.
  final GridState initialGrid;

  /// Additional optional metadata (e.g. difficulty, author).
  final Map<String, dynamic> metadata;
}
