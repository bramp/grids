# bin/

Command-line tools for offline puzzle analysis and generation.

These are standalone Dart scripts run via `dart run bin/<tool>.dart` — they are
not part of the Flutter app.

## Tools

- **solve.dart** — Solves all puzzles and prints summary statistics, difficulty
  ratings, and error histograms. Supports `--csv` for machine-readable output.
- **generator.dart** — Generates new puzzle definitions.
