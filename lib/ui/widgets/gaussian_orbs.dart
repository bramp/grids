import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:provider/provider.dart';

/// Animated background of soft, blurred orbs that drift in slow lava-lamp
/// style paths and pulse toward the quadrant where the player toggles cells.
class GaussianOrbs extends StatefulWidget {
  const GaussianOrbs({super.key});

  @override
  State<GaussianOrbs> createState() => _GaussianOrbsState();
}

/// Each orb carries its own set of harmonic coefficients so the combined
/// motion looks organic — like a lava lamp blob lazily drifting around.
class _Orb {
  _Orb({
    required this.radius,
    required this.color,
    required this.harmonicsX,
    required this.harmonicsY,
    required this.breathFreq,
    required this.breathPhase,
  });

  /// Normalized radius (fraction of shortest side).
  final double radius;

  /// Base color (opacity is applied at paint time).
  final Color color;

  /// Harmonic triplets (amplitude, frequency, phase) for each axis.
  /// Summing several sine waves produces wandering, non-repeating paths.
  final List<(double amp, double freq, double phase)> harmonicsX;
  final List<(double amp, double freq, double phase)> harmonicsY;

  /// Frequency and phase for gentle size pulsing ("breathing").
  final double breathFreq;
  final double breathPhase;

  /// Evaluate the normalized position at time [t] seconds.
  Offset positionAt(double t) {
    var x = 0.5;
    var y = 0.5;
    for (final (amp, freq, phase) in harmonicsX) {
      x += amp * sin(freq * t + phase);
    }
    for (final (amp, freq, phase) in harmonicsY) {
      y += amp * sin(freq * t + phase);
    }
    // Allow orbs to drift well off-screen; the blur makes them fade naturally.
    return Offset(x.clamp(-0.3, 1.3), y.clamp(-0.3, 1.3));
  }
}

class _GaussianOrbsState extends State<GaussianOrbs>
    with TickerProviderStateMixin {
  late final AnimationController _driftController;
  late final AnimationController _pulseController;
  late final List<_Orb> _orbs;

  LevelProvider? _provider;
  int _prevToggleCount = -1;

  /// Pulse target in normalized coordinates (0–1).
  Offset _pulseTarget = const Offset(0.5, 0.5);

  static final _random = Random(42);

  @override
  void initState() {
    super.initState();

    // Long duration keeps the value precision high; repeat() loops forever.
    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 240),
    );
    unawaited(_driftController.repeat());

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _orbs = _generateOrbs();
  }

  /// Build orbs with 3 harmonics each so the paths look organic.
  static List<_Orb> _generateOrbs() {
    const colors = [
      Color(0xFF00FFCC), // cyan
      Color(0xFF00BB99), // teal
      Color(0xFF00DDBB), // mid-teal
      Color(0xFF00AA88), // deep teal
      Color(0xFF33FFDD), // bright cyan
      Color(0xFF00EEB8), // seafoam
      Color(0xFF11DDAA), // jade
      Color(0xFF22CCBB), // aqua
      Color(0xFF00CCAA), // mint
      Color(0xFF00FFDD), // ice cyan
      Color(0xFF009977), // emerald
      Color(0xFF44FFEE), // pale cyan
    ];

    List<(double, double, double)> randomHarmonics() {
      // 4 layered sine waves with much higher frequencies for visible motion.
      // The dominant wave sweeps the orb across the full screen over ~15-25 s;
      // additional waves add wobble and unpredictability.
      return [
        (
          0.25 + _random.nextDouble() * 0.20, // amplitude 0.25–0.45
          0.25 + _random.nextDouble() * 0.20, // period ~16–25 s
          _random.nextDouble() * 2 * pi,
        ),
        (
          0.10 + _random.nextDouble() * 0.12,
          0.50 + _random.nextDouble() * 0.40, // period ~7–13 s
          _random.nextDouble() * 2 * pi,
        ),
        (
          0.05 + _random.nextDouble() * 0.06,
          0.90 + _random.nextDouble() * 0.60, // period ~4–7 s
          _random.nextDouble() * 2 * pi,
        ),
        (
          0.02 + _random.nextDouble() * 0.03,
          1.8 + _random.nextDouble() * 1.2, // fast shimmer ~2–3.5 s
          _random.nextDouble() * 2 * pi,
        ),
      ];
    }

    return List.generate(colors.length, (i) {
      return _Orb(
        radius: 0.12 + _random.nextDouble() * 0.20,
        color: colors[i],
        harmonicsX: randomHarmonics(),
        harmonicsY: randomHarmonics(),
        breathFreq: 0.3 + _random.nextDouble() * 0.4, // ~10–21 s cycle
        breathPhase: _random.nextDouble() * 2 * pi,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<LevelProvider>();
    if (_provider != provider) {
      _provider?.removeListener(_onProviderChanged);
      _provider = provider;
      _provider!.addListener(_onProviderChanged);
    }
  }

  void _onProviderChanged() {
    final provider = _provider;
    if (provider == null) return;

    final point = provider.lastToggledPoint;
    final count = provider.toggleCount;
    if (point != null && count != _prevToggleCount) {
      _prevToggleCount = count;

      final w = provider.puzzle.width;
      final h = provider.puzzle.height;
      _pulseTarget = Offset(
        (point.value % w + 0.5) / w,
        (point.value ~/ w + 0.5) / h,
      );
      unawaited(_pulseController.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _provider?.removeListener(_onProviderChanged);
    _driftController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ListenableBuilder(
        listenable: Listenable.merge([_driftController, _pulseController]),
        builder: (context, child) {
          return CustomPaint(
            painter: _OrbPainter(
              orbs: _orbs,
              // Map the 0–1 controller value back to seconds.
              driftSeconds: _driftController.value * 240,
              pulseT: _pulseController.value,
              pulseTarget: _pulseTarget,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  const _OrbPainter({
    required this.orbs,
    required this.driftSeconds,
    required this.pulseT,
    required this.pulseTarget,
  });

  final List<_Orb> orbs;
  final double driftSeconds;

  /// Pulse progress 0 → 1 (0 = start, 1 = settled).
  final double pulseT;

  /// Normalized pulse target (0–1).
  final Offset pulseTarget;

  @override
  void paint(Canvas canvas, Size size) {
    // Quick rise, slow decay.
    final pulseCurve = Curves.easeOut.transform(1 - pulseT);

    for (final orb in orbs) {
      final pos = orb.positionAt(driftSeconds);

      var center = Offset(
        pos.dx * size.width,
        pos.dy * size.height,
      );

      // Shift toward the toggle target during a pulse.
      if (pulseT > 0 && pulseT < 1) {
        final target = Offset(
          pulseTarget.dx * size.width,
          pulseTarget.dy * size.height,
        );
        center += (target - center) * 0.12 * pulseCurve;
      }

      // Breathing size: ±20% of base radius.
      final breathAngle = driftSeconds * orb.breathFreq + orb.breathPhase;
      final breathScale = 1.0 + 0.2 * sin(breathAngle);
      final radius = orb.radius * breathScale * size.shortestSide;

      // Base ~8 % opacity; pulse adds up to ~5 %.
      final opacity = 0.08 + (pulseT > 0 ? 0.05 * pulseCurve : 0);

      final paint = Paint()
        ..color = orb.color.withValues(alpha: opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.7);

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_OrbPainter old) =>
      driftSeconds != old.driftSeconds || pulseT != old.pulseT;
}
