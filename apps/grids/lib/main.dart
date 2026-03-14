import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

import 'package:grids/firebase_options.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:grids/services/analytics_service.dart';
import 'package:grids/services/consent_service.dart';
import 'package:grids/services/preferences_service.dart';
import 'package:grids/services/progress_service.dart';
import 'package:grids/ui/grid_widget.dart';
import 'package:grids/ui/intents.dart';
import 'package:grids/ui/screens/world_map_screen.dart';
import 'package:grids/ui/widgets/consent_banner.dart';
import 'package:grids/ui/widgets/game_app_bar.dart';
import 'package:grids/ui/widgets/game_bottom_bar.dart';
import 'package:grids/ui/widgets/win_animations/matrix_ripple.dart';
import 'package:provider/provider.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Lock to portrait mode for puzzle gameplay consistency
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Enable edge-to-edge mode (especially for modern Android)
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on Object catch (e) {
    debugPrint('Firebase initialization failed (not configured?): $e');
  }

  // Initialize synchronous access to shared_preferences
  final preferencesService = await PreferencesService.init();
  final progressService = ProgressService(preferencesService);
  final consentService = ConsentService(preferencesService);
  final analyticsService = AnalyticsService(consentService);

  await MatrixRipple.precache();

  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        Provider<ProgressService>.value(value: progressService),
        ChangeNotifierProvider<ConsentService>.value(value: consentService),
        ChangeNotifierProvider(
          create: (_) => LevelProvider(progressService, analyticsService),
        ),
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
      builder: (context, state) => const WorldMapScreen(),
      routes: [
        GoRoute(
          path: 'level/:id',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(
              child: GameScreen(levelId: id),
            );
          },
        ),
      ],
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
      builder: (context, child) {
        final themeProvider = context.watch<ThemeProvider>();
        final activeTheme = themeProvider.activeTheme;

        // Ensure the system bars match the theme background and handle contrast
        final isDark = activeTheme.backgroundColor.computeLuminance() < 0.5;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            // Use transparent for edge-to-edge look, background color otherwise
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          ),
        );

        return _DeferredFocusOverlay(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Persistent background that never participates in page
              // transitions – visible on every screen.
              Positioned.fill(
                child: ColoredBox(color: activeTheme.backgroundColor),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: activeTheme.buildScreenBackground(context),
                ),
              ),
              if (child != null) Positioned.fill(child: child),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ConsentBanner(),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Defers focus traversal for one frame to work around a web-specific crash
/// where the browser's focus event fires before Flutter's render tree is fully
/// laid out, causing `_RenderTheater` to be accessed without a size.
class _DeferredFocusOverlay extends StatefulWidget {
  const _DeferredFocusOverlay({required this.child});
  final Widget child;

  @override
  State<_DeferredFocusOverlay> createState() => _DeferredFocusOverlayState();
}

class _DeferredFocusOverlayState extends State<_DeferredFocusOverlay> {
  bool _traversable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _traversable = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      descendantsAreTraversable: _traversable,
      child: widget.child,
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
    final provider = context.watch<LevelProvider>();

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
              if (provider.hasNextLevel) {
                final group = provider.currentGroup;
                final nextLevel = group.levels[provider.currentLevelIndex + 1];
                context.go('/level/${nextLevel.id}');
              }
              return null;
            },
          ),
          PrevLevelIntent: CallbackAction<PrevLevelIntent>(
            onInvoke: (intent) {
              if (provider.hasPreviousLevel) {
                final group = provider.currentGroup;
                final prevLevel = group.levels[provider.currentLevelIndex - 1];
                context.go('/level/${prevLevel.id}');
              }
              return null;
            },
          ),
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const GameAppBar(),
          body: _GameBody(
            showWin: provider.showWinAnimation,
          ),
        ),
      ),
    );
  }
}

class _GameBody extends StatelessWidget {
  const _GameBody({required this.showWin});

  final bool showWin;

  @override
  Widget build(BuildContext context) {
    Widget body = const Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: GridWidget(),
          ),
        ),
        GameBottomBar(),
      ],
    );

    if (showWin) {
      body = MatrixRipple(
        onComplete: () => context.read<LevelProvider>().clearWinAnimation(),
        child: body,
      );
    }

    return body;
  }
}
