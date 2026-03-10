import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:grids/build_info.dart';

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
import 'package:provider/provider.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
            return CustomTransitionPage(
              key: state.pageKey,
              child: GameScreen(levelId: id),
              transitionsBuilder:
                  (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                              reverseCurve: Curves.easeInCubic,
                            ),
                          ),
                      child: child,
                    );
                  },
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
        return _DeferredFocusOverlay(
          child: Stack(
            fit: StackFit.expand,
            children: [
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
