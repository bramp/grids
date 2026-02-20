# Grids

"Grids" is an interactive, grid-based puzzle game inspired by Taiji and The Witness. Built cross-platform with Flutter using modern, strict Dart testing environments and `provider` state management.

## Documentation

* [Game Design Document](docs/game_design.md): Explains the overarching puzzle rules, how different grid mechanics work, and rule logic.
* [Architecture Design Document](docs/architecture_design.md): High-level overview of the application components and tech stack.
* [TODO Tracker](TODO.md): Track the immediate goals and task progress.

## Setup & Running

This project uses the standard Flutter framework.

1. Ensure you have Flutter SDK installed (3.11.0 or newer).
2. Install packages:
   ```bash
   flutter pub get
   ```
3. Run or deploy to your target emulator/browser:
   ```bash
   flutter run -d chrome
   ```
   (Alternatively, use `-d macos` or an iPhone/Android emulator).

## Testing

The core engine is 100% decoupled from the UI, so it is extensively tested via unit tests. Run all tests locally with:
```bash
flutter test
```

## Development

To ensure code quality and consistency, we use [pre-commit](https://pre-commit.com/) hooks. To set them up locally:

1. Install `pre-commit` (e.g., `brew install pre-commit`).
2. Install the hooks in the repository:
   ```bash
   pre-commit install
   ```

The hooks will now run automatically on every `git commit`. You can also run them manually on all files:
```bash
pre-commit run --all-files
```

### Puzzle Solver CLI

The project includes a brute-force solver that can find all possible solutions for the levels defined in the game.

To run a summary of all levels:
```bash
dart run bin/solve.dart
```

To see all solutions for a specific level (and copy-pastable ASCII):
```bash
dart run bin/solve.dart shrine_5
```

This tool is useful for verifying puzzle uniqueness and ensuring that every level in the repository is actually solvable.
