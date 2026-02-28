import 'package:flutter_test/flutter_test.dart';
import 'package:grids/build_info.dart';

void main() {
  group('BuildInfo', () {
    test('should have default values when not provided via dart-define', () {
      // Note: During normal tests, these will be the default values
      // unless the test is run with `flutter test --dart-define=...`
      expect(BuildInfo.commitHash, 'devel');
      expect(BuildInfo.buildDate, 'unknown');
    });

    test('version string should be formatted correctly', () {
      expect(BuildInfo.version, 'devel (unknown)');
    });

    test('shortVersion string should be formatted correctly', () {
      expect(BuildInfo.shortVersion, 'devel • unknown');
    });
  });
}
