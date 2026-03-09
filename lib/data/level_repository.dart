import 'package:grids/data/levels/garden_levels.dart';
import 'package:grids/data/levels/mill_levels.dart';
import 'package:grids/data/levels/mine_levels.dart';
import 'package:grids/data/levels/shrine_levels.dart';
import 'package:grids/engine/level.dart';
import 'package:grids/engine/level_group.dart';

/// A hardcoded repository of levels to build the initial game progression.
///
/// To add a known solution to a puzzle, run:
///   `dart run bin/solve.dart --mask PUZZLE_ID`
/// and copy the output directly.
//
class LevelRepository {
  /// The world map of all level groups.
  static final Map<String, LevelGroup> worldMap = {
    'shrine': LevelGroup(
      id: 'shrine',
      title: 'The Shrine',
      levels: shrineLevels,
    ),
    'mine': LevelGroup(
      id: 'mine',
      title: 'The Mine',
      levels: mineLevels,
    ),
    'mill': LevelGroup(
      id: 'mill',
      title: 'The Mill',
      levels: millLevels,
    ),
    'garden': LevelGroup(
      id: 'garden',
      title: 'The Garden',
      levels: [...garden, ...gardenShortcut],
    ),
    'garden_bonus': LevelGroup(
      id: 'garden_bonus',
      title: 'The Garden Bonus',
      levels: gardenBonus,
      requiredGroups: const ['garden', 'shrine'],
    ),
  };

  /// For backwards compatibility and flat iteration (if needed).
  static final List<Level> levels = <Level>[
    ...worldMap['shrine']!.levels,
    ...worldMap['mine']!.levels,
    ...worldMap['mill']!.levels,
    ...worldMap['garden']!.levels,
  ];
}
