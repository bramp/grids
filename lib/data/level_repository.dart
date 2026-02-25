import 'package:grids/data/levels/garden_levels.dart';
import 'package:grids/data/levels/mill_levels.dart';
import 'package:grids/data/levels/mine_levels.dart';
import 'package:grids/data/levels/shrine_levels.dart';
import 'package:grids/engine/puzzle.dart';

/// A hardcoded repository of levels to build the initial game progression.
///
/// To add a known solution to a puzzle, run:
///   `dart run bin/solve.dart --mask PUZZLE_ID`
/// and copy the output directly.
//
class LevelRepository {
  /// Ordered list of levels for the main progression.
  /// https://steamcommunity.com/sharedfiles/filedetails/?id=2861109284
  static final List<Puzzle> levels = [
    ...shrineLevels,
    ...mineLevels,
    ...millLevels,
    ...gardenLevels,
  ];
}
