import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grids/data/level_repository.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:grids/services/progress_service.dart';
import 'package:grids/ui/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final levelProvider = context.watch<LevelProvider>();
    final progressService = context.watch<ProgressService>();
    final themeProvider = context.watch<ThemeProvider>();
    final activeTheme = themeProvider.activeTheme;

    // A simple list view for now. A true 2D graph requires a CustomPainter
    // or a complex Stack layout, which we can iterate on later.
    return Scaffold(
      backgroundColor: activeTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('World Map'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => showSettingsDialog(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: LevelRepository.worldMap.length,
            itemBuilder: (context, index) {
              final group = LevelRepository.worldMap.values.elementAt(index);
              final isUnlocked = levelProvider.unlockedGroups.contains(
                group.id,
              );

              // Calculate progress within the group
              final groupLevelIds = group.levels.map((l) => l.id).toList();
              final solvedCount = progressService.getSolvedCount(groupLevelIds);
              final totalCount = group.levels.length;

              // Use a generic highlight color since activeTheme
              // may not be CyberTheme
              const highlightColor = Colors.cyan;

              return Card(
                color: isUnlocked
                    ? highlightColor.withValues(alpha: 0.1)
                    : Colors.black45,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: isUnlocked ? highlightColor : Colors.white24,
                    width: isUnlocked ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  leading: Icon(
                    isUnlocked ? Icons.play_circle_fill : Icons.lock,
                    color: isUnlocked ? highlightColor : Colors.white24,
                    size: 32,
                  ),
                  title: Text(
                    group.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? Colors.white : Colors.white54,
                    ),
                  ),
                  subtitle: Text(
                    isUnlocked
                        ? '$solvedCount / $totalCount Levels Completed'
                        : 'Requires: '
                              '${group.requiredGroups.join(", ")}',
                    style: TextStyle(
                      color: isUnlocked ? Colors.white70 : Colors.white38,
                    ),
                  ),
                  onTap: isUnlocked
                      ? () async {
                          // Jump to group logic -> determines first unsolved
                          levelProvider.jumpToGroup(group.id);
                          await context.push(
                            '/level/${levelProvider.currentLevel.id}',
                          );
                        }
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
