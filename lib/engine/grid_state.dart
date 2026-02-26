import 'package:grids/engine/grid_point.dart';
import 'package:meta/meta.dart';

/// Represents the transient state of the player's progress (which cells
/// are lit).
/// It does not know about the static structure or mechanics of the puzzle.
@immutable
class GridState {
  /// Internal constructor for high-performance initialization from raw bits.
  const GridState({
    required this.width,
    required this.height,
    required this.bits,
  });

  /// The width of the grid this state applies to.
  final int width;

  /// The height of the grid this state applies to.
  final int height;

  /// A bitset representing the lit state of each cell.
  /// Bit position: y * width + x.
  final BigInt bits;

  /// Returns a new GridState with the lit status of [pt] set to [isLit].
  GridState setLit(GridPoint pt, {required bool isLit}) {
    final mask = _getMask(pt);
    final currentLit = (bits & mask) != BigInt.zero;
    if (currentLit == isLit) return this;
    return GridState(width: width, height: height, bits: bits ^ mask);
  }

  static final _bitMasks = List<BigInt>.generate(
    256, // Supports grids up to 16x16 or similar total cell counts
    (i) => BigInt.one << i,
    growable: false,
  );

  static BigInt _getMask(int index) {
    if (index < _bitMasks.length) return _bitMasks[index];
    return BigInt.one << index;
  }

  /// True if the grid cell at the given point is lit, false otherwise.
  bool isLit(GridPoint pt) => (bits & _getMask(pt)) != BigInt.zero;

  /// Returns a new GridState with the given point toggled.
  GridState toggle(GridPoint pt) {
    return GridState(width: width, height: height, bits: bits ^ _getMask(pt));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridState &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          bits == other.bits;

  @override
  int get hashCode => width.hashCode ^ height.hashCode ^ bits.hashCode;
}
