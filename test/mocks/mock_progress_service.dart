import 'package:grids/services/preferences_service.dart';
import 'package:grids/services/progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A mock implementation of ProgressService for testing purposes.
/// It uses an in-memory map instead of actual SharedPreferences.
class MockProgressService extends ProgressService {
  MockProgressService(this.preferencesService) : super(preferencesService);

  final PreferencesService preferencesService;

  static Future<MockProgressService> init() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await PreferencesService.init();
    return MockProgressService(prefs);
  }
}
