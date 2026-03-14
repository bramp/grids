import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// A low-polygon wireframe landscape with glowing peaks, evoking a vast
/// alien data bank viewed from above.
class GeometricDataTopography extends StatefulWidget {
  const GeometricDataTopography({
    super.key,
    this.cols = 16,
    this.rows = 12,
    this.color = const Color(0xFF00FFCC),
  });

  /// Grid subdivisions (horizontal).
  final int cols;

  /// Grid subdivisions (vertical).
  final int rows;

  /// Base wireframe / vertex color.
  final Color color;

  @override
  State<GeometricDataTopography> createState() =>
      _GeometricDataTopographyState();
}

class _GeometricDataTopographyState extends State<GeometricDataTopography>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<double> _heights;

  static final _rng = Random(55);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
    );
    unawaited(_controller.repeat());

    // Pre-generate height map (0–1 values).
    _heights = List.generate(
      (widget.cols + 1) * (widget.rows + 1),
      (_) => _rng.nextDouble(),
    );
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
              cols: widget.cols,
              rows: widget.rows,
              heights: _heights,
              color: widget.color,
              time: _controller.value * 120,
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
    required this.cols,
    required this.rows,
    required this.heights,
    required this.color,
    required this.time,
  });

  final int cols;
  final int rows;
  final List<double> heights;
  final Color color;
  final double time;

  double _heightAt(int col, int row) => heights[row * (cols + 1) + col];

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / cols;
    final cellH = size.height / rows;
    const maxLift = 20.0;

    // Isometric-ish tilt: compress Y and shift by height.
    final tilt = 0.6 + 0.1 * sin(time * 0.05);

    Offset project(int col, int row) {
      final h = _heightAt(col, row);
      // Gently animate the heights.
      final animH = h * (0.8 + 0.2 * sin(time * 0.1 + col * 0.5 + row * 0.7));
      return Offset(
        col * cellW,
        row * cellH * tilt - animH * maxLift,
      );
    }

    // Draw wireframe.
    final wirePaint = Paint()
      ..color = color.withValues(alpha: 0.05)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (var r = 0; r <= rows; r++) {
      for (var c = 0; c <= cols; c++) {
        final p = project(c, r);
        if (c < cols) {
          canvas.drawLine(p, project(c + 1, r), wirePaint);
        }
        if (r < rows) {
          canvas.drawLine(p, project(c, r + 1), wirePaint);
        }
      }
    }

    // Glowing peaks (top 25% of height values).
    final peakPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    for (var r = 0; r <= rows; r++) {
      for (var c = 0; c <= cols; c++) {
        final h = _heightAt(c, r);
        if (h > 0.75) {
          final p = project(c, r);
          final brightness = (h - 0.75) * 4; // 0–1
          peakPaint.color = color.withValues(alpha: 0.1 + brightness * 0.15);
          canvas.drawCircle(p, 1.5 + brightness * 2, peakPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_TopoPainter old) => time != old.time;
}
