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
