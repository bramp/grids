import 'dart:async';

import 'package:flutter/material.dart';

/// Subtle horizontal scan-line overlay with a slow sweep effect, evoking an
/// augmented-reality heads-up display.
class ArScanLines extends StatefulWidget {
  const ArScanLines({
    super.key,
    this.lineSpacing = 3.0,
    this.lineColor = const Color(0xFF00FFCC),
    this.sweepDuration = const Duration(seconds: 8),
  });

  /// Vertical spacing between scan lines.
  final double lineSpacing;

  /// Scan-line tint color.
  final Color lineColor;

  /// How long a single sweep takes to travel top-to-bottom.
  final Duration sweepDuration;

  @override
  State<ArScanLines> createState() => _ArScanLinesState();
}

class _ArScanLinesState extends State<ArScanLines>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.sweepDuration,
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
            painter: _ScanLinePainter(
              lineSpacing: widget.lineSpacing,
              lineColor: widget.lineColor,
              sweepProgress: _controller.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ScanLinePainter extends CustomPainter {
  const _ScanLinePainter({
    required this.lineSpacing,
    required this.lineColor,
    required this.sweepProgress,
  });

  final double lineSpacing;
  final Color lineColor;
  final double sweepProgress;

  @override
  void paint(Canvas canvas, Size size) {
    // Static scan lines.
    final scanPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.03)
      ..strokeWidth = 0.5;

    for (var y = 0.0; y < size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanPaint);
    }

    // Sweep highlight — a bright band that travels down the screen.
    final sweepY = sweepProgress * size.height;
    const bandHeight = 60.0;

    final sweepPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lineColor.withValues(alpha: 0),
              lineColor.withValues(alpha: 0.06),
              lineColor.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromLTWH(0, sweepY - bandHeight / 2, size.width, bandHeight),
          );

    canvas.drawRect(
      Rect.fromLTWH(0, sweepY - bandHeight / 2, size.width, bandHeight),
      sweepPaint,
    );

    // Corner HUD text (decorative).
    final style = TextStyle(
      color: lineColor.withValues(alpha: 0.15),
      fontSize: 8,
      fontFamily: 'monospace',
    );
    final tp = TextPainter(textDirection: TextDirection.ltr);

    tp
      ..text = TextSpan(text: 'Z-AXIS: 0.15', style: style)
      ..layout()
      ..paint(canvas, Offset(size.width - tp.width - 8, 8))
      ..text = TextSpan(text: 'AR-GRID v2.1', style: style)
      ..layout()
      ..paint(canvas, const Offset(8, 8));
  }

  @override
  bool shouldRepaint(_ScanLinePainter old) =>
      sweepProgress != old.sweepProgress;
}
