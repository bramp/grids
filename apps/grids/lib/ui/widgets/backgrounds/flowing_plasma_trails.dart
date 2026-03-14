import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// Smoke-like wisps of color that drift slowly behind the grid.
///
/// Each trail is a short chain of fading control points rendered as a
/// soft gradient path.
class FlowingPlasmaTrails extends StatefulWidget {
  const FlowingPlasmaTrails({
    super.key,
    this.trailCount = 6,
    this.trailColor = const Color(0xFF00FFCC),
  });

  /// Number of independent trails.
  final int trailCount;

  /// Base color for the trails (applied at very low opacity).
  final Color trailColor;

  @override
  State<FlowingPlasmaTrails> createState() => _FlowingPlasmaTrailsState();
}

class _Trail {
  _Trail({
    required this.controlPoints,
    required this.speeds,
    required this.phases,
    required this.color,
    required this.width,
  });

  /// Each control point oscillates via harmonic functions.
  final List<Offset> controlPoints;
  final List<Offset> speeds;
  final List<double> phases;
  final Color color;
  final double width;

  List<Offset> positionsAt(double t, Size size) {
    return List.generate(controlPoints.length, (i) {
      final base = controlPoints[i];
      final speed = speeds[i];
      final phase = phases[i];
      return Offset(
        (base.dx + 0.15 * sin(speed.dx * t + phase)) * size.width,
        (base.dy + 0.10 * sin(speed.dy * t + phase * 1.3)) * size.height,
      );
    });
  }
}

class _FlowingPlasmaTrailsState extends State<FlowingPlasmaTrails>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Trail> _trails;

  static final _rng = Random(77);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 300),
    );
    unawaited(_controller.repeat());

    _trails = List.generate(widget.trailCount, (i) {
      final points = List.generate(5, (_) {
        return Offset(_rng.nextDouble(), _rng.nextDouble());
      });
      final speeds = List.generate(5, (_) {
        return Offset(
          0.2 + _rng.nextDouble() * 0.3,
          0.15 + _rng.nextDouble() * 0.25,
        );
      });
      final phases = List.generate(5, (_) => _rng.nextDouble() * 2 * pi);

      final hueShift = (i * 20.0) - 10.0;
      final hsl = HSLColor.fromColor(widget.trailColor);
      final color = hsl
          .withHue((hsl.hue + hueShift) % 360)
          .toColor()
          .withValues(alpha: 0.08 + _rng.nextDouble() * 0.04);

      return _Trail(
        controlPoints: points,
        speeds: speeds,
        phases: phases,
        color: color,
        width: 30 + _rng.nextDouble() * 60,
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
            painter: _TrailPainter(
              trails: _trails,
              time: _controller.value * 300,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _TrailPainter extends CustomPainter {
  const _TrailPainter({required this.trails, required this.time});

  final List<_Trail> trails;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    for (final trail in trails) {
      final pts = trail.positionsAt(time, size);
      if (pts.length < 2) continue;

      final path = Path()..moveTo(pts[0].dx, pts[0].dy);
      for (var i = 1; i < pts.length - 1; i++) {
        final mid = Offset(
          (pts[i].dx + pts[i + 1].dx) / 2,
          (pts[i].dy + pts[i + 1].dy) / 2,
        );
        path.quadraticBezierTo(pts[i].dx, pts[i].dy, mid.dx, mid.dy);
      }
      path.lineTo(pts.last.dx, pts.last.dy);

      final paint = Paint()
        ..color = trail.color
        ..strokeWidth = trail.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, trail.width * 0.6);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_TrailPainter old) => time != old.time;
}
