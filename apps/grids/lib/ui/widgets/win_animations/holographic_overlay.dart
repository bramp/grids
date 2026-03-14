import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// A brief digital glitch followed by large holographic "SOLVED" text
/// composed of scanning green lines, with a slow horizontal scan-line sweep.
class HolographicOverlay extends StatefulWidget {
  const HolographicOverlay({
    super.key,
    this.color = const Color(0xFF00FFCC),
    this.text = 'SOLVED',
    this.duration = const Duration(milliseconds: 3000),
  });

  /// Accent colour for the holographic elements.
  final Color color;

  /// Text to display (e.g. "SOLVED", "ACCESS GRANTED").
  final String text;

  /// Total animation duration.
  final Duration duration;

  @override
  State<HolographicOverlay> createState() => _HolographicOverlayState();
}

class _HolographicOverlayState extends State<HolographicOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static final _rng = Random();

  /// Pre-computed glitch bar positions (normalised 0–1 y-offsets).
  late final List<double> _glitchBars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _glitchBars = List.generate(8, (_) => _rng.nextDouble());
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
            painter: _HoloPainter(
              progress: _controller.value,
              color: widget.color,
              text: widget.text,
              glitchBars: _glitchBars,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _HoloPainter extends CustomPainter {
  const _HoloPainter({
    required this.progress,
    required this.color,
    required this.text,
    required this.glitchBars,
  });

  final double progress;
  final Color color;
  final String text;
  final List<double> glitchBars;

  @override
  void paint(Canvas canvas, Size size) {
    // Phase 1: digital glitch bars (0 → 0.12).
    if (progress < 0.12) {
      final t = progress / 0.12;
      final alpha = (0.15 * (1 - t)).clamp(0.0, 1.0);
      final barHeight = size.height * 0.015;
      for (final y in glitchBars) {
        final rect = Rect.fromLTWH(0, y * size.height, size.width, barHeight);
        canvas.drawRect(
          rect,
          Paint()..color = color.withValues(alpha: alpha),
        );
      }
    }

    // Phase 2: scan line sweep (0.08 → 0.85).
    if (progress > 0.08 && progress < 0.85) {
      final t = ((progress - 0.08) / 0.77).clamp(0.0, 1.0);
      final scanY = t * size.height;
      final scanAlpha = 0.12 * (1 - (t * 0.5));

      // Scan line is a thin gradient band.
      final scanRect = Rect.fromLTWH(0, scanY - 20, size.width, 40);
      canvas.drawRect(
        scanRect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: 0),
              color.withValues(alpha: scanAlpha.clamp(0, 1)),
              color.withValues(alpha: 0),
            ],
          ).createShader(scanRect),
      );

      // Faint horizontal scan lines across entire screen.
      final linePaint = Paint()
        ..color = color.withValues(alpha: 0.03)
        ..strokeWidth = 0.5;
      for (var y = 0.0; y < size.height; y += 4) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
      }
    }

    // Phase 3: large holographic text (0.10 → 0.90).
    if (progress > 0.10 && progress < 0.90) {
      final fadeIn = ((progress - 0.10) / 0.15).clamp(0.0, 1.0);
      final fadeOut = ((0.90 - progress) / 0.15).clamp(0.0, 1.0);
      final alpha = fadeIn * fadeOut;

      // Measure text once with a large style.
      final fontSize = size.width * 0.14;
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color.withValues(alpha: alpha * 0.7),
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            letterSpacing: fontSize * 0.15,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final textX = (size.width - tp.width) / 2;
      final textY = (size.height - tp.height) / 2;

      // Outer glow.
      final glowTp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color.withValues(alpha: alpha * 0.2),
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            letterSpacing: fontSize * 0.15,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // Paint glow slightly offset in multiple directions.
      for (var dx = -2.0; dx <= 2.0; dx += 2) {
        for (var dy = -2.0; dy <= 2.0; dy += 2) {
          if (dx == 0 && dy == 0) continue;
          glowTp.paint(canvas, Offset(textX + dx, textY + dy));
        }
      }

      tp.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(_HoloPainter old) => progress != old.progress;
}
