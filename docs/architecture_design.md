# Architecture Design: Grids

## Overview
"Grids" is a Flutter-based puzzle application designed for Web and Mobile platforms. The architecture prioritizes a highly abstracted domain logic model, testability via unit testing, and a robust rule validation system.

## Tech Stack
* **Framework**: Flutter
* **Language**: Dart (Modern with strict null safety)
* **Testing**: `flutter_test` with extensive reliance on pure Dart unit tests.
* **Tooling**: `pre-commit` hooks for automatic formatting (`dart format`) and linting (`flutter analyze`), conforming to typical code standards.

## Architecture Guidelines
The app will use a feature-first architecture, leveraging a robust state management solution (e.g., `Provider` or `Riverpod`) to keep UI cleanly separated from puzzle logic. The separation ensures the puzzle core can completely work headless.

### 1. Domain / Puzzle Engine (`lib/engine/`)
This is the core logic. It must be highly testable without any UI dependencies.
* **`GridState`**: Immutable representation of the puzzle grid (size, cell toggled states, and symbol locations).
* **`RuleValidator`**: An abstract interface. Each specific game mechanic implements this (e.g. `ColorDiamondsValidator`, `NumberAreaValidator`).
* **`PuzzleValidator`**: The overarching engine that extracts all contiguous regions (using flood-fill algorithms) and passes them to the mechanic-specific validators to independently evaluate rules.
* **`GridMechanic`**: Models to represent the specific symbols placed on the grid (e.g., `NumberMechanic`, `DiamondMechanic`).

### 2. Presentation / UI (`lib/ui/`)
* **`GridWidget`**: The main playing area. Automatically scales and renders the cells and listens for taps/drags to toggle cell state via the ViewModel.
* **`CellSymbolRenderer`**: Custom painters or nested Widgets to cleanly draw the numbers, shapes, and their specified colors depending on their context.
* **`PuzzleScreen`**: Manages the active game session, animations, and transitions to "Solve" states.
* **`LevelSelectScreen`**: Allows picking hand-crafted puzzles.

### 3. Data / Persistence (`lib/data/`)
* **Storage**: Local persistence of solved puzzles and player progress, likely using `shared_preferences`.
* **Level Repository**: Loads static definitions of puzzles (from local JSON or precompiled Dart instances).
* **Remote Sync (Future)**: Interface structures ready to integrate Firebase / Cloud storage for daily puzzles and standard cross-device leaderboards.

## Testing Strategy
* **Unit Tests**: As rules will quickly get intricate, `lib/engine/` must be 100% testable via unit tests with mock grid states (solved, unsolved, invalid combinations).
* **Integration Tests**: Tests using `flutter_test` for UI interactions to ensure toggling works reliably on different puzzle layouts.
