import 'dart:collection';

import 'package:grids_engine/data/levels/black.dart';
import 'package:grids_engine/data/levels/garden_levels.dart';
import 'package:grids_engine/data/levels/mill_levels.dart';
import 'package:grids_engine/data/levels/mine_levels.dart';
import 'package:grids_engine/data/levels/shrine_levels.dart';
import 'package:grids_engine/data/levels/waterfall.dart';
import 'package:grids_engine/level.dart';
import 'package:grids_engine/level_group.dart';

/// A hardcoded repository of levels to build the initial game progression.
///
/// To add a known solution to a puzzle, run:
///   `dart run bin/solve.dart --mask PUZZLE_ID`
/// and copy the output directly.
//
class LevelRepository {
  /// The world map of all level groups.
  static final Map<String, LevelGroup> worldMap = UnmodifiableMapView(
    <String, LevelGroup>{
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
      'black': LevelGroup(
        id: 'black',
        title: 'The Black',
        levels: black,
        requiredGroups: const ['shrine', 'mine', 'mill', 'garden'],
      ),
      'waterfall': LevelGroup(
        id: 'waterfall',
        title: 'The Waterfall',
        levels: waterfall,
        requiredGroups: const ['shrine', 'mine', 'mill', 'garden'],
      ),
    },
  );

  /// For backwards compatibility and flat iteration (if needed).
  static final List<Level> levels = List<Level>.unmodifiable(
    worldMap.values.expand((group) => group.levels),
  );
}
