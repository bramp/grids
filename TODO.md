# TODOs

## Puzzle Engine

- [x] Define immutable `GridState`.
- [x] Implement contiguous area extraction (flood-fill algorithm).
- [x] Implement `RuleValidator` interface.
- [x] Implement validation for Colored Diamonds Constraint.
- [x] Implement validation for Strict Number Areas Constraint.
- [x] Add comprehensive unit tests around the validation logic.
- [ ] Puzzle types
  - [x] Numbers, Flowers, Diamonds, Dashes, Diagonal Dashes
  - [ ] Start - end logic
- [ ] Implement different interaction styles
  - [x] Tapping toggles the state
  - [ ] Walking puzzles
  - [ ] Cluster toggling (e.g press and all the squares around change state)

## App Setup

- [x] Setup state management (e.g., Provider/Riverpod).
- [X] Implement local persistence for user progress (unlocked levels, solutions, last played level).
- [x] Verify web builds
- [ ] Verify mobile builds

## UI / Presentation

- [x] Implement `GridWidget` for rendering interactive tiles.
- [x] Implement `CellSymbolRenderer` for numbers.
- [x] Implement `CellSymbolRenderer` for colored diamonds.
- [x] Create basic placeholder artwork/assets for the game.
- [ ] Acquire or design finalized high-quality artwork.
- [x] Build the main Game loop/screen UI.
- [x] When a unlit cell is wrong, it does not light up red.
- [x] Fix accessibility / keyboard use - space to toggle, enter to solve, left-right to switch puzzles, etc.
- [ ] When a lit square is tab focus - you can't tell
- [ ] The lit color now seems a little consistent.

## Sounds

- [ ] Add sound effects for solving puzzles.

## Future / Polish

- [ ] Level Selection screen.
- [ ] Setup Daily Challenges + Leaderboards.
- [ ] The won color is a different shade to the check answer button - fix that.
- [ ] Ensure puzzles are always displayed in the best orentation for the device.
- [x] On web, I need a cookie warning banner.
- [x] I need a privacy policy
- [x] I need a setting / about page
- [x] Move the version number to the setting / about page
- [ ] Give more screen space to the puzzle
- [X] Clicking mine puzzle -> map -> mine puzzle - lands you on mine_2 instead of mine_1
- [ ] Add a hint button
