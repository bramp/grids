import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grids/services/consent_service.dart';
import 'package:grids/services/preferences_service.dart';
import 'package:grids/ui/widgets/consent_banner.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ConsentService consentService;

  Future<void> pumpBanner(WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ConsentService>.value(
        value: consentService,
        child: const MaterialApp(home: Scaffold(body: ConsentBanner())),
      ),
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await PreferencesService.init();
    consentService = ConsentService(prefs, debugOverride: false);
  });

  testWidgets('shows banner when consent not yet given', (tester) async {
    await pumpBanner(tester);

    expect(find.text('We value your privacy'), findsOneWidget);
    expect(find.text('Game Saves'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Accept'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    // Two switches: game saves (disabled, on) and analytics (off)
    expect(find.byType(Switch), findsNWidgets(2));
  });

  testWidgets('hides banner after accepting with analytics on', (tester) async {
    await pumpBanner(tester);

    // Analytics defaults to on — just accept
    await tester.tap(find.text('Accept'));
    await tester.pumpAndSettle();

    expect(find.text('We value your privacy'), findsNothing);
    expect(consentService.analyticsAllowed, isTrue);
  });

  testWidgets('hides banner after accepting with analytics off', (
    tester,
  ) async {
    await pumpBanner(tester);

    // Toggle analytics off (second switch)
    await tester.tap(find.byType(Switch).last);
    await tester.pump();
    await tester.tap(find.text('Accept'));
    await tester.pumpAndSettle();

    expect(find.text('We value your privacy'), findsNothing);
    expect(consentService.analyticsAllowed, isFalse);
  });

  testWidgets('does not show banner if consent already given', (tester) async {
    SharedPreferences.setMockInitialValues({'analytics_consent': true});
    final prefs = await PreferencesService.init();
    consentService = ConsentService(prefs);

    await pumpBanner(tester);

    expect(find.text('We value your privacy'), findsNothing);
  });
}
