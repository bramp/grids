import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// Neon-colored confetti rectangles burst outward from the centre, tumbling
/// with simulated gravity and air drag.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({
    super.key,
    this.color = const Color(0xFF00FFCC),
    this.particleCount = 100,
    this.duration = const Duration(milliseconds: 3000),
  });

  /// Primary accent colour (also seeds the palette).
  final Color color;

  /// Number of confetti pieces.
  final int particleCount;

  /// Total animation duration.
  final Duration duration;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Piece> _pieces;

  static final _rng = Random(42);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _pieces = _generatePieces(widget.particleCount, widget.color);
    unawaited(_controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static List<_Piece> _generatePieces(int count, Color accent) {
    // Neon palette derived from the accent plus a few fixed party colours.
    final colors = [
      accent,
      const Color(0xFF00FFCC), // Cyan
      const Color(0xFFFF00FF), // Magenta
      const Color(0xFFFFDD00), // Yellow
      const Color(0xFF00FF66), // Green
      const Color(0xFF5555FF), // Blue
    ];

    return List.generate(count, (i) {
      final angle = _rng.nextDouble() * 2 * pi;
      final speed = 0.6 + _rng.nextDouble() * 0.8; // Normalized launch speed.
      return _Piece(
        // Launch direction.
        vx: cos(angle) * speed,
        vy: sin(angle) * speed - 0.3, // Bias upward.
        // 3-axis rotation speeds (radians per normalized-time unit).
        spinX: (_rng.nextDouble() - 0.5) * 12,
        spinY: (_rng.nextDouble() - 0.5) * 10,
        spinZ: (_rng.nextDouble() - 0.5) * 8,
        // Piece dimensions.
        width: 4 + _rng.nextDouble() * 6,
        height: 6 + _rng.nextDouble() * 10,
        color: colors[_rng.nextInt(colors.length)],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ConfettiPainter(
              progress: _controller.value,
              pieces: _pieces,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _Piece {
  const _Piece({
    required this.vx,
    required this.vy,
    required this.spinX,
    required this.spinY,
    required this.spinZ,
    required this.width,
    required this.height,
    required this.color,
  });

  final double vx;
  final double vy;
  final double spinX;
  final double spinY;
  final double spinZ;
  final double width;
  final double height;
  final Color color;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({
    required this.progress,
    required this.pieces,
  });

  final double progress;
  final List<_Piece> pieces;

  /// Gravity strength (pulls pieces downward over time).
  static const _gravity = 1.2;

  /// Air drag coefficient (decelerates horizontal motion).
  static const _drag = 0.4;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = min(size.width, size.height);

    // Phase 0: initial flash (0 → 0.05).
    if (progress < 0.05) {
      final t = progress / 0.05;
      final alpha = 0.3 * (1 - Curves.easeOut.transform(t));
      canvas.drawCircle(
        Offset(cx, cy),
        60 + 40 * t,
        Paint()
          ..color = Colors.white.withValues(alpha: alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
      );
    }

    // Phase 1: confetti pieces (0.02 → 1.0).
    if (progress < 0.02) return;

    final t = ((progress - 0.02) / 0.98).clamp(0.0, 1.0);

    // Fade out in last 30%.
    final fadeAlpha = t > 0.7 ? ((1 - t) / 0.3).clamp(0.0, 1.0) : 1.0;

    final paint = Paint();

    for (final p in pieces) {
      // Physics: position with drag and gravity.
      final dragFactor = 1 - _drag * t;
      final dx = p.vx * t * scale * 0.5 * dragFactor;
      final dy =
          (p.vy * t * scale * 0.5 * dragFactor) + (_gravity * t * t * scale);

      final px = cx + dx;
      final py = cy + dy;

      // Skip pieces fully off screen.
      if (px < -20 || px > size.width + 20 || py > size.height + 20) continue;

      // 3-axis rotation → perspective-projected width/height.
      final rotX = p.spinX * t;
      final rotY = p.spinY * t;
      final rotZ = p.spinZ * t;

      // Project: foreshorten width by cos(rotY), height by cos(rotX).
      final projW = (p.width * cos(rotY)).abs();
      final projH = (p.height * cos(rotX)).abs();

      if (projW < 0.3 && projH < 0.3) continue; // Edge-on, invisible.

      canvas
        ..save()
        ..translate(px, py)
        ..rotate(rotZ);

      paint.color = p.color.withValues(alpha: fadeAlpha);
      canvas
        ..drawRect(
          Rect.fromCenter(center: Offset.zero, width: projW, height: projH),
          paint,
        )
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => progress != old.progress;
}
