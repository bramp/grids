import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:grids/services/analytics_service.dart';
import 'package:grids/services/consent_service.dart';
import 'package:grids/services/preferences_service.dart';
import 'package:grids/services/progress_service.dart';
import 'package:grids/ui/widgets/game_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PreferencesService prefs;
  late ProgressService progressService;
  late ConsentService consentService;
  late AnalyticsService analyticsService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await PreferencesService.init();
    progressService = ProgressService(prefs);
    consentService = ConsentService(prefs);
    analyticsService = AnalyticsService(consentService);
  });

  Widget buildSubject() {
    final router = GoRouter(
      initialLocation: '/level/test',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/level/:id',
          builder: (context, state) => const Scaffold(appBar: GameAppBar()),
        ),
      ],
    );

    return MultiProvider(
      providers: [
        Provider<ProgressService>.value(value: progressService),
        ChangeNotifierProvider<ConsentService>.value(value: consentService),
        ChangeNotifierProvider(
          create: (_) => LevelProvider(progressService, analyticsService),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets('GameAppBar smoke test – renders without errors', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    // The app bar should show the level name and action icons.
    expect(find.byType(GameAppBar), findsOneWidget);
    expect(find.byIcon(Icons.map), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('settings icon opens the settings dialog', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Privacy'), findsOneWidget);
  });
}
