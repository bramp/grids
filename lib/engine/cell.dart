import 'package:meta/meta.dart';

/// Represents the interaction state of a cell.
enum LockType {
  /// The cell can be toggled by the player.
  unlocked,

  /// The cell is fixed and must remain lit.
  lockedLit,

  /// The cell is fixed and must remain unlit.
  lockedUnlit,
}

/// The base class for any cell or symbol placed on a cell.
@immutable
abstract class Cell {
  const Cell({this.lockType = LockType.unlocked});

  /// The locking state of this cell.
  final LockType lockType;

  /// Helper to check if the cell is locked.
  bool get isLocked => lockType != LockType.unlocked;

  /// Helper to get the required lit state if locked.
  bool? get lockedLit => switch (lockType) {
    LockType.unlocked => null,
    LockType.lockedLit => true,
    LockType.lockedUnlit => false,
  };

  /// Returns a copy of this cell with a locked state.
  /// [isLit] indicates whether the cell should be locked as lit or unlit.
  Cell lock({required bool isLit});

  /// Returns a copy of this cell with the specified color.
  Cell withColor(CellColor? color);
}

/// A cell representing a blank space that can be locked (immutable).
class BlankCell extends Cell {
  const BlankCell({super.lockType = LockType.unlocked});

  @override
  Cell lock({required bool isLit}) =>
      BlankCell(lockType: isLit ? LockType.lockedLit : LockType.lockedUnlit);

  @override
  Cell withColor(CellColor? color) => this; // Blank cells don't have color.

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlankCell &&
          runtimeType == other.runtimeType &&
          lockType == other.lockType;

  @override
  int get hashCode => lockType.hashCode;

  @override
  String toString() => 'Blank(lock: $lockType)';
}

/// Represents a specific color for cells like diamonds or numbers.
enum CellColor { red, black, blue, yellow, purple, white, cyan, orange }

/// The Diamond cell.
class DiamondCell extends Cell {
  const DiamondCell(this.color, {super.lockType = LockType.unlocked});
  final CellColor color;

  @override
  Cell lock({required bool isLit}) => DiamondCell(
    color,
    lockType: isLit ? LockType.lockedLit : LockType.lockedUnlit,
  );

  @override
  Cell withColor(CellColor? color) =>
      DiamondCell(color ?? this.color, lockType: lockType);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiamondCell &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          lockType == other.lockType;

  @override
  int get hashCode => Object.hash(color, lockType);

  @override
  String toString() => 'Diamond($color, lock: $lockType)';
}

/// The Strict Number cell.
class NumberCell extends Cell {
  const NumberCell(
    this.number, {
    this.color = CellColor.black,
    super.lockType = LockType.unlocked,
  }) : assert(number != 0, 'NumberCell does not support 0');
  final int number;
  final CellColor color;

  @override
  Cell lock({required bool isLit}) => NumberCell(
    number,
    color: color,
    lockType: isLit ? LockType.lockedLit : LockType.lockedUnlit,
  );

  @override
  Cell withColor(CellColor? color) => NumberCell(
    number,
    color: color ?? this.color,
    lockType: lockType,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberCell &&
          runtimeType == other.runtimeType &&
          number == other.number &&
          color == other.color &&
          lockType == other.lockType;

  @override
  int get hashCode => Object.hash(number, color, lockType);

  @override
  String toString() => 'Number($number, color: $color, lock: $lockType)';
}

/// The Flower cell.
class FlowerCell extends Cell {
  const FlowerCell(this.orangePetals, {super.lockType = LockType.unlocked})
    : assert(
        orangePetals >= 0 && orangePetals <= 4,
        'FlowerCell orangePetals must be between 0 and 4',
      );
  final int orangePetals;

  // The remaining petals out of 4 are implicitly purple.
  int get purplePetals => 4 - orangePetals;

  @override
  Cell lock({required bool isLit}) => FlowerCell(
    orangePetals,
    lockType: isLit ? LockType.lockedLit : LockType.lockedUnlit,
  );

  @override
  Cell withColor(CellColor? color) {
    throw UnsupportedError('FlowerCell cannot have a color applied.');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowerCell &&
          runtimeType == other.runtimeType &&
          orangePetals == other.orangePetals &&
          lockType == other.lockType;

  @override
  int get hashCode => Object.hash(orangePetals, lockType);

  @override
  String toString() => 'Flower($orangePetals orange, lock: $lockType)';
}
