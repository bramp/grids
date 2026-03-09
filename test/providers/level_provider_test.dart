import 'package:flutter_test/flutter_test.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/services/progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProgressService progressService;
  late LevelProvider levelProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    progressService = await ProgressService.init();
    levelProvider = LevelProvider(progressService)..refresh();
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
}
