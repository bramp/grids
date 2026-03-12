import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// A field of tiny dust particles that shift with the pointer position,
/// creating a parallax "3D floating" effect behind the puzzle.
///
/// On desktop/web the parallax follows the mouse cursor. When no pointer
/// activity is detected, the particles drift gently on their own.
// TODO(bramp): Use device accelerometer/gyroscope on mobile for parallax.
class ParallaxDust extends StatefulWidget {
  const ParallaxDust({
    super.key,
    this.random,
    this.density = 0.0005,
    this.maxShift = 12,
    this.minBrightness = 0.15,
    this.maxBrightness = 0.50,
    this.minRadius = 0.5,
    this.maxRadius = 1.0,
    this.driftScale = 0.03,
  });

  /// Random source for particle generation. Pass a seeded instance for
  /// deterministic / testable output.
  final Random? random;

  /// Particles per logical pixel² of screen area.
  /// Default 0.0005 ≈ 200 particles on a 400×1000 screen.
  final double density;

  /// Maximum parallax shift in logical pixels for the nearest depth layer.
  final double maxShift;

  /// Minimum and maximum base brightness (alpha) for particles.
  final double minBrightness;
  final double maxBrightness;

  /// Minimum and maximum drawn radius in logical pixels.
  final double minRadius;
  final double maxRadius;

  /// How far particles drift autonomously (normalized amplitude).
  final double driftScale;

  @override
  State<ParallaxDust> createState() => _ParallaxDustState();
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.depth,
    required this.driftSpeedX,
    required this.driftSpeedY,
    required this.phase,
    required this.brightness,
  });

  /// Absolute position in logical pixels.
  double x;
  double y;

  /// Depth layer 0–1 (0 = far / slow parallax, 1 = near / fast parallax).
  final double depth;

  /// Slow autonomous drift speeds (normalized units per second).
  final double driftSpeedX;
  final double driftSpeedY;

  /// Phase offset for drift oscillation.
  final double phase;

  /// Base brightness (alpha multiplier).
  final double brightness;
}

class _ParallaxDustState extends State<ParallaxDust>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Random _rng;
  final List<_Particle> _particles = [];

  /// Normalized pointer position (0.5, 0.5 = center). Drives the parallax.
  Offset _pointerNorm = const Offset(0.5, 0.5);

  /// Cached values used to detect when particles need regeneration.
  Size _lastSize = Size.zero;
  double _lastDensity = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 180),
    );
    unawaited(_controller.repeat());

    _rng = widget.random ?? Random(123);
  }

  int _targetCount(Size size) {
    return (widget.density * size.width * size.height).round().clamp(10, 500);
  }

  void _ensureParticles(Size size) {
    if (size == _lastSize && widget.density == _lastDensity) return;

    final oldSize = _lastSize;
    _lastSize = size;
    _lastDensity = widget.density;

    // First layout – fill the entire area.
    if (oldSize == Size.zero) {
      final count = _targetCount(size);
      _particles
        ..clear()
        ..addAll(_generateParticlesInRect(_rng, Offset.zero & size, count));
      return;
    }

    // Remove particles that are now outside the visible area.
    _particles.removeWhere((p) => p.x > size.width || p.y > size.height);

    final target = _targetCount(size);
    final deficit = target - _particles.length;

    if (deficit > 0) {
      // Build a list of newly revealed rectangles (right strip, bottom strip).
      final rects = <Rect>[];
      if (size.width > oldSize.width) {
        rects.add(
          Rect.fromLTWH(
            oldSize.width,
            0,
            size.width - oldSize.width,
            size.height,
          ),
        );
      }
      if (size.height > oldSize.height) {
        // Only the portion not covered by the right strip.
        rects.add(
          Rect.fromLTWH(
            0,
            oldSize.height,
            min(size.width, oldSize.width),
            size.height - oldSize.height,
          ),
        );
      }

      if (rects.isEmpty) {
        // Density increased without a resize – scatter across the full area.
        _particles.addAll(
          _generateParticlesInRect(_rng, Offset.zero & size, deficit),
        );
      } else {
        // Distribute deficit proportionally by area.
        final totalNew = rects.fold<double>(
          0,
          (s, r) => s + r.width * r.height,
        );
        var placed = 0;
        for (final rect in rects) {
          final share = (deficit * rect.width * rect.height / totalNew).round();
          _particles.addAll(_generateParticlesInRect(_rng, rect, share));
          placed += share;
        }
        // Rounding remainder – put in last rect.
        if (placed < deficit) {
          _particles.addAll(
            _generateParticlesInRect(
              _rng,
              rects.last,
              deficit - placed,
            ),
          );
        }
      }
    } else if (-deficit > 0) {
      // Screen shrank – trim excess particles randomly so the remaining set
      // doesn't cluster near the origin.
      _particles
        ..shuffle(_rng)
        ..removeRange(0, min(-deficit, _particles.length));
    }
  }

  List<_Particle> _generateParticlesInRect(Random rng, Rect rect, int count) {
    return List.generate(count, (_) {
      return _Particle(
        x: rect.left + rng.nextDouble() * rect.width,
        y: rect.top + rng.nextDouble() * rect.height,
        depth: rng.nextDouble(),
        driftSpeedX: (rng.nextDouble() - 0.5) * 0.01,
        driftSpeedY: (rng.nextDouble() - 0.5) * 0.008,
        phase: rng.nextDouble() * 2 * pi,
        brightness:
            widget.minBrightness +
            rng.nextDouble() * (widget.maxBrightness - widget.minBrightness),
      );
    });
  }

  void _onHover(PointerEvent event) {
    final box = context.findRenderObject()! as RenderBox;
    final size = box.size;
    setState(() {
      _pointerNorm = Offset(
        (event.localPosition.dx / size.width).clamp(0, 1),
        (event.localPosition.dy / size.height).clamp(0, 1),
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
    return MouseRegion(
      opaque: false,
      onHover: _onHover,
      child: RepaintBoundary(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _DustPainter(
                ensureParticles: _ensureParticles,
                particles: _particles,
                pointerNorm: _pointerNorm,
                maxShift: widget.maxShift,
                minRadius: widget.minRadius,
                maxRadius: widget.maxRadius,
                driftScale: widget.driftScale,
                time: _controller.value * 180,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

class _DustPainter extends CustomPainter {
  _DustPainter({
    required this.ensureParticles,
    required this.particles,
    required this.pointerNorm,
    required this.maxShift,
    required this.minRadius,
    required this.maxRadius,
    required this.driftScale,
    required this.time,
  });

  final void Function(Size) ensureParticles;
  final List<_Particle> particles;
  final Offset pointerNorm;
  final double maxShift;
  final double minRadius;
  final double maxRadius;
  final double driftScale;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    ensureParticles(size);

    // Parallax offset: pointer deviation from center, inverted.
    final parallaxBase = Offset(
      -(pointerNorm.dx - 0.5) * 2 * maxShift,
      -(pointerNorm.dy - 0.5) * 2 * maxShift,
    );

    for (final p in particles) {
      // Autonomous drift (in pixels, proportional to canvas size).
      final driftX =
          sin(time * p.driftSpeedX * 10 + p.phase) * driftScale * size.width;
      final driftY =
          cos(time * p.driftSpeedY * 10 + p.phase) * driftScale * size.height;

      final baseX = (p.x + driftX) % size.width;
      final baseY = (p.y + driftY) % size.height;

      // Depth-scaled parallax offset (mouse).
      final shift = parallaxBase * p.depth;

      final paint = Paint()
        ..color = Color.fromRGBO(
          255,
          255,
          255,
          p.brightness * (0.6 + 0.4 * p.depth),
        );

      final px = (baseX + shift.dx) % size.width;
      canvas.drawCircle(
        Offset(px, baseY + shift.dy),
        minRadius + p.depth * (maxRadius - minRadius),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DustPainter old) =>
      time != old.time || pointerNorm != old.pointerNorm;
}
