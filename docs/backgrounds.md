# Background Design Concepts

> **Status key:** ✅ Implemented · ❌ Cut · 📋 Planned

## Dark Cyber Backgrounds

![Cyber Grid Backgrounds](cyber_grid_backgrounds.png)

### 1. ❌ The "Blueprint" Grid

*Cut — too similar to Bio-Neural Network and added visual clutter without interesting motion.*

Since this is a grid-based puzzle, a faint, large-scale coordinate system or technical grid can ground the UI.

- **The Look:** Very thin, dark grey or deep teal lines (just a few shades lighter than the background).
- **The Polish:** Add tiny, non-functional "serial numbers" or "axis coordinates" in the corners of the screen in a mono-spaced font.
- **Movement:** A very slow, 1-pixel-per-second diagonal scroll to give it a "living" feel.

### 2. ✅ Gaussian "Cloud" Orbs

Soft, out-of-focus blobs of color that drift behind the UI.

- **The Look:** Use the same green and teal from your UI, but at roughly 5-10% opacity and heavily blurred.
- **The Polish:** When the user toggles a cell, have a corresponding orb in the background pulse slightly or move toward that quadrant. It creates a sense of "energy" reacting to the player.

### 3. 📋 Circuit Pathing

Thin, geometric lines that look like a PCB (Printed Circuit Board).

- **The Look:** 45-degree and 90-degree lines connecting nothing in particular.
- **The Polish:** Occasionally, a "pulse" of light travels along one of these lines and disappears. This is great for filling the empty space on the sides without distracting from the center grid.

### 4. ✅ Parallax Depth

Create a subtle sense of 3D space.

- **The Look:** A layer of "dust" or tiny particles (1x1 pixel dots) that sit "behind" the puzzle.
- **The Polish:** Link the background layer's position to the device's gyroscope (on mobile) or the mouse position (on desktop). Moving the mouse slightly shifts the background in the opposite direction, making the puzzle feel like it's floating.

---

## Animated / Reactive Backgrounds

![Cyber Grid Backgrounds 2](cyber_grid_backgrounds_2.png)

### 1. ✅ Flowing Plasma Trails

Imagine very subtle, thin, almost smoke-like wisps of color, at about 10-15% opacity, drifting slowly behind the grid. When a cell is toggled, it could emit a faster "burst" that merges into these slow plasma currents.

### 2. ✅ Matrix Data Rain (Highly Stylized)

Instead of the classic green code, use very dark grey, tiny hexadecimal numbers (e.g., 0A B2 CC) falling slowly in columns. When the player triggers a combo or completes a level, a single column of code matching your neon green/teal accent could flash and scroll quickly.

### 3. ✅ Sound Waves (Reacting to Input)

The orbs and stars provide a static field. Add a few very thin, horizontal lines that sit at the top and bottom of the play area. When the user interacts, these lines should briefly deflect and ripple like an oscilloscope, giving visual feedback to sound (even if the sound is just on-tap).

### 4. ❌ Holographic Topography Maps

*Cut — the slow 3D contour rotation felt too busy behind the puzzle grid.*

Faint, interlocking contours that slowly rotate in 3D space behind the grid. They don't have to look like real mountains; think stylized data visualization. This adds a sense of immense, intangible space.

### 5. 📋 Warp Drive Star Field

A hyperspace / warp-speed effect — stars streak past the viewer from a central
vanishing point.

- **The Look:** Tiny white/cyan star dots spawn near the screen centre and
  accelerate outward, stretching into speed lines as they approach the edges.
  Brightness and trail length increase with distance from the origin, simulating
  depth and velocity.
- **The Polish:** Stars are randomly distributed across multiple depth layers.
  Nearer stars are brighter and move faster, creating a natural parallax. A
  subtle bloom or glow on the brightest streaks adds punch without overwhelming
  the puzzle overlay.

---

## Light Theme Concepts

### 1. 📋 The "Ghost Layer" Look

Instead of your cells being dark boxes, make the entire interface background pure white. The grid lines should be faint grey.

- **The Look:** When a cell is toggled "ON," it doesn't just fill with light; it generates a strong, soft inner shadow and a subtle outer glow using your neon colors.
- **The Polish:** The dot in the center should be very saturated (the dark teal you're currently using, or even darker). This makes the cell feel like a light under a frosted white panel.

### 2. 📋 Negative Glow (Shadow as Light)

This is a sophisticated design technique. Instead of objects emitting light, they look like they are set into the white surface, and the shadows they cast are tinted with your accent colors.

- **The Look:** Toggled cells are depressed into the screen. The shadows "cast" into the recesses of these cells are colored deep neon green or teal.
- **The Polish:** Add a thin border in your accent color, but make it slightly darker so it holds definition on the white.

### 3. ✅ "Augmented Reality" Interface

Imagine you are viewing the game through specialized AR glasses against a clean white wall.

- **The Look:** Keep your text (like "Check Answer") black or dark grey. Make all grid lines and active cell elements very thin but highly saturated neon.
- **The Polish:** Add a subtle, almost imperceptible scan-line texture over the entire screen to sell the "digital overlay" concept. A faint, low-opacity AR "depth marker" (like Z-AXIS: 0.15) in the corner adds detail.

---

## Dark & Tech Noir Concept Sketches

The goal here is complexity without clutter. By using low opacity, dark core colors, and purposeful glowing accents, we keep the main gameplay grid as the hero.

![Cyber Grid Backgrounds 3](cyber_grid_backgrounds_3.png)

### Concept 1: ✅ The Bio-Neural Network

This shifts the vibe from cybernetics to organic tech. The background is a dense, faint network of glowing bio-luminescent tendrils that look like a neural scan of a complex organism. When you toggle a cell, it looks like you are activating or "lighting up" a portion of this neural path. The lines are thin and use your deep green and teal at low opacity, only brightening at the cell junction.

### Concept 2: ❌ Geometric Data Topography

*Cut — the low-polygon landscape competed with the puzzle grid for visual attention.*

Instead of a smooth contour map, this is a visualization of large-scale data. The background is a sparse landscape of low-polygon mountains or data spikes. The slopes are barely defined in dark grey, but the vertices and highest peaks have small, soft-glowing points in your neon green. It gives a sense of flying over a massive, alien data bank.

### Concept 3: ✅ The Particle Accelerator Ring

This is all about contained energy and motion. The grid sits inside a large, circular chamber. In the far depth, there is a giant ring. Faint, fast-moving energy particles (tiny, streaking teal and green lines) orbit this ring. There are subtle "arches" that contain this energy, and one arch is visible in the corner. When you complete a pattern, the orbit flashes and speeds up.

### Concept 4: ❌ Celestial Blueprint Grid

*Cut — too similar to Bio-Neural Network; the star-field tracking lines didn't add enough visual distinction.*

This merges your stars with a coordinate system. Behind your main grid is a very large-scale, thin, technical Cartesian coordinate plane (X/Y axes with coordinates like [0, -125]). Instead of a dense field, the stars are sparse but have very fine 'tracking lines' connecting them, making the entire galaxy look like a massive, curated technical schematic. The colors are strictly muted, cool teals.

### Concept 5: ❌ Deep-Level Cavern Scan

*Cut — the radar-scan overlay with text readouts was too distracting and cluttered the UI.*

Imagine your puzzle is an overlay on a radar scan of an uncharted underground ruin. The background is a subtle, mottled texture of dark rock. Overlaying this texture are very fine, low-contrast, technical grid lines that shift and redraw. There are tiny, blinking 'ping' markers and faint text readouts like SECTOR 7-G and SCAN COMPLETE 98.4% in a corner, giving it a heavy research-terminal feel.
