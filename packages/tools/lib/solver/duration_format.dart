/// Formats a duration in a human-readable format.
///
/// Use ms for < 100ms.
/// Use seconds for < 60s.
/// Use minutes and seconds otherwise (e.g., 1m30s).
String formatDuration(Duration duration) {
  final ms = duration.inMilliseconds;
  if (ms < 100) {
    return '${ms}ms';
  }

  final seconds = duration.inSeconds;
  if (seconds < 60) {
    final s = (ms / 1000).toStringAsFixed(2);
    return '${s}s';
  }

  final minutes = duration.inMinutes;
  final remainingSeconds = seconds % 60;
  return '${minutes}m${remainingSeconds}s';
}
