import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// A dense network of glowing bio-luminescent tendrils that pulse gently,
/// like a neural scan of a living organism.
class BioNeuralNetwork extends StatefulWidget {
  const BioNeuralNetwork({
    super.key,
    this.nodeCount = 40,
    this.color = const Color(0xFF00FFCC),
  });

  /// Number of nodes in the network.
  final int nodeCount;

  /// Base tendril / node color.
  final Color color;

  @override
  State<BioNeuralNetwork> createState() => _BioNeuralNetworkState();
}

class _Node {
  _Node({
    required this.position,
    required this.driftX,
    required this.driftY,
    required this.phase,
    required this.pulseFreq,
  });

  /// Normalized position (0–1).
  final Offset position;
  final double driftX;
  final double driftY;
  final double phase;
  final double pulseFreq;

  Offset positionAt(double t) {
    return Offset(
      position.dx + 0.02 * sin(driftX * t + phase),
      position.dy + 0.02 * sin(driftY * t + phase * 1.3),
    );
  }
}

class _BioNeuralNetworkState extends State<BioNeuralNetwork>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Node> _nodes;
  late final List<(int, int)> _edges;

  static final _rng = Random(31);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 240),
    );
    unawaited(_controller.repeat());

    _nodes = List.generate(widget.nodeCount, (_) {
      return _Node(
        position: Offset(_rng.nextDouble(), _rng.nextDouble()),
        driftX: 0.3 + _rng.nextDouble() * 0.3,
        driftY: 0.2 + _rng.nextDouble() * 0.3,
        phase: _rng.nextDouble() * 2 * pi,
        pulseFreq: 0.3 + _rng.nextDouble() * 0.5,
      );
    });

    // Connect nearby nodes (within threshold distance).
    _edges = [];
    const threshold = 0.22;
    for (var i = 0; i < _nodes.length; i++) {
      for (var j = i + 1; j < _nodes.length; j++) {
        final d = (_nodes[i].position - _nodes[j].position).distance;
        if (d < threshold) {
          _edges.add((i, j));
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
            painter: _NeuralPainter(
              nodes: _nodes,
              edges: _edges,
              color: widget.color,
              time: _controller.value * 240,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _NeuralPainter extends CustomPainter {
  const _NeuralPainter({
    required this.nodes,
    required this.edges,
    required this.color,
    required this.time,
  });

  final List<_Node> nodes;
  final List<(int, int)> edges;
  final Color color;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw edges (tendrils).
    final edgePaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (final (i, j) in edges) {
      final a = nodes[i].positionAt(time);
      final b = nodes[j].positionAt(time);
      canvas.drawLine(
        Offset(a.dx * size.width, a.dy * size.height),
        Offset(b.dx * size.width, b.dy * size.height),
        edgePaint,
      );
    }

    // Draw nodes with pulsing glow.
    for (final node in nodes) {
      final pos = node.positionAt(time);
      final center = Offset(pos.dx * size.width, pos.dy * size.height);

      final pulse = 0.5 + 0.5 * sin(node.pulseFreq * time + node.phase);
      final alpha = 0.12 + pulse * 0.15;
      final radius = 2.5 + pulse * 3.0;

      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius);

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_NeuralPainter old) => time != old.time;
}
