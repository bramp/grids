import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/puzzle.dart';

/// Computes a canonical representation of a puzzle that is invariant under
/// grid rotation (0°, 90°, 180°, 270°) and color remapping.
///
/// Two puzzles produce the same canonical signature if and only if one can be
/// transformed into the other by some combination of:
///   1. Rotating the grid by a multiple of 90°.
///   2. Globally substituting one color for another throughout the puzzle.
class PuzzleCanonical {
  PuzzleCanonical._();

  /// Returns a canonical string signature for [puzzle].
  ///
  /// Tries all 4 rotations, assigning canonical color IDs by order of first
  /// appearance (left-to-right, top-to-bottom), and returns the
  /// lexicographically smallest signature.
  static String signature(Puzzle puzzle) {
    String? best;

    for (var r = 0; r < 4; r++) {
      final rotated = rotate(puzzle, r);
      final sig = _signatureWithFirstAppearance(rotated);
      if (best == null || sig.compareTo(best) < 0) best = sig;
    }

    return best!;
  }

  /// Rotates a puzzle by [steps] clockwise 90° steps.
  static Puzzle rotate(Puzzle puzzle, int steps) {
    final n = steps % 4;
    if (n == 0) return puzzle;

    var w = puzzle.width;
    var h = puzzle.height;
    var cells = puzzle.grid.mechanics;
    var bits = puzzle.state.bits;

    for (var step = 0; step < n; step++) {
      final nw = h; // new width = old height
      final nh = w; // new height = old width
      final newCells = List<Cell>.filled(nw * nh, const BlankCell());
      var newBits = BigInt.zero;

      for (var y = 0; y < h; y++) {
        for (var x = 0; x < w; x++) {
          final oi = y * w + x;
          // 90° CW: (x, y) → (h-1-y, x) in new coordinate space
          final nx = h - 1 - y;
          final ny = x;
          final ni = ny * nw + nx;
          newCells[ni] = cells[oi];
          if ((bits >> oi) & BigInt.one == BigInt.one) {
            newBits |= BigInt.one << ni;
          }
        }
      }

      w = nw;
      h = nh;
      cells = newCells;
      bits = newBits;
    }

    return Puzzle(
      grid: Grid(width: w, height: h, mechanics: cells),
      state: GridState(width: w, height: h, bits: bits),
    );
  }

  /// Extracts colors from a cell for first-appearance tracking.
  ///
  /// For [FlowerCell], the majority-petal color is listed first so that
  /// equivalent flowers with swapped colors (e.g. F3 vs F1) register their
  /// colors in the same canonical order.
  static Iterable<CellColor> _cellColors(Cell cell) => switch (cell) {
    DiamondCell() => [cell.color],
    NumberCell() => [cell.color],
    DashCell() => [cell.color],
    DiagonalDashCell() => [cell.color],
    FlowerCell() => [
      if (cell.yellowPetals > cell.purplePetals) ...[
        if (cell.yellowPetals > 0) CellColor.yellow,
        if (cell.purplePetals > 0) CellColor.purple,
      ] else if (cell.purplePetals > cell.yellowPetals) ...[
        if (cell.purplePetals > 0) CellColor.purple,
        if (cell.yellowPetals > 0) CellColor.yellow,
      ] else ...[
        // If tied (2 yellow, 2 purple), order by enum index to be stable
        ...[CellColor.yellow, CellColor.purple]..sort(
          (a, b) => a.index.compareTo(b.index),
        ),
      ],
    ],
    BlankCell() => const <CellColor>[],
    VoidCell() => const <CellColor>[],
  };

  /// Assigns a canonical ID to [color], allocating the next sequential ID if
  /// not already mapped.
  static int _canonicalId(Map<CellColor, int> mapping, CellColor color) {
    return mapping.putIfAbsent(color, () => mapping.length);
  }

  /// Builds the signature string for [puzzle], assigning canonical color IDs
  /// by order of first appearance scanning left-to-right, top-to-bottom.
  ///
  /// Format: `{width}x{height};{cell};{cell};...`
  ///
  /// Each cell token encodes its type, parameters (with remapped color IDs),
  /// lock state, and lit state.
  static String _signatureWithFirstAppearance(Puzzle puzzle) {
    final mapping = <CellColor, int>{};
    final buf = StringBuffer()..write('${puzzle.width}x${puzzle.height}');

    for (var i = 0; i < puzzle.mechanics.length; i++) {
      buf.write(';');
      final cell = puzzle.mechanics[i];
      final lit = puzzle.isLit(GridPoint(i));

      // Register colors in cell-order so the first-seen color gets ID 0.
      for (final c in _cellColors(cell)) {
        _canonicalId(mapping, c);
      }

      switch (cell) {
        case BlankCell():
          buf.write('B');
        case VoidCell():
          buf.write('V');
        case DiamondCell():
          buf.write('D${mapping[cell.color]}');
        case NumberCell():
          buf.write('N${cell.number}c${mapping[cell.color]}');
        case FlowerCell():
          final pairs = <(int, int)>[];
          if (cell.yellowPetals > 0) {
            pairs.add((mapping[CellColor.yellow]!, cell.yellowPetals));
          }
          if (cell.purplePetals > 0) {
            pairs.add((mapping[CellColor.purple]!, cell.purplePetals));
          }
          pairs.sort((a, b) => a.$1.compareTo(b.$1));
          buf.write('F${pairs.map((p) => '${p.$1}:${p.$2}').join(',')}');
        case DashCell():
          buf.write('H${mapping[cell.color]}');
        case DiagonalDashCell():
          buf.write('X${mapping[cell.color]}');
      }

      // Lock type + Lit state
      buf
        ..write(switch (cell.lockType) {
          LockType.unlocked => 'u',
          LockType.lockedLit => 'l',
          LockType.lockedUnlit => 'n',
        })
        ..write(lit ? '1' : '0');
    }

    return buf.toString();
  }
}
