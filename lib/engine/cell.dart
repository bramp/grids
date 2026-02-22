import 'package:meta/meta.dart';

/// The base class for any cell or symbol placed on a cell.
@immutable
abstract class Cell {
  const Cell({this.isLocked = false});
  final bool isLocked;

  /// Returns a copy of this cell with isLocked set to true.
  Cell lock();

  /// Returns a copy of this cell with the specified color.
  Cell withColor(CellColor? color);
}

/// A cell representing a blank space that can be locked (immutable).
class BlankCell extends Cell {
  const BlankCell({super.isLocked = false});

  @override
  Cell lock() => const BlankCell(isLocked: true);

  @override
  Cell withColor(CellColor? color) => this; // Blank cells don't have color.

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlankCell &&
          runtimeType == other.runtimeType &&
          isLocked == other.isLocked;

  @override
  int get hashCode => isLocked.hashCode;

  @override
  String toString() => 'Blank(locked: $isLocked)';
}

/// Represents a specific color for cells like diamonds or numbers.
enum CellColor { red, black, blue, yellow, purple, white, cyan }

/// The Diamond cell.
class DiamondCell extends Cell {
  const DiamondCell(this.color, {super.isLocked = false});
  final CellColor color;

  @override
  Cell lock() => DiamondCell(color, isLocked: true);

  @override
  Cell withColor(CellColor? color) =>
      DiamondCell(color ?? this.color, isLocked: isLocked);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiamondCell &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          isLocked == other.isLocked;

  @override
  int get hashCode => color.hashCode ^ isLocked.hashCode;

  @override
  String toString() => 'Diamond($color)';
}

/// The Strict Number cell.
class NumberCell extends Cell {
  const NumberCell(
    this.number, {
    this.color = CellColor.black,
    super.isLocked = false,
  });
  final int number;
  final CellColor color;

  @override
  Cell lock() => NumberCell(number, color: color, isLocked: true);

  @override
  Cell withColor(CellColor? color) =>
      NumberCell(number, color: color ?? this.color, isLocked: isLocked);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberCell &&
          runtimeType == other.runtimeType &&
          number == other.number &&
          color == other.color &&
          isLocked == other.isLocked;

  @override
  int get hashCode => number.hashCode ^ color.hashCode ^ isLocked.hashCode;

  @override
  String toString() => 'Number($number, color: $color)';
}
