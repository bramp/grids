import 'dart:math';

import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/puzzle.dart';

/// Returns the number of playable (non-locked) cells in the grid.
int countPlayable(Puzzle puzzle) {
  var count = 0;
  for (var i = 0; i < puzzle.mechanics.length; i++) {
    if (!puzzle.isLocked(GridPoint(i))) {
      count++;
    }
  }
  return count;
}

/// Returns a difficulty rating based on solution density and grid complexity.
///
/// Heuristic: score = playableCells - log2(solutionCount)
/// This represents "how many bits of information you need to find a solution."
/// Higher = harder.
String difficulty(int solutionCount, int playableCells) {
  if (playableCells == 0) return '⬜ trivial';
  if (solutionCount == 0) return '🚫 impossible';

  final searchSpace = pow(2, playableCells);
  final density = solutionCount / searchSpace;
  final score = -log(density) / ln2;

  if (score <= 4) return '🟢 easy';
  if (score <= 8) return '🟡 medium';
  if (score <= 14) return '🟠 hard';
  return '🔴 expert';
}
