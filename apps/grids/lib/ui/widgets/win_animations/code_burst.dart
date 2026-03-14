import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// Hex-code fragments burst outward from the centre like digital confetti,
/// preceded by a brief full-screen neon flash.
class CodeBurst extends StatefulWidget {
  const CodeBurst({
    super.key,
    this.color = const Color(0xFF00FFCC),
    this.particleCount = 120,
    this.duration = const Duration(milliseconds: 2500),
  });

  /// Accent colour for the flash and text fragments.
  final Color color;

  /// Number of hex-code fragments to spawn.
  final int particleCount;

  /// Total animation duration.
  final Duration duration;

  @override
  State<CodeBurst> createState() => _CodeBurstState();
}

class _Particle {
  _Particle({
    required this.text,
    required this.angle,
    required this.speed,
    required this.rotationSpeed,
    required this.size,
  });

  final String text;

  /// Radial direction (radians).
  final double angle;

  /// Normalised distance per unit time.
  final double speed;

  /// Rotation rate (radians per unit time).
  final double rotationSpeed;

  /// Font size.
  final double size;
}

class _CodeBurstState extends State<CodeBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  static final _rng = Random();

  static const _hexChars = '0123456789ABCDEF';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _particles = List.generate(widget.particleCount, (_) {
      final len = 2 + _rng.nextInt(3); // 2–4 hex chars
      final text = String.fromCharCodes(
        List.generate(len, (_) => _hexChars.codeUnitAt(_rng.nextInt(16))),
      );
      return _Particle(
        text: text,
        angle: _rng.nextDouble() * 2 * pi,
        speed: 0.3 + _rng.nextDouble() * 0.7,
        rotationSpeed: (_rng.nextDouble() - 0.5) * 4,
        size: 8.0 + _rng.nextDouble() * 6,
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
            painter: _CodeBurstPainter(
              progress: _controller.value,
              particles: _particles,
              color: widget.color,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _CodeBurstPainter extends CustomPainter {
  const _CodeBurstPainter({
    required this.progress,
    required this.particles,
    required this.color,
  });

  final double progress;
  final List<_Particle> particles;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxRadius = size.longestSide * 0.8;

    // Phase 1: bright flash (0 → 0.08).
    if (progress < 0.08) {
      final flashAlpha = (1 - progress / 0.08).clamp(0.0, 1.0) * 0.35;
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = color.withValues(alpha: flashAlpha),
      );
    }

    // Phase 2: particles burst outward (0.04 → 1.0).
    if (progress > 0.04) {
      final t = ((progress - 0.04) / 0.96).clamp(0.0, 1.0);
      final alpha = (1 - Curves.easeIn.transform(t)).clamp(0.0, 1.0);
      if (alpha <= 0) return;

      final tp = TextPainter(textDirection: TextDirection.ltr);

      for (final p in particles) {
        final dist = Curves.easeOutCubic.transform(t) * maxRadius * p.speed;
        final px = cx + dist * cos(p.angle);
        final py = cy + dist * sin(p.angle);

        if (px < -50 || px > size.width + 50) continue;
        if (py < -50 || py > size.height + 50) continue;

        canvas
          ..save()
          ..translate(px, py)
          ..rotate(p.rotationSpeed * t * pi);

        tp
          ..text = TextSpan(
            text: p.text,
            style: TextStyle(
              color: color.withValues(alpha: alpha * 0.8),
              fontSize: p.size,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          )
          ..layout()
          ..paint(canvas, Offset(-tp.width / 2, -tp.height / 2));

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(_CodeBurstPainter old) => progress != old.progress;
}
