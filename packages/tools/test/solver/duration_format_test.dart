import 'package:grids_tools/solver/duration_format.dart';
import 'package:test/test.dart';

void main() {
  group('formatDuration', () {
    test('less than 100ms', () {
      expect(formatDuration(const Duration(milliseconds: 5)), '5ms');
      expect(formatDuration(const Duration(milliseconds: 99)), '99ms');
    });

    test('between 100ms and 60s', () {
      expect(formatDuration(const Duration(milliseconds: 100)), '0.10s');
      expect(formatDuration(const Duration(milliseconds: 1234)), '1.23s');
      expect(formatDuration(const Duration(milliseconds: 6000)), '6.00s');
      expect(
        formatDuration(
          const Duration(seconds: 59, milliseconds: 999),
        ),
        '60.00s',
      );
    });

    test('60s or more', () {
      expect(
        formatDuration(const Duration(minutes: 1, seconds: 30)),
        '1m30s',
      );
      expect(
        formatDuration(const Duration(minutes: 5, seconds: 1)),
        '5m1s',
      );
      expect(
        formatDuration(
          const Duration(hours: 1, minutes: 2, seconds: 3),
        ),
        '62m3s',
      );
    });
  });
}
