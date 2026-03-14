import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// Ambient plasma lightning arcs that occasionally crackle across the
/// background in the theme's accent colour.
class PlasmaLightning extends StatefulWidget {
  const PlasmaLightning({
    super.key,
    this.color = const Color(0xFF00FFCC),
    this.boltWidth = 1.5,
    this.spawnInterval = 3.5,
  });

  /// Base bolt color (variants are derived automatically).
  final Color color;

  /// Maximum stroke width of each bolt's core.
  final double boltWidth;

  /// Average seconds between bolt spawns.
  final double spawnInterval;

  @override
  State<PlasmaLightning> createState() => _PlasmaLightningState();
}

/// A single bolt: a jagged polyline with a glow that fades out.
class _Bolt {
  _Bolt({
    required this.points,
    required this.color,
    required this.width,
    required this.createdAt,
    required this.duration,
  });

  /// Absolute pixel positions of the bolt segments.
  final List<Offset> points;
  final Color color;
  final double width;

  /// Time (seconds) when this bolt was spawned.
  final double createdAt;

  /// How long (seconds) the bolt lives.
  final double duration;

  /// 0 → fresh, 1 → gone.
  double progress(double now) => ((now - createdAt) / duration).clamp(0, 1);
}

class _PlasmaLightningState extends State<PlasmaLightning>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Bolt> _bolts = [];

  static final _random = Random();

  /// Seconds between bolt spawns (varies).
  double _nextSpawnAt = 0;

  late final List<Color> _boltColors;

  @override
  void initState() {
    super.initState();

    // Derive two extra tints from the base color for variety.
    final hsl = HSLColor.fromColor(widget.color);
    _boltColors = [
      widget.color,
      hsl.withLightness((hsl.lightness + 0.1).clamp(0, 1)).toColor(),
      hsl.withLightness((hsl.lightness - 0.05).clamp(0, 1)).toColor(),
    ];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3600), // long running
    );
    unawaited(_controller.repeat());
    _nextSpawnAt = 1 + _random.nextDouble() * widget.spawnInterval;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layoutSize = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          return ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              final time = _controller.value * 3600;
              // Update bolt state before painting, not inside the painter.
              _tick(time, layoutSize);
              return CustomPaint(
                painter: _LightningPainter(
                  bolts: _bolts,
                  time: time,
                ),
                size: Size.infinite,
              );
            },
          );
        },
      ),
    );
  }

  void _tick(double time, Size size) {
    // Remove dead bolts.
    _bolts.removeWhere((b) => b.progress(time) >= 1);

    // Spawn new bolts on schedule.
    if (time >= _nextSpawnAt && size != Size.zero) {
      _bolts.add(_generateBolt(size, time));
      // Occasionally spawn a second branch.
      if (_random.nextDouble() < 0.3) {
        _bolts.add(_generateBolt(size, time));
      }
      _nextSpawnAt =
          time + widget.spawnInterval * (0.6 + _random.nextDouble() * 1.0);
    }
  }

  _Bolt _generateBolt(Size size, double time) {
    // Pick a random start edge and an end roughly on the opposite side.
    final startEdge = _random.nextInt(4); // 0=top, 1=right, 2=bottom, 3=left
    final start = _edgePoint(startEdge, size);
    final end = _edgePoint((startEdge + 2) % 4, size);

    final points = _buildBoltPath(start, end, 6);

    return _Bolt(
      points: points,
      color: _boltColors[_random.nextInt(_boltColors.length)],
      width: widget.boltWidth * (0.7 + _random.nextDouble()),
      createdAt: time,
      duration: 0.3 + _random.nextDouble() * 0.4,
    );
  }

  Offset _edgePoint(int edge, Size size) {
    return switch (edge) {
      0 => Offset(_random.nextDouble() * size.width, 0),
      1 => Offset(size.width, _random.nextDouble() * size.height),
      2 => Offset(
        _random.nextDouble() * size.width,
        size.height,
      ),
      _ => Offset(0, _random.nextDouble() * size.height),
    };
  }

  /// Recursively subdivide the line with random perpendicular offsets to
  /// create a jagged lightning path.
  List<Offset> _buildBoltPath(
    Offset start,
    Offset end,
    int subdivisions,
  ) {
    if (subdivisions <= 0) return [start, end];

    final mid = Offset(
      (start.dx + end.dx) / 2,
      (start.dy + end.dy) / 2,
    );

    // Perpendicular jitter proportional to segment length.
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final len = sqrt(dx * dx + dy * dy);
    final jitter = (_random.nextDouble() - 0.5) * len * 0.35;

    // Perpendicular unit vector.
    final perpX = -dy / len;
    final perpY = dx / len;

    final displaced = Offset(
      mid.dx + perpX * jitter,
      mid.dy + perpY * jitter,
    );

    final left = _buildBoltPath(start, displaced, subdivisions - 1);
    final right = _buildBoltPath(displaced, end, subdivisions - 1);

    return [...left, ...right.skip(1)];
  }
}

class _LightningPainter extends CustomPainter {
  const _LightningPainter({
    required this.bolts,
    required this.time,
  });

  final List<_Bolt> bolts;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    for (final bolt in bolts) {
      final t = bolt.progress(time);
      if (t >= 1) continue;

      // Sharp flash then quick fade.
      final alpha = (1 - Curves.easeIn.transform(t)).clamp(0.0, 1.0);

      // Outer glow.
      final glowPaint = Paint()
        ..color = bolt.color.withValues(alpha: alpha * 0.25)
        ..strokeWidth = bolt.width * 6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, bolt.width * 4);

      // Core.
      final corePaint = Paint()
        ..color = Colors.white.withValues(alpha: alpha * 0.9)
        ..strokeWidth = bolt.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final path = Path()..moveTo(bolt.points[0].dx, bolt.points[0].dy);
      for (var i = 1; i < bolt.points.length; i++) {
        path.lineTo(bolt.points[i].dx, bolt.points[i].dy);
      }

      canvas
        ..drawPath(path, glowPaint)
        ..drawPath(path, corePaint);
    }
  }

  @override
  bool shouldRepaint(_LightningPainter old) => time != old.time;
}
