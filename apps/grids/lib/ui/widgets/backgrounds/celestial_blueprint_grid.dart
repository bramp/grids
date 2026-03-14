import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// A sparse star field overlaid on a large-scale technical coordinate
/// grid with faint tracking lines connecting stars, like a celestial
/// navigation schematic.
class CelestialBlueprintGrid extends StatefulWidget {
  const CelestialBlueprintGrid({
    super.key,
    this.starCount = 30,
    this.gridSpacing = 120,
    this.color = const Color(0xFF00BBAA),
  });

  /// Number of stars in the field.
  final int starCount;

  /// Spacing of the large-scale coordinate grid.
  final int gridSpacing;

  /// Base color for grid lines, stars, and tracking lines.
  final Color color;

  @override
  State<CelestialBlueprintGrid> createState() => _CelestialBlueprintGridState();
}

class _Star {
  _Star({
    required this.position,
    required this.brightness,
    required this.twinkleFreq,
    required this.twinklePhase,
  });

  /// Normalized position (0–1).
  final Offset position;
  final double brightness;
  final double twinkleFreq;
  final double twinklePhase;
}

class _CelestialBlueprintGridState extends State<CelestialBlueprintGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Star> _stars;
  late final List<(int, int)> _connections;

  static final _rng = Random(88);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 180),
    );
    unawaited(_controller.repeat());

    _stars = List.generate(widget.starCount, (_) {
      return _Star(
        position: Offset(_rng.nextDouble(), _rng.nextDouble()),
        brightness: 0.08 + _rng.nextDouble() * 0.12,
        twinkleFreq: 0.5 + _rng.nextDouble() * 1.0,
        twinklePhase: _rng.nextDouble() * 2 * pi,
      );
    });

    // Connect nearby stars with tracking lines.
    _connections = [];
    const threshold = 0.25;
    for (var i = 0; i < _stars.length; i++) {
      for (var j = i + 1; j < _stars.length; j++) {
        final d = (_stars[i].position - _stars[j].position).distance;
        if (d < threshold) {
          _connections.add((i, j));
        }
      }
    }
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
            painter: _CelestialPainter(
              stars: _stars,
              connections: _connections,
              gridSpacing: widget.gridSpacing,
              color: widget.color,
              time: _controller.value * 180,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _CelestialPainter extends CustomPainter {
  const _CelestialPainter({
    required this.stars,
    required this.connections,
    required this.gridSpacing,
    required this.color,
    required this.time,
  });

  final List<_Star> stars;
  final List<(int, int)> connections;
  final int gridSpacing;
  final Color color;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw large-scale coordinate grid.
    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.03)
      ..strokeWidth = 0.5;

    final spacing = gridSpacing.toDouble();
    for (var x = 0.0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Axis labels.
    final tp = TextPainter(textDirection: TextDirection.ltr);
    final labelStyle = TextStyle(
      color: color.withValues(alpha: 0.06),
      fontSize: 7,
      fontFamily: 'monospace',
    );

    var labelIdx = 0;
    for (var x = 0.0; x <= size.width; x += spacing) {
      tp
        ..text = TextSpan(text: '[$labelIdx,0]', style: labelStyle)
        ..layout()
        ..paint(canvas, Offset(x + 2, size.height - 12));
      labelIdx++;
    }

    // Draw tracking lines between connected stars.
    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.04)
      ..strokeWidth = 0.5;

    for (final (i, j) in connections) {
      final a = stars[i].position;
      final b = stars[j].position;
      canvas.drawLine(
        Offset(a.dx * size.width, a.dy * size.height),
        Offset(b.dx * size.width, b.dy * size.height),
        trackPaint,
      );
    }

    // Draw stars with twinkle.
    for (final star in stars) {
      final twinkle =
          0.5 + 0.5 * sin(star.twinkleFreq * time + star.twinklePhase);
      final alpha = star.brightness * (0.6 + 0.4 * twinkle);

      final center = Offset(
        star.position.dx * size.width,
        star.position.dy * size.height,
      );

      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(center, 1.5 + twinkle, paint);

      // Cross-hair at each star.
      final crossPaint = Paint()
        ..color = color.withValues(alpha: alpha * 0.5)
        ..strokeWidth = 0.3;
      const arm = 6.0;
      canvas
        ..drawLine(
          center.translate(-arm, 0),
          center.translate(arm, 0),
          crossPaint,
        )
        ..drawLine(
          center.translate(0, -arm),
          center.translate(0, arm),
          crossPaint,
        );
    }
  }

  @override
  bool shouldRepaint(_CelestialPainter old) => time != old.time;
}
