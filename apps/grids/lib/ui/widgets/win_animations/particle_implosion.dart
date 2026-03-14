import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// Particles rush inward from the edges, collide at the centre to form an
/// energy sphere, then pop outward in a circular shockwave ripple.
class ParticleImplosion extends StatefulWidget {
  const ParticleImplosion({
    super.key,
    this.color = const Color(0xFF00FFCC),
    this.particleCount = 80,
    this.duration = const Duration(milliseconds: 2500),
  });

  /// Accent colour for particles and the energy sphere.
  final Color color;

  /// Number of particles pulled inward.
  final int particleCount;

  /// Total animation duration.
  final Duration duration;

  @override
  State<ParticleImplosion> createState() => _ParticleImplosionState();
}

class _Dot {
  _Dot({
    required this.angle,
    required this.startRadius,
    required this.size,
    required this.brightness,
  });

  final double angle;

  /// Distance from centre at t = 0 (normalised to screen diagonal).
  final double startRadius;
  final double size;
  final double brightness;
}

class _ParticleImplosionState extends State<ParticleImplosion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Dot> _dots;
  static final _rng = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _dots = List.generate(widget.particleCount, (_) {
      return _Dot(
        angle: _rng.nextDouble() * 2 * pi,
        startRadius: 0.7 + _rng.nextDouble() * 0.5,
        size: 1.5 + _rng.nextDouble() * 2.5,
        brightness: 0.3 + _rng.nextDouble() * 0.7,
      );
    });

    unawaited(_controller.forward());
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
            painter: _ImplosionPainter(
              progress: _controller.value,
              dots: _dots,
              color: widget.color,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ImplosionPainter extends CustomPainter {
  const _ImplosionPainter({
    required this.progress,
    required this.dots,
    required this.color,
  });

  final double progress;
  final List<_Dot> dots;
  final Color color;

  // Phase boundaries (normalised 0–1).
  static const _implodeEnd = 0.45;
  static const _popAt = 0.50;
  static const _rippleStart = 0.50;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final diagonal = size.longestSide;

    // --- Phase 1: particles rush inward (0 → _implodeEnd) ---
    if (progress < _popAt) {
      final t = (progress / _implodeEnd).clamp(0.0, 1.0);
      final inward = Curves.easeInQuart.transform(t);

      for (final d in dots) {
        final r = d.startRadius * diagonal * (1 - inward);
        final px = cx + r * cos(d.angle);
        final py = cy + r * sin(d.angle);

        final alpha = (d.brightness * (0.4 + inward * 0.6)).clamp(0.0, 1.0);

        // Streak towards centre.
        final tailR = r + d.size * 6 * inward;
        final tailX = cx + tailR * cos(d.angle);
        final tailY = cy + tailR * sin(d.angle);

        canvas
          ..drawLine(
            Offset(tailX, tailY),
            Offset(px, py),
            Paint()
              ..color = color.withValues(alpha: alpha * 0.5)
              ..strokeWidth = d.size * 0.6
              ..strokeCap = StrokeCap.round,
          )
          ..drawCircle(
            Offset(px, py),
            d.size,
            Paint()
              ..color = color.withValues(alpha: alpha)
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, d.size),
          );
      }
    }

    // --- Phase 2: energy sphere pop (_implodeEnd → _popAt + 0.15) ---
    if (progress >= _implodeEnd && progress < _popAt + 0.15) {
      final t = ((progress - _implodeEnd) / 0.20).clamp(
        0.0,
        1.0,
      ); // 0 → 1 over 20%
      // Sphere grows then fades.
      final sphereRadius = Curves.easeOut.transform(t) * diagonal * 0.12;
      final sphereAlpha = (1 - Curves.easeIn.transform(t)) * 0.6;

      canvas
        ..drawCircle(
          Offset(cx, cy),
          sphereRadius,
          Paint()
            ..color = color.withValues(alpha: sphereAlpha.clamp(0, 1))
            ..maskFilter = MaskFilter.blur(
              BlurStyle.normal,
              sphereRadius * 0.5,
            ),
        )
        // White-hot core.
        ..drawCircle(
          Offset(cx, cy),
          sphereRadius * 0.3,
          Paint()
            ..color = Colors.white.withValues(
              alpha: (sphereAlpha * 1.2).clamp(0, 1),
            ),
        );
    }

    // --- Phase 3: expanding ripple rings (_rippleStart → 1.0) ---
    if (progress >= _rippleStart) {
      final t = ((progress - _rippleStart) / (1 - _rippleStart)).clamp(0.0, 1);

      // Draw 3 concentric rings with staggered delays.
      for (var i = 0; i < 3; i++) {
        final delay = i * 0.15;
        final rt = ((t - delay) / (1 - delay)).clamp(0.0, 1.0);
        if (rt <= 0) continue;

        final radius = Curves.easeOutCubic.transform(rt) * diagonal * 0.7;
        final alpha = (1 - Curves.easeIn.transform(rt)) * 0.3;

        canvas.drawCircle(
          Offset(cx, cy),
          radius,
          Paint()
            ..color = color.withValues(alpha: alpha.clamp(0, 1))
            ..strokeWidth = 2.0 - i * 0.5
            ..style = PaintingStyle.stroke,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_ImplosionPainter old) => progress != old.progress;
}
