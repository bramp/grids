import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// A large ring of orbiting energy particles, evoking a particle accelerator
/// chamber behind the puzzle grid.
class ParticleAcceleratorRing extends StatefulWidget {
  const ParticleAcceleratorRing({
    super.key,
    this.particleCount = 60,
    this.color = const Color(0xFF00FFCC),
    this.secondaryColor = const Color(0xFF00BB99),
  });

  /// Number of orbiting particles.
  final int particleCount;

  /// Primary particle color.
  final Color color;

  /// Secondary particle / ring color.
  final Color secondaryColor;

  @override
  State<ParticleAcceleratorRing> createState() =>
      _ParticleAcceleratorRingState();
}

class _RingParticle {
  _RingParticle({
    required this.angle,
    required this.speed,
    required this.radiusOffset,
    required this.brightness,
    required this.size,
  });

  /// Starting angle on the ring (radians).
  final double angle;

  /// Angular speed (radians per second).
  final double speed;

  /// Offset from the nominal ring radius.
  final double radiusOffset;

  final double brightness;
  final double size;
}

class _ParticleAcceleratorRingState extends State<ParticleAcceleratorRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_RingParticle> _particles;

  static final _rng = Random(42);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 600),
    );
    unawaited(_controller.repeat());

    _particles = List.generate(widget.particleCount, (_) {
      return _RingParticle(
        angle: _rng.nextDouble() * 2 * pi,
        speed: 0.8 + _rng.nextDouble() * 0.6,
        radiusOffset: (_rng.nextDouble() - 0.5) * 20,
        brightness: 0.1 + _rng.nextDouble() * 0.3,
        size: 1.0 + _rng.nextDouble() * 2.0,
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
            painter: _AcceleratorPainter(
              particles: _particles,
              color: widget.color,
              secondaryColor: widget.secondaryColor,
              time: _controller.value * 600,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _AcceleratorPainter extends CustomPainter {
  const _AcceleratorPainter({
    required this.particles,
    required this.color,
    required this.secondaryColor,
    required this.time,
  });

  final List<_RingParticle> particles;
  final Color color;
  final Color secondaryColor;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.55; // slightly below center
    final radius = size.shortestSide * 0.38;

    // Draw the ring (faint circle).
    final ringPaint = Paint()
      ..color = secondaryColor.withValues(alpha: 0.06)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(cx, cy), radius, ringPaint);

    // Draw containment arcs.
    final arcPaint = Paint()
      ..color = secondaryColor.withValues(alpha: 0.04)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 4; i++) {
      final startAngle = i * pi / 2 + time * 0.02;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius + 15),
        startAngle,
        pi / 6,
        false,
        arcPaint,
      );
    }

    // Draw orbiting particles.
    for (final p in particles) {
      final angle = p.angle + p.speed * time;
      final r = radius + p.radiusOffset;

      final px = cx + r * cos(angle);
      final py = cy + r * sin(angle);

      // Streak tail (motion blur).
      final tailAngle = angle - 0.15;
      final tailX = cx + r * cos(tailAngle);
      final tailY = cy + r * sin(tailAngle);

      final streakPaint = Paint()
        ..color = color.withValues(alpha: p.brightness * 0.5)
        ..strokeWidth = p.size * 0.8
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(tailX, tailY), Offset(px, py), streakPaint);

      // Bright head.
      final headPaint = Paint()
        ..color = color.withValues(alpha: p.brightness)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size);

      canvas.drawCircle(Offset(px, py), p.size, headPaint);
    }
  }

  @override
  bool shouldRepaint(_AcceleratorPainter old) => time != old.time;
}
