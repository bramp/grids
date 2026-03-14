import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// Columns of tiny hexadecimal characters falling slowly, like a muted
/// "Matrix" data rain effect.
class MatrixDataRain extends StatefulWidget {
  const MatrixDataRain({
    super.key,
    this.columnWidth = 18.0,
    this.charHeight = 14.0,
    this.fallSpeed = 30.0,
    this.color = const Color(0xFF0A3A2A),
    this.accentColor = const Color(0xFF00FFCC),
  });

  /// Horizontal spacing between columns.
  final double columnWidth;

  /// Vertical spacing between characters.
  final double charHeight;

  /// Fall speed in logical pixels per second.
  final double fallSpeed;

  /// Normal (dim) character color.
  final Color color;

  /// Bright flash color for occasional accent columns.
  final Color accentColor;

  @override
  State<MatrixDataRain> createState() => _MatrixDataRainState();
}

class _Column {
  _Column({
    required this.chars,
    required this.speed,
    required this.phaseOffset,
  });

  final List<String> chars;
  final double speed;
  final double phaseOffset;
}

class _MatrixDataRainState extends State<MatrixDataRain>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Column> _columns = [];
  static final _rng = Random(99);

  Size _lastSize = Size.zero;

  static const _hexChars = '0123456789ABCDEF';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3600),
    );
    unawaited(_controller.repeat());
  }

  void _ensureColumns(Size size) {
    if (size == _lastSize) return;
    _lastSize = size;

    final colCount = (size.width / widget.columnWidth).ceil();
    final rowCount = (size.height / widget.charHeight).ceil() + 5;

    _columns.clear();
    for (var c = 0; c < colCount; c++) {
      final chars = List.generate(rowCount, (_) {
        // Two hex chars grouped (e.g. "A3")
        return '${_hexChars[_rng.nextInt(16)]}${_hexChars[_rng.nextInt(16)]}';
      });
      _columns.add(
        _Column(
          chars: chars,
          speed: 0.6 + _rng.nextDouble() * 0.8,
          phaseOffset: _rng.nextDouble() * 200,
        ),
      );
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _ensureColumns(size);

          return ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _RainPainter(
                  columns: _columns,
                  time: _controller.value * 3600,
                  columnWidth: widget.columnWidth,
                  charHeight: widget.charHeight,
                  fallSpeed: widget.fallSpeed,
                  color: widget.color,
                  accentColor: widget.accentColor,
                ),
                size: Size.infinite,
              );
            },
          );
        },
      ),
    );
  }
}

class _RainPainter extends CustomPainter {
  const _RainPainter({
    required this.columns,
    required this.time,
    required this.columnWidth,
    required this.charHeight,
    required this.fallSpeed,
    required this.color,
    required this.accentColor,
  });

  final List<_Column> columns;
  final double time;
  final double columnWidth;
  final double charHeight;
  final double fallSpeed;
  final Color color;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final tp = TextPainter(textDirection: TextDirection.ltr);

    for (var c = 0; c < columns.length; c++) {
      final col = columns[c];
      final yOffset = (time + col.phaseOffset) * fallSpeed * col.speed;
      final scrolledRows = (yOffset / charHeight).floor();

      final x = c * columnWidth;

      for (var r = 0; r < col.chars.length; r++) {
        final charIndex = (r + scrolledRows) % col.chars.length;
        final y = r * charHeight - (yOffset % charHeight);

        if (y < -charHeight || y > size.height) continue;

        // Lead character is brighter.
        final isLead = r == 0;
        final charColor = isLead
            ? color.withValues(alpha: 0.5)
            : color.withValues(alpha: 0.3);

        tp
          ..text = TextSpan(
            text: col.chars[charIndex],
            style: TextStyle(
              color: charColor,
              fontSize: 9,
              fontFamily: 'monospace',
              fontWeight: isLead ? FontWeight.bold : FontWeight.normal,
            ),
          )
          ..layout()
          ..paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(_RainPainter old) => time != old.time;
}
