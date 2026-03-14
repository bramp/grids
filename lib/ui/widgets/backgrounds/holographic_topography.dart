import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// Faint interlocking contour lines that slowly rotate in 3D perspective,
/// evoking a holographic topography map.
class HolographicTopography extends StatefulWidget {
  const HolographicTopography({
    super.key,
    this.ringCount = 8,
    this.color = const Color(0xFF00FFCC),
  });

  /// Number of concentric contour rings.
  final int ringCount;

  /// Base contour color (drawn at very low opacity).
  final Color color;

  @override
  State<HolographicTopography> createState() => _HolographicTopographyState();
}

class _HolographicTopographyState extends State<HolographicTopography>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    unawaited(_controller.repeat());
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
            painter: _TopoPainter(
              ringCount: widget.ringCount,
              color: widget.color,
              time: _controller.value * 60,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _TopoPainter extends CustomPainter {
  const _TopoPainter({
    required this.ringCount,
    required this.color,
    required this.time,
  });

  final int ringCount;
  final Color color;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxR = size.shortestSide * 0.6;

    // Slow rotation angle.
    final angle = time * 0.05;

    // Simulate a slight 3D tilt by squashing the Y axis.
    final tiltY = 0.55 + 0.15 * sin(time * 0.03);

    canvas
      ..save()
      ..translate(cx, cy)
      ..scale(1, tiltY)
      ..translate(-cx, -cy);

    for (var i = 1; i <= ringCount; i++) {
      final r = maxR * (i / ringCount);
      final alpha = 0.04 + 0.02 * (1 - i / ringCount);

      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke;

      // Offset each ring slightly for organic feel.
      final ox = 8 * sin(angle + i * 0.9);
      final oy = 6 * cos(angle * 0.7 + i * 1.1);

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + ox, cy + oy),
          width: r * 2,
          height: r * 2,
        ),
        paint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_TopoPainter old) => time != old.time;
}
