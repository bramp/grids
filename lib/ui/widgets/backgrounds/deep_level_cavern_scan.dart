import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// A radar-scan overlay that evokes an underground cavern survey terminal,
/// with blinking pings, grid lines, and data readouts.
class DeepLevelCavernScan extends StatefulWidget {
  const DeepLevelCavernScan({
    super.key,
    this.pingCount = 5,
    this.color = const Color(0xFF00FFCC),
    this.gridSpacing = 60,
  });

  /// Number of blinking ping markers.
  final int pingCount;

  /// Base scan color.
  final Color color;

  /// Spacing of overlay grid.
  final int gridSpacing;

  @override
  State<DeepLevelCavernScan> createState() => _DeepLevelCavernScanState();
}

class _Ping {
  _Ping({
    required this.position,
    required this.blinkFreq,
    required this.phase,
  });

  /// Normalized position (0–1).
  final Offset position;
  final double blinkFreq;
  final double phase;
}

class _DeepLevelCavernScanState extends State<DeepLevelCavernScan>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Ping> _pings;

  static final _rng = Random(13);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    unawaited(_controller.repeat());

    _pings = List.generate(widget.pingCount, (_) {
      return _Ping(
        position: Offset(_rng.nextDouble(), _rng.nextDouble()),
        blinkFreq: 0.8 + _rng.nextDouble() * 1.5,
        phase: _rng.nextDouble() * 2 * pi,
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
            painter: _CavernPainter(
              pings: _pings,
              color: widget.color,
              gridSpacing: widget.gridSpacing,
              time: _controller.value * 60,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _CavernPainter extends CustomPainter {
  const _CavernPainter({
    required this.pings,
    required this.color,
    required this.gridSpacing,
    required this.time,
  });

  final List<_Ping> pings;
  final Color color;
  final int gridSpacing;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    // Mottled rock texture (subtle noise pattern using small rects).
    final noisePaint = Paint()..color = color.withValues(alpha: 0.01);
    final noiseRng = Random(7); // deterministic
    for (var i = 0; i < 200; i++) {
      final x = noiseRng.nextDouble() * size.width;
      final y = noiseRng.nextDouble() * size.height;
      final s = 2.0 + noiseRng.nextDouble() * 6;
      canvas.drawRect(Rect.fromLTWH(x, y, s, s), noisePaint);
    }

    // Overlay grid.
    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.04)
      ..strokeWidth = 0.5;

    final spacing = gridSpacing.toDouble();
    for (var x = 0.0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Radar sweep (rotating line from center).
    final cx = size.width / 2;
    final cy = size.height / 2;
    final sweepAngle = time * 0.5;
    final sweepLen = size.shortestSide * 0.5;

    final sweepPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + sweepLen * cos(sweepAngle), cy + sweepLen * sin(sweepAngle)),
      sweepPaint,
    );

    // Blinking ping markers.
    for (final ping in pings) {
      final blink = (sin(ping.blinkFreq * time + ping.phase) + 1) / 2;
      if (blink < 0.4) continue; // "off" phase

      final center = Offset(
        ping.position.dx * size.width,
        ping.position.dy * size.height,
      );

      final alpha = 0.1 + blink * 0.15;
      final pingPaint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(center, 3, pingPaint);

      // Expanding ring.
      final ringAlpha = (1 - blink) * 0.08;
      final ringPaint = Paint()
        ..color = color.withValues(alpha: ringAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;

      canvas.drawCircle(center, 3 + blink * 12, ringPaint);
    }

    // Corner data readouts.
    final style = TextStyle(
      color: color.withValues(alpha: 0.12),
      fontSize: 8,
      fontFamily: 'monospace',
    );
    final tp = TextPainter(textDirection: TextDirection.ltr);

    final scanPct = ((time * 2.3) % 100).toStringAsFixed(1);
    tp
      ..text = TextSpan(text: 'SECTOR 7-G', style: style)
      ..layout()
      ..paint(canvas, const Offset(8, 8))
      ..text = TextSpan(text: 'SCAN COMPLETE $scanPct%', style: style)
      ..layout()
      ..paint(canvas, Offset(8, size.height - 20))
      ..text = TextSpan(text: 'DEPTH: 847m', style: style)
      ..layout()
      ..paint(canvas, Offset(size.width - tp.width - 8, 8));
  }

  @override
  bool shouldRepaint(_CavernPainter old) => time != old.time;
}
