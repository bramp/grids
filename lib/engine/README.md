# lib/engine/

Core game engine — pure Dart, no Flutter dependencies.

This package defines the fundamental data structures and logic for the grid
puzzle game. Everything here must remain free of Flutter-specific imports so it
can be used from CLI tools and pure Dart tests.

## Key concepts

- **Grid / GridState** — Static grid structure and transient cell state.
- **Puzzle** — Combines a grid with its current state; the central game object.
- **Cell / CellMechanic** — Cell types and their rule-checking behaviour.
- **PuzzleSolver** — Brute-force solver with error histogram analysis.
- **PuzzleValidator / RuleValidator** — Validation of puzzle correctness.
- **Level / LevelGroup** — Organisational wrappers for presenting puzzles.
- **GridFormat** — ASCII serialisation for puzzles and solution masks.
- **PuzzleCanonical** — Rotation/colour-invariant canonical signatures.
