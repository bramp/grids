import 'package:flutter_test/flutter_test.dart';
import 'package:grids/services/consent_service.dart';
import 'package:grids/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PreferencesService prefs;
  late ConsentService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await PreferencesService.init();
    service = ConsentService(prefs, debugOverride: false);
  });

  test('initial state is needsConsent with analytics off', () {
    expect(service.needsConsent, isTrue);
    expect(service.analyticsAllowed, isFalse);
  });

  test('accepting analytics persists and updates state', () async {
    await service.setAnalyticsConsent(allowed: true);

    expect(service.needsConsent, isFalse);
    expect(service.analyticsAllowed, isTrue);
    expect(prefs.getBool('analytics_consent'), isTrue);
  });

  test('declining analytics persists and updates state', () async {
    await service.setAnalyticsConsent(allowed: false);

    expect(service.needsConsent, isFalse);
    expect(service.analyticsAllowed, isFalse);
    expect(prefs.getBool('analytics_consent'), isFalse);
  });

  test('restores previously accepted consent from prefs', () async {
    SharedPreferences.setMockInitialValues({'analytics_consent': true});
    prefs = await PreferencesService.init();
    final restored = ConsentService(prefs, debugOverride: false);

    expect(restored.needsConsent, isFalse);
    expect(restored.analyticsAllowed, isTrue);
  });

  test('restores previously declined consent from prefs', () async {
    SharedPreferences.setMockInitialValues({'analytics_consent': false});
    prefs = await PreferencesService.init();
    final restored = ConsentService(prefs, debugOverride: false);

    expect(restored.needsConsent, isFalse);
    expect(restored.analyticsAllowed, isFalse);
  });

  test('debug mode overrides consent', () async {
    service = ConsentService(prefs);
    expect(service.needsConsent, isFalse);
    expect(service.analyticsAllowed, isTrue);
  });

  test('notifies listeners on consent change', () async {
    var notified = false;
    service.addListener(() => notified = true);

    await service.setAnalyticsConsent(allowed: true);
    expect(notified, isTrue);
  });
}
