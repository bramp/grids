import 'package:flutter_test/flutter_test.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/services/analytics_service.dart';
import 'package:grids/services/consent_service.dart';
import 'package:grids/services/preferences_service.dart';
import 'package:grids/services/progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProgressService progressService;
  late AnalyticsService analyticsService;
  late LevelProvider levelProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await PreferencesService.init();
    progressService = ProgressService(prefs);
    analyticsService = AnalyticsService(ConsentService(prefs));
    levelProvider = LevelProvider(progressService, analyticsService)..refresh();
  });

  test('hasNextLevel should be false initially for the first level', () {
    // By default, shrine_1 is loaded.
    // shrine_2 is NOT yet unlocked/solved.
    expect(levelProvider.currentLevelIndex, 0);
    expect(levelProvider.currentLevel.id, 'shrine_1');
    expect(levelProvider.hasNextLevel, isFalse);
  });

  test('hasNextLevel should be true if the next level is unlocked', () async {
    // Manually get the second level ID in the group
    final nextId = levelProvider.currentGroup.levels[1].id;

    await progressService.saveLevelUnlocked(nextId);

    expect(levelProvider.hasNextLevel, isTrue);
  });

  test('hasNextLevel should be false when current level '
      'is solved but next is not unlocked', () {
    // Set up the correct solution by toggling cells
    // to match knownSolutions[0]
    final level = levelProvider.currentLevel;
    final solution = level.knownSolutions.first;
    for (var y = 0; y < level.puzzle.height; y++) {
      for (var x = 0; x < level.puzzle.width; x++) {
        final pt = level.puzzle.pointAt(x, y);
        final needsLit = solution.isLit(pt);
        final currentlyLit = levelProvider.puzzle.state.isLit(pt);
        if (needsLit != currentlyLit) {
          levelProvider.toggleCell(pt);
        }
      }
    }

    // Verify we have the right answer but haven't checked yet
    expect(levelProvider.isSolved, isFalse);

    // The next level should NOT be accessible just because we entered
    // the right answer without checking
    expect(levelProvider.hasNextLevel, isFalse);
  });

  test('hasNextLevel should be true after checkAnswer succeeds', () {
    // Set up the correct solution
    final level = levelProvider.currentLevel;
    final solution = level.knownSolutions.first;
    for (var y = 0; y < level.puzzle.height; y++) {
      for (var x = 0; x < level.puzzle.width; x++) {
        final pt = level.puzzle.pointAt(x, y);
        final needsLit = solution.isLit(pt);
        final currentlyLit = levelProvider.puzzle.state.isLit(pt);
        if (needsLit != currentlyLit) {
          levelProvider.toggleCell(pt);
        }
      }
    }

    // Check the answer - this should unlock the next level
    levelProvider.checkAnswer();
    expect(levelProvider.isSolved, isTrue);
    expect(levelProvider.hasNextLevel, isTrue);
  });

  test(
    'loadLevelById should not unlock levels just by visiting them',
    () async {
      // The second level should not be unlocked initially
      final secondId = levelProvider.currentGroup.levels[1].id;
      expect(progressService.isLevelUnlocked(secondId), isFalse);

      // Navigate to the second level
      levelProvider.loadLevelById(secondId);

      // The level should NOT be marked as unlocked just from visiting
      expect(progressService.isLevelUnlocked(secondId), isFalse);
    },
  );

  test('resetPuzzle should restore the puzzle to its original state', () {
    // Toggle a few cells to change the puzzle state
    final puzzle = levelProvider.puzzle;
    final pt0 = puzzle.pointAt(0, 0);
    final pt1 = puzzle.pointAt(1, 0);
    levelProvider
      ..toggleCell(pt0)
      ..toggleCell(pt1);

    // Verify state changed
    expect(levelProvider.puzzle.state.bits, isNot(equals(BigInt.zero)));

    // Reset
    levelProvider.resetPuzzle();

    // Puzzle state should match the original level puzzle
    expect(
      levelProvider.puzzle.state.bits,
      equals(levelProvider.currentLevel.puzzle.state.bits),
    );
    expect(levelProvider.isSolved, isFalse);

    // Saved solution should be cleared
    expect(
      progressService.getSolution(
        levelProvider.currentLevel.id,
        puzzle.width,
        puzzle.height,
      ),
      isNull,
    );
  });
}
