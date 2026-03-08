import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grids/build_info.dart';

import 'package:grids/firebase_options.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:grids/services/progress_service.dart';
import 'package:grids/ui/grid_widget.dart';
import 'package:grids/ui/intents.dart';
import 'package:grids/ui/widgets/game_app_bar.dart';
import 'package:grids/ui/widgets/game_bottom_bar.dart';
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

  // Initialize synchronous access to shared_preferences
  final progressService = await ProgressService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LevelProvider(progressService)),
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
    final nextLevelId = context.select<LevelProvider, String?>(
      (p) => p.nextLevelId,
    );
    final prevLevelId = context.select<LevelProvider, String?>(
      (p) => p.previousLevelId,
    );

    final themeProvider = context.watch<ThemeProvider>();
    final activeTheme = themeProvider.activeTheme;

    return Shortcuts(
      shortcuts: GameShortcuts.bindings,
      child: Actions(
        actions: {
          CheckAnswerIntent: CallbackAction<CheckAnswerIntent>(
            onInvoke: (intent) {
              context.read<LevelProvider>().checkAnswer();
              return null;
            },
          ),
          NextLevelIntent: CallbackAction<NextLevelIntent>(
            onInvoke: (intent) {
              if (nextLevelId != null) {
                context.go('/level/$nextLevelId');
              }
              return null;
            },
          ),
          PrevLevelIntent: CallbackAction<PrevLevelIntent>(
            onInvoke: (intent) {
              if (prevLevelId != null) {
                context.go('/level/$prevLevelId');
              }
              return null;
            },
          ),
        },
        child: Scaffold(
          backgroundColor: activeTheme.backgroundColor,
          appBar: const GameAppBar(),
          body: Column(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: GridWidget(),
                ),
              ),
              const GameBottomBar(),
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
        ),
      ),
    );
  }
}
