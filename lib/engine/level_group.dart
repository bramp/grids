import 'package:grids/engine/level.dart';

/// Represents a collection or path of levels
/// (e.g., "The Garden", "The Shrine").
///
/// A [LevelGroup] defines a linear sequence of levels.
/// Groups themselves can depend on the completion of other
/// groups, forming a non-linear progression graph across the
/// entire game.
class LevelGroup {
  const LevelGroup({
    required this.id,
    required this.title,
    required this.levels,
    this.requiredGroups = const [],
  });

  /// Unique identifier for this group (e.g., 'garden').
  final String id;

  /// User-facing title of the group.
  final String title;

  /// The linear sequence of puzzles in this group.
  final List<Level> levels;

  /// IDs of other LevelGroups that must be fully completed before this group
  /// is unlocked.
  final List<String> requiredGroups;
}
