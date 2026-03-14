import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:provider/provider.dart';

/// The bottom controls for the game screen, including Previous,
/// Check Answer, and Next buttons.
class GameBottomBar extends StatelessWidget {
  const GameBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LevelProvider>();
    final solvedColor = context.select<ThemeProvider, Color>(
      (p) => p.activeTheme.solvedColor,
    );
    final isSolved = provider.isSolved;
    final hasPrev = provider.hasPreviousLevel;
    final hasNext = provider.hasNextLevel;
    final currentIndex = provider.currentLevelIndex;
    final group = provider.currentGroup;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            iconSize: 32,
            onPressed: hasPrev
                ? () => context.go(
                    '/level/${group.levels[currentIndex - 1].id}',
                  )
                : null,
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 16),
          IconButton(
            iconSize: 32,
            onPressed: () => context.read<LevelProvider>().resetPuzzle(),
            tooltip: 'Reset puzzle',
            icon: const Icon(Icons.restart_alt),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 56,
              child: FilledButton.tonal(
                onPressed: isSolved
                    ? null
                    : () => context.read<LevelProvider>().checkAnswer(),
                style: isSolved
                    ? FilledButton.styleFrom(
                        backgroundColor: solvedColor,
                        disabledBackgroundColor: solvedColor,
                        disabledForegroundColor:
                            ThemeData.estimateBrightnessForColor(solvedColor) ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      )
                    : null,
                child: const Text(
                  'Check Answer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            iconSize: 32,
            onPressed: hasNext
                ? () => context.go(
                    '/level/${group.levels[currentIndex + 1].id}',
                  )
                : null,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
