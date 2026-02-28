/// Build information provided via --dart-define.
class BuildInfo {
  const BuildInfo._();

  /// The Git commit hash of the build.
  static const String commitHash = String.fromEnvironment(
    'COMMIT_HASH',
    defaultValue: 'devel',
  );

  /// The build date and time.
  static const String buildDate = String.fromEnvironment(
    'BUILD_DATE',
    defaultValue: 'unknown',
  );

  /// Returns a combined version string.
  static String get version => '$commitHash ($buildDate)';

  /// Returns a shorter version string for footers.
  static String get shortVersion => '$commitHash • $buildDate';
}
