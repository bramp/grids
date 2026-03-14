import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// An expanding circular shockwave of geometric vector lines erupts from the
/// centre, followed by concentric ripple rings that fade outward.
class ShockwaveRing extends StatefulWidget {
  const ShockwaveRing({
    super.key,
    this.color = const Color(0xFF00FFCC),
    this.ringCount = 5,
    this.duration = const Duration(milliseconds: 2000),
  });

  /// Accent colour for the shockwave and rings.
  final Color color;

  /// Number of trailing ripple rings.
  final int ringCount;

  /// Total animation duration.
  final Duration duration;

  @override
  State<ShockwaveRing> createState() => _ShockwaveRingState();
}

class _ShockwaveRingState extends State<ShockwaveRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
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
            painter: _ShockwavePainter(
              progress: _controller.value,
              color: widget.color,
              ringCount: widget.ringCount,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ShockwavePainter extends CustomPainter {
  const _ShockwavePainter({
    required this.progress,
    required this.color,
    required this.ringCount,
  });

  final double progress;
  final Color color;
  final int ringCount;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxRadius = sqrt(cx * cx + cy * cy); // corner distance

    // Phase 1: diagonal scan flash (0 → 0.15).
    if (progress < 0.15) {
      final t = progress / 0.15;
      // A thin bright diagonal line sweeping from top-left to bottom-right.
      final scanPos = Curves.easeOut.transform(t);
      final alpha = (0.25 * (1 - t)).clamp(0.0, 1.0);

      // The scan is a gradient band along the diagonal.
      final diagLen = size.width + size.height;
      final pos = scanPos * diagLen;

      final path = Path()
        ..moveTo(pos, 0)
        ..lineTo(pos - size.height, size.height)
        ..lineTo(pos - size.height + 40, size.height)
        ..lineTo(pos + 40, 0)
        ..close();

      canvas.drawPath(
        path,
        Paint()..color = color.withValues(alpha: alpha),
      );
    }

    // Phase 2: primary shockwave ring (0.05 → 0.60).
    if (progress > 0.05 && progress < 0.60) {
      final t = ((progress - 0.05) / 0.55).clamp(0.0, 1.0);
      final radius = Curves.easeOutCubic.transform(t) * maxRadius;
      final alpha = (0.5 * (1 - Curves.easeIn.transform(t))).clamp(0.0, 1.0);
      final width = 3.0 * (1 - t * 0.7);

      canvas
        ..drawCircle(
          Offset(cx, cy),
          radius,
          Paint()
            ..color = color.withValues(alpha: alpha)
            ..strokeWidth = width
            ..style = PaintingStyle.stroke,
        )
        // Inner bright core ring.
        ..drawCircle(
          Offset(cx, cy),
          radius,
          Paint()
            ..color = Colors.white.withValues(alpha: alpha * 0.6)
            ..strokeWidth = 1.0
            ..style = PaintingStyle.stroke,
        );
    }

    // Phase 3: trailing ripple rings (staggered, 0.15 → 1.0).
    for (var i = 0; i < ringCount; i++) {
      final delay = 0.15 + i * 0.10;
      if (progress <= delay) continue;

      final t = ((progress - delay) / (1 - delay)).clamp(0.0, 1.0);
      final radius = Curves.easeOutCubic.transform(t) * maxRadius * 0.85;
      final alpha = (0.2 * (1 - Curves.easeIn.transform(t)) / (1 + i * 0.3))
          .clamp(0.0, 1.0);

      if (alpha <= 0.01) continue;

      canvas.drawCircle(
        Offset(cx, cy),
        radius,
        Paint()
          ..color = color.withValues(alpha: alpha)
          ..strokeWidth = 1.5 - i * 0.2
          ..style = PaintingStyle.stroke,
      );
    }

    // Phase 4: centre flash dot (0 → 0.20).
    if (progress < 0.20) {
      final t = progress / 0.20;
      final dotRadius = 8.0 * (1 - Curves.easeIn.transform(t));
      final alpha = (0.8 * (1 - t)).clamp(0.0, 1.0);

      canvas.drawCircle(
        Offset(cx, cy),
        dotRadius,
        Paint()
          ..color = Colors.white.withValues(alpha: alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
  }

  @override
  bool shouldRepaint(_ShockwavePainter old) => progress != old.progress;
}
