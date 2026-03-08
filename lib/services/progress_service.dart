import 'dart:async';

import 'package:grids/engine/grid_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  ProgressService(this._prefs);

  final SharedPreferences _prefs;

  static const String _keyLastLevelPlayed = 'last_level_played';
  static const String _keyUnlockedLevelsPrefix = 'unlocked_level_';
  static const String _keySolutionPrefix = 'solution_';

  static Future<ProgressService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ProgressService(prefs);
  }

  /// Saves the ID of the last level the user played.
  Future<void> saveLastLevelPlayed(String levelId) async {
    await _prefs.setString(_keyLastLevelPlayed, levelId);
  }

  /// Loads the ID of the last level the user played, if any.
  String? getLastLevelPlayed() {
    return _prefs.getString(_keyLastLevelPlayed);
  }

  /// Marks a specific level as unlocked.
  Future<void> saveLevelUnlocked(String levelId) async {
    await _prefs.setBool('$_keyUnlockedLevelsPrefix$levelId', true);
  }

  /// Checks if a specific level is unlocked.
  bool isLevelUnlocked(String levelId) {
    return _prefs.getBool('$_keyUnlockedLevelsPrefix$levelId') ?? false;
  }

  /// Saves the user's solved state for a specific puzzle.
  /// Converts the GridState's BigInt to a string for storage.
  Future<void> saveSolution(String levelId, GridState state) async {
    // BigInt.toString(radix: 16) gives us a compact hex string.
    await _prefs.setString(
      '$_keySolutionPrefix$levelId',
      state.bits.toRadixString(16),
    );
  }

  /// Loads the user's solved state for a specific puzzle, if they have one.
  GridState? getSolution(String levelId, int width, int height) {
    final solutionString = _prefs.getString('$_keySolutionPrefix$levelId');
    if (solutionString == null) return null;

    final bits = BigInt.tryParse(solutionString, radix: 16);
    if (bits == null) return null;

    return GridState(width: width, height: height, bits: bits);
  }
}
