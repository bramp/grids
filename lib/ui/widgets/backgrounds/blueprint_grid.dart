import 'dart:async';

import 'package:flutter/material.dart';

/// A faint coordinate-grid background that scrolls diagonally, evoking a
/// technical blueprint or CAD workspace.
class BlueprintGrid extends StatefulWidget {
  const BlueprintGrid({
    super.key,
    this.majorSpacing = 80,
    this.minorSpacing = 20,
    this.majorColor = const Color(0xFF1A2A2A),
    this.minorColor = const Color(0xFF101818),
    this.scrollSpeed = 1.0,
  });

  /// Spacing (logical pixels) between major grid lines.
  final double majorSpacing;

  /// Spacing between minor grid lines.
  final double minorSpacing;

  /// Color of major (thick) grid lines.
  final Color majorColor;

  /// Color of minor (thin) grid lines.
  final Color minorColor;

  /// Diagonal scroll speed in logical pixels per second.
  final double scrollSpeed;

  @override
  State<BlueprintGrid> createState() => _BlueprintGridState();
}

class _BlueprintGridState extends State<BlueprintGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 600),
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
          final elapsed = _controller.value * 600;
          return CustomPaint(
            painter: _BlueprintGridPainter(
              majorSpacing: widget.majorSpacing,
              minorSpacing: widget.minorSpacing,
              majorColor: widget.majorColor,
              minorColor: widget.minorColor,
              offset: elapsed * widget.scrollSpeed,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _BlueprintGridPainter extends CustomPainter {
  const _BlueprintGridPainter({
    required this.majorSpacing,
    required this.minorSpacing,
    required this.majorColor,
    required this.minorColor,
    required this.offset,
  });

  final double majorSpacing;
  final double minorSpacing;
  final Color majorColor;
  final Color minorColor;
  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    // Diagonal scroll: shift both x and y by the same amount.
    final dx = offset % majorSpacing;
    final dy = offset % majorSpacing;

    // Minor lines
    final minorPaint = Paint()
      ..color = minorColor
      ..strokeWidth = 0.5;

    final minorDx = offset % minorSpacing;
    final minorDy = offset % minorSpacing;

    for (var x = -minorDx; x <= size.width + minorSpacing; x += minorSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), minorPaint);
    }
    for (var y = -minorDy; y <= size.height + minorSpacing; y += minorSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minorPaint);
    }

    // Major lines
    final majorPaint = Paint()
      ..color = majorColor
      ..strokeWidth = 1.0;

    for (var x = -dx; x <= size.width + majorSpacing; x += majorSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), majorPaint);
    }
    for (var y = -dy; y <= size.height + majorSpacing; y += majorSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), majorPaint);
    }

    // Small coordinate labels at major intersections.
    final textStyle = TextStyle(
      color: majorColor.withValues(alpha: 0.6),
      fontSize: 8,
      fontFamily: 'monospace',
    );
    final tp = TextPainter(textDirection: TextDirection.ltr);

    var labelX = 0;
    for (var x = -dx; x <= size.width + majorSpacing; x += majorSpacing) {
      var labelY = 0;
      for (var y = -dy; y <= size.height + majorSpacing; y += majorSpacing) {
        if (x >= 0 && y >= 0 && x < size.width && y < size.height) {
          tp
            ..text = TextSpan(text: '[$labelX,$labelY]', style: textStyle)
            ..layout()
            ..paint(canvas, Offset(x + 2, y + 1));
        }
        labelY++;
      }
      labelX++;
    }
  }

  @override
  bool shouldRepaint(_BlueprintGridPainter old) => offset != old.offset;
}
