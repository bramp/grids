import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grids/build_info.dart';
import 'package:grids/data/level_repository.dart';
import 'package:grids/engine/rule_validator.dart';
import 'package:grids/firebase_options.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:grids/ui/grid_widget.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on Object catch (e) {
    debugPrint('Firebase initialization failed (not configured?): $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LevelProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const GridsApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final provider = context.read<LevelProvider>();
        return '/level/${provider.currentLevel.id}';
      },
    ),
    GoRoute(
      path: '/level/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return GameScreen(levelId: id);
      },
    ),
  ],
);

class GridsApp extends StatelessWidget {
  const GridsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Grids',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({
    required this.levelId,
    super.key,
  });

  final String levelId;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LevelProvider>().loadLevelById(widget.levelId);
    });
  }

  @override
  void didUpdateWidget(covariant GameScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.levelId != oldWidget.levelId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<LevelProvider>().loadLevelById(widget.levelId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch relevant provider state
    final puzzleName = context.select<LevelProvider, String>(
      (p) => p.currentLevel.id,
    );
    final validation = context.select<LevelProvider, ValidationResult?>(
      (p) => p.validation,
    );
    final isSolved = context.select<LevelProvider, bool>((p) => p.isSolved);
    final nextLevelId = context.select<LevelProvider, String?>(
      (p) => p.nextLevelId,
    );
    final prevLevelId = context.select<LevelProvider, String?>(
      (p) => p.previousLevelId,
    );

    final themeProvider = context.watch<ThemeProvider>();
    final activeTheme = themeProvider.activeTheme;

    return Scaffold(
      backgroundColor: activeTheme.backgroundColor,
      appBar: AppBar(
        title: Text(puzzleName),
        centerTitle: true,
        actions: [
          // Debug-only: level selector for quickly jumping to any puzzle.
          if (kDebugMode) const _DebugLevelPicker(),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Grids',
                applicationVersion: BuildInfo.version,
                applicationIcon: const Icon(Icons.grid_on, size: 48),
                children: [
                  const Text('A logic puzzle game built with Flutter.'),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: DropdownButton<PuzzleTheme>(
              value: activeTheme,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.palette),
              onChanged: (theme) {
                if (theme != null) {
                  themeProvider.setTheme(theme);
                }
              },
              items: themeProvider.availableThemes
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.name),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
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
                  onPressed: prevLevelId != null
                      ? () => context.go('/level/$prevLevelId')
                      : null,
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: FilledButton.tonal(
                      onPressed: () =>
                          context.read<LevelProvider>().checkAnswer(),
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
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                BuildInfo.shortVersion,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                  fontSize: 10,
                ),
              ),
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

/// Debug-only widget: a dropdown in the AppBar for jumping directly to any
/// puzzle by ID. Only compiled in when [kDebugMode] is true.
class _DebugLevelPicker extends StatelessWidget {
  const _DebugLevelPicker();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LevelProvider>();
    final levels = LevelRepository.levels;
    final currentIndex = provider.currentLevelIndex;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: DropdownButton<int>(
        value: currentIndex,
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.bug_report, size: 20),
        onChanged: (index) {
          if (index != null) {
            context.go('/level/${levels[index].id}');
          }
        },
        items: List.generate(
          levels.length,
          (i) => DropdownMenuItem(
            value: i,
            child: Text(
              levels[i].id,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
