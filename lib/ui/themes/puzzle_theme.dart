import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';

/// The base class for all UI visual themes.
abstract class PuzzleTheme {
  const PuzzleTheme();

  /// Human-readable name of the theme.
  String get name;

  /// The overarching background color for the screen/board.
  Color get backgroundColor;

  /// External padding around the whole grid.
  EdgeInsets get gridPadding => const EdgeInsets.all(16);

  /// Spacing between individual cells.
  double get cellPadding;

  /// Optional grid background decoration
  /// (if the theme wants a mat under cells).
  BoxDecoration? get gridBackgroundDecoration => null;

  /// Builds the background container (with borders/colors) for a single cell.
  Widget buildCellBackground(
    BuildContext context, {
    required Cell mechanic,
    required bool isLocked,
    required bool isLit,
    required bool hasError,
    required Widget child,
  });

  /// Builds the visual representation of a Number mechanic.
  Widget buildNumberMechanic(BuildContext context, NumberCell cell);

  /// Builds the visual representation of a Diamond mechanic.
  Widget buildDiamondMechanic(BuildContext context, DiamondCell cell);

  /// Builds the visual representation of a Flower mechanic.
  Widget buildFlowerMechanic(BuildContext context, FlowerCell cell);
}
