import 'package:flutter/material.dart';
import 'package:grids/engine/rule_validator.dart';
import 'package:grids/providers/puzzle_provider.dart';
import 'package:grids/ui/grid_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PuzzleProvider())],
      child: const GridsApp(),
    ),
  );
}

class GridsApp extends StatelessWidget {
  const GridsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grids',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch relevant provider state
    final puzzleName = context.select<PuzzleProvider, String>(
      (p) => p.currentPuzzle.id,
    );
    final validation = context.select<PuzzleProvider, ValidationResult?>(
      (p) => p.validation,
    );
    final isSolved = context.select<PuzzleProvider, bool>((p) => p.isSolved);
    final hasNext = context.select<PuzzleProvider, bool>((p) => p.hasNextLevel);
    final hasPrev = context.select<PuzzleProvider, bool>(
      (p) => p.hasPreviousLevel,
    );

    return Scaffold(
      appBar: AppBar(title: Text(puzzleName), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _buildStatusText(context, validation),
          ),
          const Expanded(
            child: Padding(padding: EdgeInsets.all(24), child: GridWidget()),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                IconButton(
                  iconSize: 32,
                  onPressed: hasPrev
                      ? () => context.read<PuzzleProvider>().previousLevel()
                      : null,
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: FilledButton.tonal(
                      onPressed: () =>
                          context.read<PuzzleProvider>().checkAnswer(),
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
                  onPressed: hasNext
                      ? () => context.read<PuzzleProvider>().nextLevel()
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText(BuildContext context, ValidationResult? validation) {
    if (validation == null) {
      return const Text(
        'In Progress',
        style: TextStyle(color: Colors.grey, fontSize: 18),
      );
    }

    if (validation.isValid) {
      return const Text(
        'SOLVED!',
        style: TextStyle(
          color: Colors.green,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return const Text(
        'Incorrect! Try again.',
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}
