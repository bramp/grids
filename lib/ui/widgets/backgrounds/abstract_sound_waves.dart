import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// Thin horizontal oscilloscope-style lines that gently undulate at the
/// top and bottom of the screen.
class AbstractSoundWaves extends StatefulWidget {
  const AbstractSoundWaves({
    super.key,
    this.lineCount = 3,
    this.color = const Color(0xFF00FFCC),
    this.amplitude = 8.0,
  });

  /// Number of wave lines at each edge (top and bottom).
  final int lineCount;

  /// Base wave color (drawn at low opacity).
  final Color color;

  /// Maximum wave amplitude in logical pixels.
  final double amplitude;

  @override
  State<AbstractSoundWaves> createState() => _AbstractSoundWavesState();
}

class _AbstractSoundWavesState extends State<AbstractSoundWaves>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
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
            painter: _WavePainter(
              lineCount: widget.lineCount,
              color: widget.color,
              amplitude: widget.amplitude,
              time: _controller.value * 120,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter({
    required this.lineCount,
    required this.color,
    required this.amplitude,
    required this.time,
  });

  final int lineCount;
  final Color color;
  final double amplitude;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < lineCount; i++) {
      final alpha = 0.08 + i * 0.03;
      final freq = 0.02 + i * 0.005;
      final phase = i * 0.7;
      final yBase = 30.0 + i * 12.0;

      // Top wave
      _drawWave(canvas, size, yBase, freq, phase, alpha);
      // Bottom wave (mirrored)
      _drawWave(canvas, size, size.height - yBase, freq, phase + pi, alpha);
    }
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double yCenter,
    double freq,
    double phase,
    double alpha,
  ) {
    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    const step = 3.0;
    var first = true;

    for (var x = 0.0; x <= size.width; x += step) {
      final y =
          yCenter +
          amplitude * sin(freq * x + time * 0.5 + phase) +
          amplitude * 0.5 * sin(freq * 2.3 * x + time * 0.8 + phase * 1.7);

      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter old) => time != old.time;
}
