import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:provider/provider.dart';

/// The bottom controls for the game screen, including Previous,
/// Check Answer, and Next buttons.
class GameBottomBar extends StatelessWidget {
  const GameBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isSolved = context.select<LevelProvider, bool>((p) => p.isSolved);
    final nextLevelId = context.select<LevelProvider, String?>(
      (p) => p.nextLevelId,
    );
    final prevLevelId = context.select<LevelProvider, String?>(
      (p) => p.previousLevelId,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            iconSize: 32,
            onPressed: prevLevelId != null
                ? () => context.go('/level/$prevLevelId')
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
                onPressed: () => context.read<LevelProvider>().checkAnswer(),
                style: isSolved
                    ? FilledButton.styleFrom(
                        backgroundColor: Colors.green,
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
            onPressed: nextLevelId != null
                ? () => context.go('/level/$nextLevelId')
                : null,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
