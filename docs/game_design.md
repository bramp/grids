# Game Design: Grids

## Overview

"Grids" is a grid-based puzzle game inspired by Taiji and The Witness. The player solves puzzles by toggling cells on a grid to satisfy various rules dictated by symbols on the grid. As the game progresses, it introduces new mechanics and combinations of rules to incrementally increase complexity and difficulty.

## Core Interaction

* **Toggling Cells**: The player taps squares on the grid to toggle them ON (lit) or OFF (unlit).
* **Locked Cells**: A cell enclosed in brackets or visually indicated as "locked" cannot be toggled by the player and must remain in its inherent state (either inherently lit or unlit).
* **Contiguous Areas**: The state of the cells implicitly divides the grid into contiguous areas of lit cells and contiguous areas of unlit cells.
* **Validation**: A puzzle is solved when the state of the grid simultaneously satisfies all rules defined by the symbols present on it, and all locked cells match their expected state.

## Mechanics

Multiple mechanics can intersect in a single grid. The current planned mechanics are:

### 1. Colored Diamonds Constraint

* **Visual**: Specific cells contain colored diamonds (e.g., Red or Black).
* **Rule**: Each contiguous area must contain either exactly zero symbols of a color, or exactly *two* symbols of a color. This rule applies to any Cell sharing that color (e.g. numbered cells, dashed cells, diagonal dash cells, or flower cells which count as both purple and orange) if a diamond is present in the same area.
* **Example**: An area can have two red diamonds, or two black diamonds, or two red AND two black diamonds. It can never have exactly one, or exactly three elements of a given color.
* **Interaction**: The player must create boundaries through toggling, isolating the diamonds appropriately into different contiguous areas to ensure they are paired correctly.

### 2. Strict Number Areas

* **Visual**: Specific cells contain a number (positive or negative).
* **Rule**: The contiguous area (whether lit or unlit) containing this numbered cell must consist of exactly that number of cells.
* **Combination**: Multiple numbered cells can share the exact same contiguous area. If combined, the total area size must exactly equal the sum of those numbers. (For example, a '2' and a '3' in the same area means that area must be exactly 5 cells large.)
* **Negative Numbers**: A cell may contain a negative number (e.g. `-2`). When present alongside positive numbers in the same area, it reduces the required area size. (For example, a `6` and a `-2` together require exactly 4 cells.)
* **Zero and Negative Sums**: If the summed required size of the numbers in an area equals zero, the area is allowed to be of any size. If the sum is a negative number, the area configuration is always considered invalid.

### 3. Number Color Constraint

* **Visual**: Numbered cells are colored.
* **Rule**: If a contiguous area contains any numbers, all numbers in that area must share the exact same color.
* **Example**: A `Red 2` and a `Red 3` can occupy the same contiguous area (requiring size 5). A `Red 2` and a `Blue 3` in the same area violates this rule.

### 4. Flowers

* **Visual**: A flower shape with a specified number of orange petals (0 to 4).
* **Rule**: A flower cell must have exactly `orangePetals` orthogonal adjacent neighbor cells (up, down, left, right) that share the same lit/unlit state as the flower cell itself. The flower also counts as one Orange element and one Purple element when resolving Diamond constraints.

### 5. Colored Dashes

* **Visual**: Specific cells contain colored horizontal dashes (e.g., Red).
* **Rule**: All contiguous areas containing dashes of the *same* color must be identically shaped. Furthermore, the dash cell must occupy the exact same relative position within that shape for every area matching that color.
* **Combination**: If an area has only one dash of a color across the entire board, the rule is trivially satisfied.

### 6. Diagonal Dashes

* **Visual**: Specific cells contain colored diagonal dashes (e.g., Red `/`).
* **Rule**: Functions like the Colored Dash, except it permits rotational matching. An area containing a diagonal dash must map to the shape of other dashes of that color, but it may be rotated by 0, 90, 180, or 270 degrees.
* **Combination**: If there are strict horizontal dashes (`-`) of the same color, the horizontal shape acts as the canonical reference, and all horizontal dashes must match it strictly without rotation, while diagonal dashes (`/`) must match a rotation of it. If there are only diagonal dashes, they must all be rotations of a single canonical shape relative to the dash's position.

## Progression

* **Main Campaign**: A sequence of static, hand-crafted puzzles with a carefully designed difficulty curve to introduce mechanics natively.
* **Future Modes**: Randomly generated puzzles and Daily Puzzles.
* **Platforms**: Initially Web-first, with later expansion to Mobile (iOS/Android) and leaderboards.
