# Game Design: Grids

## Overview
"Grids" is a grid-based puzzle game inspired by Taiji and The Witness. The player solves puzzles by toggling cells on a grid to satisfy various rules dictated by symbols on the grid. As the game progresses, it introduces new mechanics and combinations of rules to incrementally increase complexity and difficulty.

## Core Interaction
* **Toggling Cells**: The player taps squares on the grid to toggle them ON (lit) or OFF (unlit).
* **Contiguous Areas**: The state of the cells implicitly divides the grid into contiguous areas of lit cells and contiguous areas of unlit cells.
* **Validation**: A puzzle is solved when the state of the grid simultaneously satisfies all rules defined by the symbols present on it.

## Mechanics
Multiple mechanics can intersect in a single grid. The current planned mechanics are:

### 1. Colored Diamonds Constraint
* **Visual**: Specific cells contain colored diamonds (e.g., Red or Black).
* **Rule**: Each contiguous area must contain either exactly zero diamonds of a color, or exactly *two* diamonds of a color.
* **Example**: An area can have two red diamonds, or two black diamonds, or two red AND two black diamonds. It can never have exactly one, or exactly three diamonds of a given color.
* **Interaction**: The player must create boundaries through toggling, isolating the diamonds appropriately into different contiguous areas to ensure they are paired correctly.

### 2. Strict Number Areas
* **Visual**: Specific cells contain a number and a color.
* **Rule**: The contiguous area (whether it is lit or unlit) containing this numbered cell must consist of exactly that number of cells.
* **Combination**: Multiple numbered cells can share the exact same contiguous area *if and only if* they have the same color. If combined, the total area size must exactly equal the sum of those numbers. (For example, a red '2' and a red '3' in the same area means that area must be exactly 5 cells large).

## Progression
* **Main Campaign**: A sequence of static, hand-crafted puzzles with a carefully designed difficulty curve to introduce mechanics natively.
* **Future Modes**: Randomly generated puzzles and Daily Puzzles.
* **Platforms**: Initially Web-first, with later expansion to Mobile (iOS/Android) and leaderboards.
