import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grids/services/consent_service.dart';
import 'package:grids/services/preferences_service.dart';
import 'package:grids/ui/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PreferencesService prefs;
  late ConsentService consentService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await PreferencesService.init();
    consentService = ConsentService(prefs, debugOverride: false);
  });

  Widget buildSubject() {
    return ChangeNotifierProvider<ConsentService>.value(
      value: consentService,
      child: MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showSettingsDialog(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openDialog(WidgetTester tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows about section with app name and version', (tester) async {
    await openDialog(tester);

    expect(find.text('About'), findsOneWidget);
    expect(find.text('Grids'), findsOneWidget);
    expect(find.text('Version'), findsOneWidget);
  });

  testWidgets('shows privacy section with analytics toggle', (tester) async {
    await openDialog(tester);

    expect(find.text('Privacy'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
  });

  testWidgets('analytics toggle changes consent', (tester) async {
    // Accept analytics first so the toggle starts ON.
    await consentService.setAnalyticsConsent(allowed: true);

    await openDialog(tester);

    // The switch should be on.
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    // Tap the toggle to turn analytics off.
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(consentService.analyticsAllowed, isFalse);

    // Tap again to re-enable.
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(consentService.analyticsAllowed, isTrue);
  });
}
