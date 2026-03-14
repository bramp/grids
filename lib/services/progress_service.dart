import 'dart:async';

import 'package:grids/engine/grid_state.dart';
import 'package:grids/services/preferences_service.dart';

class ProgressService {
  ProgressService(this._prefs);

  final PreferencesService _prefs;

  static const String _keyLastLevelPlayed = 'last_level_played';
  static const String _keySolvedPrefix = 'solved_';
  static const String _keySolutionPrefix = 'solution_';

  /// Saves the ID of the last level the user played.
  Future<void> saveLastLevelPlayed(String levelId) async {
    await _prefs.setString(_keyLastLevelPlayed, levelId);
  }

  /// Loads the ID of the last level the user played, if any.
  String? getLastLevelPlayed() {
    return _prefs.getString(_keyLastLevelPlayed);
  }

  /// Marks a level as solved after the user explicitly clicks Check Answer
  /// and the validation passes.
  Future<void> saveLevelSolved(String levelId) async {
    await _prefs.setBool('$_keySolvedPrefix$levelId', value: true);
  }

  /// Checks if a specific level was explicitly solved via Check Answer.
  bool isLevelSolved(String levelId) {
    return _prefs.getBool('$_keySolvedPrefix$levelId') ?? false;
  }

  /// Saves the user's grid state for a specific puzzle (partial or complete).
  Future<void> saveSolution(String levelId, GridState state) async {
    await _prefs.setString(
      '$_keySolutionPrefix$levelId',
      state.bits.toRadixString(16),
    );
  }

  /// Clears the user's saved state for a specific puzzle.
  Future<void> clearSolution(String levelId) async {
    await _prefs.remove('$_keySolutionPrefix$levelId');
  }

  /// Loads the user's solved state for a specific puzzle, if they have one.
  GridState? getSolution(String levelId, int width, int height) {
    final solutionString = _prefs.getString('$_keySolutionPrefix$levelId');
    if (solutionString == null) return null;

    final bits = BigInt.tryParse(solutionString, radix: 16);
    if (bits == null) return null;

    return GridState(width: width, height: height, bits: bits);
  }

  /// Checks if all levels in a given list of IDs have been solved.
  bool areAllLevelsSolved(List<String> levelIds) =>
      levelIds.every(isLevelSolved);

  /// Returns the number of levels in a given list of IDs that have been solved.
  int getSolvedCount(List<String> levelIds) =>
      levelIds.where(isLevelSolved).length;
}
