import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:grids/services/analytics_service.dart';
import 'package:grids/services/consent_service.dart';
import 'package:grids/services/preferences_service.dart';
import 'package:grids/services/progress_service.dart';
import 'package:grids/ui/screens/world_map_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // A basic smoke test to ensure there are no Provider missing issues or
  // other fatal crashes
  testWidgets('WorldMapScreen smoke test', (tester) async {
    final prefs = await PreferencesService.init();
    final progressService = ProgressService(prefs);
    final analyticsService = AnalyticsService(ConsentService(prefs));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ProgressService>.value(value: progressService),
          ChangeNotifierProvider(
            create: (_) => LevelProvider(progressService, analyticsService),
          ),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: WorldMapScreen(),
        ),
      ),
    );

    // If it pumps successfully, no ProviderNotFoundException has been thrown.
    expect(find.text('World Map'), findsOneWidget);

    // There should be at least one level group displayed
    expect(find.byType(Card), findsWidgets);
  });
}
