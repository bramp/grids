import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// A hyperspace / warp-speed star field — stars spawn near the centre and
/// accelerate outward, stretching into speed lines as they approach the edges.
class WarpDriveStarField extends StatefulWidget {
  const WarpDriveStarField({
    super.key,
    this.random,
    this.starCount = 150,
    this.color = const Color(0xFF00FFCC),
    this.speed = 1.0,
  });

  /// Random source for deterministic output in tests.
  final Random? random;

  /// Number of stars rendered simultaneously.
  final int starCount;

  /// Base star / streak colour.
  final Color color;

  /// Speed multiplier (1.0 = default, >1 = faster streaking).
  final double speed;

  @override
  State<WarpDriveStarField> createState() => _WarpDriveStarFieldState();
}

class _Star {
  _Star({
    required this.angle,
    required this.depth,
    required this.phase,
    required this.brightness,
  });

  /// Angle from centre (radians).
  final double angle;

  /// Depth layer 0–1 (0 = far / slow, 1 = near / fast).
  final double depth;

  /// Phase offset 0–1 so stars don't all start at the centre at once.
  final double phase;

  /// Base brightness multiplier.
  final double brightness;
}

class _WarpDriveStarFieldState extends State<WarpDriveStarField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // Long repeating cycle; stars recycle via their phase offset.
      duration: const Duration(seconds: 30),
    );
    unawaited(_controller.repeat());

    final rng = widget.random ?? Random(77);
    _stars = List.generate(widget.starCount, (_) {
      return _Star(
        angle: rng.nextDouble() * 2 * pi,
        depth: rng.nextDouble(),
        phase: rng.nextDouble(),
        brightness: 0.3 + rng.nextDouble() * 0.7,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _WarpPainter(
              progress: _controller.value,
              stars: _stars,
              color: widget.color,
              speed: widget.speed,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _WarpPainter extends CustomPainter {
  const _WarpPainter({
    required this.progress,
    required this.stars,
    required this.color,
    required this.speed,
  });

  final double progress;
  final List<_Star> stars;
  final Color color;
  final double speed;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    // Maximum distance from centre to corner.
    final maxDist = sqrt(cx * cx + cy * cy);

    final paint = Paint()..strokeCap = StrokeCap.round;

    for (final star in stars) {
      // Each star travels from centre to edge in a cycle. The phase offsets
      // distribute them so the field always looks full.
      //
      // `t` is 0 at the centre and 1 at the edge. We use a tuned power curve
      // so stars accelerate as they move outward (simulating perspective).
      final loopT = (progress * speed * (0.5 + star.depth) + star.phase) % 1.0;
      final t = Curves.easeInQuad.transform(loopT);

      final dist = t * maxDist;

      // Current position.
      final x = cx + cos(star.angle) * dist;
      final y = cy + sin(star.angle) * dist;

      // Trail: a shorter segment towards the centre.
      final trailLen = dist * 0.15 * t; // Trail grows with distance.
      final tx = cx + cos(star.angle) * (dist - trailLen);
      final ty = cy + sin(star.angle) * (dist - trailLen);

      // Brightness ramps up with distance and fades at the very end.
      final alphaRamp = t < 0.05
          ? t /
                0.05 // Fade in near centre.
          : t > 0.85
          ? (1 - t) /
                0.15 // Fade out at edge.
          : 1.0;
      final alpha = (star.brightness * alphaRamp).clamp(0.0, 1.0);

      if (alpha < 0.02) continue;

      // Stroke width: thin far away, thicker close.
      final strokeWidth = 0.5 + t * 1.5 * star.depth;

      paint
        ..color = color.withValues(alpha: alpha)
        ..strokeWidth = strokeWidth;

      canvas.drawLine(Offset(tx, ty), Offset(x, y), paint);

      // Bright head dot for the nearest stars.
      if (star.depth > 0.6 && t > 0.3) {
        paint.color = Colors.white.withValues(alpha: alpha * 0.6);
        canvas.drawCircle(Offset(x, y), strokeWidth * 0.6, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_WarpPainter old) =>
      progress != old.progress || speed != old.speed;
}
