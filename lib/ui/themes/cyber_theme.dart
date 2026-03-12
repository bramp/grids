import 'package:flutter/material.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';
import 'package:grids/ui/widgets/dice_dots_widget.dart';

/// Inset of the neon tube from the edge of the grid, must match
/// [_NeonTubePainter.inset].
const double _neonTubeInset = 13;

class CyberTheme extends PuzzleTheme {
  const CyberTheme();

  @override
  String get name => 'Cyber';

  @override
  Color get backgroundColor => const Color(0xFF0D0E15); // Deep dark blue-black

  @override
  double get cellPadding => 6;

  @override
  Widget buildGridBackground(
    BuildContext context, {
    required bool isSolved,
    required Widget child,
  }) {
    return Container(
      padding: gridPadding,
      child: Stack(
        children: [
          // Surround the entire grid in a cyan neon tube
          Positioned.fill(
            child: CustomPaint(
              painter: _NeonTubePainter(
                color: const Color(0xFF00FFCC), // Default Cyan
                isLit: isSolved,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2 * cellPadding + _neonTubeInset),
            child: child,
          ),
        ],
      ),
    );
  }

  @override
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
  }) {
    // Determine the neon tube color
    Color glowColor;
    if (hasError) {
      glowColor = Colors.redAccent;
    } else {
      // All cells use the same selection color (defaults to neon green)
      glowColor = selectionColor ?? _getColor(CellColor.green);
    }

    final isInteractable = !isLocked;

    // Scale: pressed cells depress into the board
    final moveScale = isPressed ? 0.93 : 1.0;

    // --- Fill color ---
    // Lit: pastel version of the glow color
    // Unlit: dark slab
    const cellDarkColor = Color(0xFF161822);
    final cellColor = isLit
        ? Color.lerp(cellDarkColor, glowColor, 0.2)!
        : cellDarkColor;

    // --- Outer border (thin cell frame) ---
    final outerBorderColor = ((isHovered || isFocused) && isInteractable)
        ? Colors.white.withValues(alpha: 0.3) // Subtle white edge highlight
        : glowColor.withValues(alpha: hasError ? 0.8 : (isLit ? 0.4 : 0.12));

    return LayoutBuilder(
      builder: (context, constraints) {
        final s = constraints.maxHeight;
        final cellBorderRadius = s * 0.15;

        // --- Shadows ---
        final shadows = <BoxShadow>[
          // Neon bloom when lit (external glow around the cell)
          // To reduce the overlap problem across grid cells,
          // spread and blur are minimized.
          if (isLit || hasError) ...[
            BoxShadow(
              color: glowColor.withValues(alpha: 0.3),
              blurRadius: s * 0.15,
            ),
            BoxShadow(
              color: glowColor.withValues(alpha: 0.1),
              blurRadius: s * 0.3,
              spreadRadius: s * 0.02,
            ),
          ],
        ];

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          transformAlignment: Alignment.center,
          transform: Matrix4.diagonal3Values(moveScale, moveScale, 1),
          decoration: BoxDecoration(
            color: cellColor,
            borderRadius: BorderRadius.circular(cellBorderRadius),
            border: Border.all(color: outerBorderColor),
            boxShadow: shadows,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Sunken inner shadow for locked cells
              if (isLocked) ...[
                // Top-left dark edge (shadow falls into recess)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cellBorderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Bottom-right highlight (far lip of recess)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cellBorderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.center,
                      colors: [
                        Colors.white.withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],

              // Neon tube (inset glowing border)
              CustomPaint(
                painter: _NeonTubePainter(
                  color: glowColor,
                  isLit: isLit || hasError,
                  inset: s * 0.05,
                  tubeWidth: s * 0.04,
                  cornerRadius: cellBorderRadius * 0.8,
                  glow1Blur: s * 0.08,
                  glow1Spread: s * 0.04,
                  glow2Blur: s * 0.03,
                  glow2Spread: s * 0.02,
                  edgeSpread: s * 0.02,
                  coreBlur: s * 0.01,
                ),
              ),

              child,

              // Small padlock icon for locked cells (1/4 height)
              if (isLocked)
                Positioned.fill(
                  child: Align(
                    alignment: const Alignment(0.8, 0.8),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: s * 0.25,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildNumberMechanic(BuildContext context, NumberCell cell) {
    final color = _getColor(cell.color);

    return LayoutBuilder(
      builder: (context, constraints) {
        final s = constraints.maxHeight;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: DiceDotsWidget(
            key: ValueKey('${cell.number}_${cell.color}'),
            number: cell.number,
            dotColor: color,
            backgroundColor: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.8),
                blurRadius: s * 0.1,
                spreadRadius: s * 0.01,
              ),
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: s * 0.2,
                spreadRadius: s * 0.02,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildDiamondMechanic(BuildContext context, DiamondCell cell) {
    // For Cyber Theme, diamonds are glowing lightning bolts
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: CustomPaint(
        key: ValueKey('lightning_${cell.color}'),
        painter: _CyberLightningPainter(
          color: _getColor(cell.color),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  @override
  Widget buildFlowerMechanic(BuildContext context, FlowerCell cell) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: CustomPaint(
        key: ValueKey('flower_${cell.yellowPetals}'),
        painter: _CyberFlowerPainter(
          yellowPetals: cell.yellowPetals,
          purplePetals: cell.purplePetals,
          yellowColor: _getColor(CellColor.yellow),
          purpleColor: _getColor(CellColor.purple),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  @override
  Widget buildDashMechanic(BuildContext context, DashCell cell) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: CustomPaint(
        key: ValueKey('dash_${cell.color}'),
        painter: _CyberDashPainter(
          color: _getColor(cell.color),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  @override
  Widget buildDiagonalDashMechanic(
    BuildContext context,
    DiagonalDashCell cell,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: CustomPaint(
        key: ValueKey('diagonal_dash_${cell.color}'),
        painter: _CyberDiagonalDashPainter(
          color: _getColor(cell.color),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  Color _getColor(CellColor color) {
    switch (color) {
      case CellColor.red:
        return const Color(0xFFFF0055); // Neon Pink/Red
      case CellColor.black:
        return const Color(0xFF00FFCC); // Default Neon Cyan (mapped from black)
      case CellColor.blue:
        return const Color(0xFF0055FF); // Neon Blue
      case CellColor.yellow:
        return const Color(0xFFFFDD00); // Neon Yellow
      case CellColor.purple:
        return const Color(0xFFAA00FF); // Neon Purple
      case CellColor.white:
        return const Color(0xFFFFFFFF); // Pure White
      case CellColor.cyan:
        return const Color(0xFF00FFCC); // Neon Cyan
      case CellColor.green:
        return const Color(0xFF39FF14); // Neon Green
    }
  }
}

/// Paints a glowing "neon tube" rounded rectangle inset from the cell edges.
///
/// When [isLit], the tube is bright with multiple glow layers for a bloom
/// effect plus a white hot-core highlight. When unlit, a dim outline is drawn.
class _NeonTubePainter extends CustomPainter {
  const _NeonTubePainter({
    required this.color,
    required this.isLit,
    this.inset = 13.0,
    this.tubeWidth = 9.0,
    this.cornerRadius = 9.0,
    this.glow1Blur = 10.0,
    this.glow1Spread = 10.0,
    this.glow2Blur = 4.0,
    this.glow2Spread = 4.0,
    this.edgeSpread = 4.0,
    this.coreBlur = 1.0,
  });

  final Color color;
  final bool isLit;
  final double inset;
  final double tubeWidth;
  final double cornerRadius;
  final double glow1Blur;
  final double glow1Spread;
  final double glow2Blur;
  final double glow2Spread;
  final double edgeSpread;
  final double coreBlur;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(cornerRadius),
    );

    if (isLit) {
      // Wide outer glow
      canvas
        ..drawRRect(
          rrect,
          Paint()
            ..color = color.withValues(alpha: 0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = tubeWidth + glow1Spread
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, glow1Blur),
        )
        // Medium glow
        ..drawRRect(
          rrect,
          Paint()
            ..color = color.withValues(alpha: 0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = tubeWidth + glow2Spread
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, glow2Blur),
        );
    }

    // Dark physical tube edge
    canvas
      ..drawRRect(
        rrect,
        Paint()
          ..color = Colors.black.withValues(alpha: isLit ? 0.8 : 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = tubeWidth + edgeSpread,
      )
      // Core colored tube body
      ..drawRRect(
        rrect,
        Paint()
          ..color = isLit ? color : color.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = tubeWidth,
      );

    if (isLit) {
      // White-hot center highlight (neon tube glass reflection)
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = tubeWidth * 0.35
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, coreBlur),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NeonTubePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.isLit != isLit ||
        oldDelegate.inset != inset ||
        oldDelegate.tubeWidth != tubeWidth ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.glow1Blur != glow1Blur ||
        oldDelegate.glow1Spread != glow1Spread ||
        oldDelegate.glow2Blur != glow2Blur ||
        oldDelegate.glow2Spread != glow2Spread ||
        oldDelegate.edgeSpread != edgeSpread ||
        oldDelegate.coreBlur != coreBlur;
  }
}

class _CyberLightningPainter extends CustomPainter {
  const _CyberLightningPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.shortestSide * 0.1);

    final w = size.width;
    final h = size.height;

    // A classic lightning bolt shape
    final path = Path()
      ..moveTo(w * 0.6, h * 0.2)
      ..lineTo(w * 0.35, h * 0.55)
      ..lineTo(w * 0.5, h * 0.55)
      ..lineTo(w * 0.4, h * 0.8)
      ..lineTo(w * 0.75, h * 0.45)
      ..lineTo(w * 0.55, h * 0.45)
      ..close();

    canvas
      ..drawPath(path, shadowPaint)
      ..drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CyberLightningPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _CyberFlowerPainter extends CustomPainter {
  const _CyberFlowerPainter({
    required this.yellowPetals,
    required this.purplePetals,
    required this.yellowColor,
    required this.purpleColor,
  });

  final int yellowPetals;
  final int purplePetals;
  final Color yellowColor;
  final Color purpleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final radius = size.width * 0.25;

    // Draw the center core
    final corePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final coreShadowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        size.shortestSide * 0.05,
      );

    canvas
      ..drawCircle(center, radius * 0.5, coreShadowPaint)
      ..drawCircle(center, radius * 0.5, corePaint);

    final totalPetals = yellowPetals + purplePetals;
    if (totalPetals == 0) return;

    for (var i = 0; i < totalPetals; i++) {
      // Rotate by -90 degrees (pi/2) to start pointing UP
      final angle = (i * 2 * 3.14159 / totalPetals) - 1.5708;

      final isYellow = i < yellowPetals;
      final color = isYellow ? yellowColor : purpleColor;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final shadowPaint = Paint()
        ..color = color.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          size.shortestSide * 0.1,
        );

      canvas
        ..save()
        ..translate(cx, cy)
        ..rotate(angle);

      // Draw a teardrop / leaf petal shape pointing 'right' in transformed space
      // which corresponds to 'outward' from the center.
      final path = Path()
        ..moveTo(radius * 0.6, 0)
        ..quadraticBezierTo(radius * 1.5, -radius * 0.8, radius * 2.0, 0)
        ..quadraticBezierTo(radius * 1.5, radius * 0.8, radius * 0.6, 0)
        ..close();

      canvas
        ..drawPath(path, shadowPaint)
        ..drawPath(path, paint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CyberFlowerPainter oldDelegate) {
    return oldDelegate.yellowPetals != yellowPetals ||
        oldDelegate.purplePetals != purplePetals ||
        oldDelegate.yellowColor != yellowColor ||
        oldDelegate.purpleColor != purpleColor;
  }
}

class _CyberDashPainter extends CustomPainter {
  const _CyberDashPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.shortestSide * 0.1);

    // A horizontal dash
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: size.width * 0.5,
        height: size.height * 0.15,
      ),
      Radius.circular(size.height * 0.05),
    );

    canvas
      ..drawRRect(rect, shadowPaint)
      ..drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _CyberDashPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _CyberDiagonalDashPainter extends CustomPainter {
  const _CyberDiagonalDashPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.shortestSide * 0.1);

    // A horizontal dash, rotated by 45 degrees
    canvas
      ..save()
      ..translate(cx, cy)
      ..rotate(-45 * 3.14159 / 180);

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.5,
        height: size.height * 0.15,
      ),
      Radius.circular(size.height * 0.05),
    );

    canvas
      ..drawRRect(rect, shadowPaint)
      ..drawRRect(rect, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _CyberDiagonalDashPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
