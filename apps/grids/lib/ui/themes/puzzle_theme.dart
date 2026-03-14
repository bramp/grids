import 'package:flutter/material.dart';
import 'package:grids_engine/cell.dart';

/// The base class for all UI visual themes.
abstract class PuzzleTheme {
  const PuzzleTheme();

  /// Human-readable name of the theme.
  String get name;

  /// The overarching background color for the screen/board.
  Color get backgroundColor;

  /// Accent color used for highlights, borders, and interactive elements.
  Color get accentColor;

  /// Color shown on the check-answer button when a puzzle is solved.
  Color get solvedColor;

  /// External padding around the whole grid.
  EdgeInsets get gridPadding => const EdgeInsets.all(8);

  /// Animated background layer rendered behind the game UI.
  ///
  /// Override in a theme to provide a custom effect (e.g. floating orbs,
  /// particle fields).
  /// Returns an empty box by default.
  Widget buildScreenBackground(BuildContext context) {
    return const SizedBox.shrink();
  }

  /// Spacing between individual cells.
  double get cellPadding;

  /// Provides the background mat/border for the entire grid.
  Widget buildGridBackground(
    BuildContext context, {
    required bool isSolved,
    required Widget child,
  }) {
    return Container(
      padding: gridPadding,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget buildCellBackground(
    BuildContext context, {
    required Cell mechanic,
    required bool isLocked,
    required bool isLit,
    required bool hasError,
    required bool isHovered,
    required bool isFocused,
    required bool isPressed,
    required Widget child,
    Color? selectionColor,
  });

  /// Builds the visual representation of a Number mechanic.
  Widget buildNumberMechanic(BuildContext context, NumberCell cell);

  /// Builds the visual representation of a Diamond mechanic.
  Widget buildDiamondMechanic(BuildContext context, DiamondCell cell);

  /// Builds the visual representation of a Flower mechanic.
  Widget buildFlowerMechanic(BuildContext context, FlowerCell cell);

  /// Builds the visual representation of a Dash mechanic.
  Widget buildDashMechanic(BuildContext context, DashCell cell);

  /// Builds the visual representation of a Diagonal Dash mechanic.
  Widget buildDiagonalDashMechanic(BuildContext context, DiagonalDashCell cell);
}
