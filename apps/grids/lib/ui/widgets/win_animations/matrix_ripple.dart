import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Concentric ripple waves that warp the visible [child] content outward from
/// the centre using a fragment shader, like a stone dropped in water.
///
/// The widget captures the child once at the start of the animation, then
/// renders the captured image through a GLSL distortion shader each frame.
///
/// Call [MatrixRipple.precache] once at app startup (e.g. in `main()`) to
/// compile the shader ahead of time so the widget can use it synchronously.
class MatrixRipple extends StatefulWidget {
  const MatrixRipple({
    required this.child,
    super.key,
    this.color = const Color(0xFF00FFCC),
    this.waveCount = 1,
    this.amplitude = 0.016,
    this.waveSpacing = 0.18,
    this.waveDecay = 0.56,
    this.duration = const Duration(milliseconds: 2000),
    this.onComplete,
  });

  /// Pre-compile the ripple distortion shader. Call once from `main()` before
  /// `runApp()`. Returns the [ui.FragmentProgram] for convenience, but the
  /// widget resolves it internally via the cache.
  static Future<ui.FragmentProgram> precache() async {
    return _program ??= await ui.FragmentProgram.fromAsset(
      'shaders/ripple_distortion.frag',
    );
  }

  static ui.FragmentProgram? _program;

  /// The content to distort.
  final Widget child;

  /// Accent colour for the ripple wavefronts.
  final Color color;

  /// Number of concentric wave rings.
  final int waveCount;

  /// Distortion strength. Higher values produce more pronounced warping.
  /// Defaults to 0.016.
  final double amplitude;

  /// Time delay between successive wave rings (0–1). Higher values spread
  /// them further apart. Defaults to 0.18.
  final double waveSpacing;

  /// Per-wave amplitude multiplier (0–1). Each successive wave is scaled by
  /// this factor relative to the previous one. Defaults to 0.56.
  final double waveDecay;

  /// Total animation duration.
  final Duration duration;

  /// Called when the ripple animation finishes.
  final VoidCallback? onComplete;

  @override
  State<MatrixRipple> createState() => _MatrixRippleState();
}

class _MatrixRippleState extends State<MatrixRipple>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final GlobalKey _boundaryKey = GlobalKey();

  ui.FragmentShader? _shader;
  ui.Image? _snapshot;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    final program = MatrixRipple._program;
    assert(
      program != null,
      'Call MatrixRipple.precache() before using this widget.',
    );
    _shader = program?.fragmentShader();

    // Capture child after the first frame paints.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => unawaited(_captureChild()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _snapshot?.dispose();
    super.dispose();
  }

  Future<void> _captureChild() async {
    final boundary =
        _boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null || !boundary.hasSize) return;

    final ratio = MediaQuery.devicePixelRatioOf(context);
    final image = await boundary.toImage(pixelRatio: ratio);
    if (!mounted) return;
    setState(() => _snapshot = image);
    if (_shader != null) {
      unawaited(_controller.forward());
    }
  }

  @override
  Widget build(BuildContext context) {
    final animating = _snapshot != null && _shader != null;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        // The child is always in the tree so layout is stable. We hide it via
        // Opacity once the shader takes over rendering.
        Opacity(
          opacity: animating ? 0 : 1,
          child: RepaintBoundary(
            key: _boundaryKey,
            child: widget.child,
          ),
        ),
        if (animating)
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _RippleShaderPainter(
                        shader: _shader!,
                        image: _snapshot!,
                        progress: _controller.value,
                        color: widget.color,
                        waveCount: widget.waveCount,
                        amplitude: widget.amplitude,
                        waveSpacing: widget.waveSpacing,
                        waveDecay: widget.waveDecay,
                      ),
                      size: Size.infinite,
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _RippleShaderPainter extends CustomPainter {
  const _RippleShaderPainter({
    required this.shader,
    required this.image,
    required this.progress,
    required this.color,
    required this.waveCount,
    required this.amplitude,
    required this.waveSpacing,
    required this.waveDecay,
  });

  final ui.FragmentShader shader;
  final ui.Image image;
  final double progress;
  final Color color;
  final int waveCount;
  final double amplitude;
  final double waveSpacing;
  final double waveDecay;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      // uResolution (vec2) → floats 0, 1
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      // uProgress (float) → float 2
      ..setFloat(2, progress)
      // uWaveCount (float) → float 3
      ..setFloat(3, waveCount.toDouble())
      // uAmplitude (float) → float 4
      ..setFloat(4, amplitude)
      // uWaveSpacing (float) → float 5
      ..setFloat(5, waveSpacing)
      // uWaveDecay (float) → float 6
      ..setFloat(6, waveDecay)
      // uColor (vec3) → floats 7, 8, 9
      ..setFloat(7, color.r)
      ..setFloat(8, color.g)
      ..setFloat(9, color.b)
      // uTexture (sampler2D) → sampler 0
      ..setImageSampler(0, image);

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(_RippleShaderPainter old) =>
      progress != old.progress ||
      color != old.color ||
      waveCount != old.waveCount ||
      amplitude != old.amplitude;
}
