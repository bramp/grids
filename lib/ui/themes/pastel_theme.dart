import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';
import 'package:grids/ui/widgets/dice_dots_widget.dart';

class PastelTheme extends PuzzleTheme {
  const PastelTheme();

  @override
  String get name => 'Pastel';

  @override
  // Soft grey-blue background
  Color get backgroundColor => const Color(0xFFC7D0D8);

  @override
  double get cellPadding => 8;

  @override
  BoxDecoration? get gridBackgroundDecoration => BoxDecoration(
    color: const Color(0xFFF0F4F8), // Soft white/cream board base
    borderRadius: BorderRadius.circular(32),
    boxShadow: [
      // Outer drop shadow
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        offset: const Offset(10, 10),
        blurRadius: 20,
      ),
      // Inner highlight
      const BoxShadow(
        color: Colors.white,
        offset: Offset(-10, -10),
        blurRadius: 20,
      ),
    ],
  );

  @override
  Widget buildCellBackground(
    BuildContext context, {
    required Cell mechanic,
    required bool isLocked,
    required bool isLit,
    required bool hasError,
    required Widget child,
  }) {
    // Neumorphic/Claymorphic base
    // If it's lit, it looks pressed IN and glows. If unlit, it pops OUT.

    final Color baseColor;
    if (hasError) {
      baseColor = const Color(0xFFFFD1D1); // Soft pastel red
    } else if (isLit) {
      baseColor = const Color(0xFFFFF9E6); // Very soft yellow glow
    } else {
      baseColor = const Color(0xFFF0F4F8); // Same as board material
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16),
        border: isLit
            ? Border.all(color: const Color(0xFFFFD966), width: 3)
            : null,
        boxShadow: isLit
            ? [
                // Pressed in look
                // (inner shadow via simulation, or tight drop shadow)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
                const BoxShadow(
                  color: Colors.transparent,
                  offset: Offset(-4, -4),
                  blurRadius: 10,
                ),
              ]
            : [
                // Popped out look
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  offset: const Offset(6, 6),
                  blurRadius: 10,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 10,
                ),
              ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          if (isLocked)
            Positioned(
              bottom: 4,
              right: 4,
              child: Icon(
                Icons.lock_rounded,
                color: Colors.blueGrey.withValues(alpha: 0.3),
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget buildNumberMechanic(BuildContext context, NumberCell cell) {
    return _ClaymorphicShape(number: cell.number);
  }

  @override
  Widget buildDiamondMechanic(BuildContext context, DiamondCell cell) {
    // Make diamonds look like soft blue squiggles/swirls
    return const _ClaymorphicShape(number: 99);
  }
}

class _ClaymorphicShape extends StatelessWidget {
  const _ClaymorphicShape({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    final shapeColor = number == 99
        ? const Color(0xFF6A79A5) // Muted navy/purple for diamonds
        : const Color(0xFFFFDF70); // Pastel yellow for numbers

    final widget = DiceDotsWidget(
      number: number == 99
          ? 1
          : number, // Diamonds show 1 dot for now? Or keep swirls?
      dotColor: shapeColor,
    );

    // We do a "clay" effect by drawing the widget twice,
    // shifted to create a 3D bevel.
    // Since DiceDotsWidget is a widget and not a painter,
    // we use opacity or color filters to simulate shadows/highlights.
    return Stack(
      fit: StackFit.expand,
      children: [
        // Drop shadow of the shape
        Transform.translate(
          offset: const Offset(2, 4),
          child: Opacity(
            opacity: 0.2,
            child: DiceDotsWidget(
              number: number == 99 ? 1 : number,
              dotColor: Colors.black,
            ),
          ),
        ),
        // The actual shape
        widget,
        // A white highlight shifted up and left
        Transform.translate(
          offset: const Offset(-1.5, -1.5),
          child: Opacity(
            opacity: 0.5,
            child: DiceDotsWidget(
              number: number == 99 ? 1 : number,
              dotColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// Below are the vector painters for the soft shapes.
