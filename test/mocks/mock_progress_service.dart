import 'package:grids/services/progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A mock implementation of ProgressService for testing purposes.
/// It uses an in-memory map instead of actual SharedPreferences.
class MockProgressService extends ProgressService {
  MockProgressService(super._prefs);

  static Future<MockProgressService> init() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    return MockProgressService(prefs);
  }
}
