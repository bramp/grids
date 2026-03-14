# lib/solver/

Solving utilities used by the CLI tools — not part of the core engine.

Contains caching and metrics logic specific to the offline solve pipeline. These
depend on `dart:io` and `package:crypto`, so they must not be imported by the
Flutter app or the core engine.

- **solve_cache** — Per-puzzle file-based cache for solve results.
- **puzzle_metrics** — Playable cell counting and difficulty rating heuristics.
