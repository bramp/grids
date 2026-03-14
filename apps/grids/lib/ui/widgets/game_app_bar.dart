import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/ui/screens/settings_screen.dart';
import 'package:grids_engine/data/level_repository.dart';
import 'package:provider/provider.dart';

/// The AppBar for the main game screen, containing the puzzle name,
/// theme selector, and a debug level picker.
class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GameAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Watch relevant provider state
    final puzzleName = context.select<LevelProvider, String>(
      (p) => p.currentLevel.id,
    );

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.map),
        tooltip: 'World Map',
        onPressed: () {
          context.go('/');
        },
      ),
      title: Text(puzzleName),
      centerTitle: true,
      actions: [
        // Debug-only: level selector for quickly jumping to any puzzle.
        if (kDebugMode) const _DebugLevelPicker(),
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
          onPressed: () => showSettingsDialog(context),
        ),
      ],
    );
  }
}

/// Debug-only widget: a dropdown in the AppBar for jumping directly to any
/// puzzle by ID. Only compiled in when [kDebugMode] is true.
class _DebugLevelPicker extends StatelessWidget {
  const _DebugLevelPicker();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LevelProvider>();
    final levels = LevelRepository.levels;
    final currentIndex = levels.indexWhere(
      (l) => l.id == provider.currentLevel.id,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<int>(
        value: currentIndex,
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.bug_report),
        onChanged: (index) {
          if (index != null && index >= 0 && index < levels.length) {
            context.go('/level/${levels[index].id}');
          }
        },
        items: List.generate(
          levels.length,
          (i) => DropdownMenuItem(
            value: i,
            child: Text(
              '${levels[i].id} (${i + 1}/${levels.length})',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ),
      ),
    );
  }
}
