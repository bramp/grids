import 'dart:math' show Random, max;

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:grids/ui/themes/cyber_theme.dart';
import 'package:grids/ui/widgets/backgrounds/ar_scan_lines.dart';
import 'package:grids/ui/widgets/backgrounds/bio_neural_network.dart';
import 'package:grids/ui/widgets/backgrounds/flowing_plasma_trails.dart';
import 'package:grids/ui/widgets/backgrounds/gaussian_orbs.dart';
import 'package:grids/ui/widgets/backgrounds/matrix_data_rain.dart';
import 'package:grids/ui/widgets/backgrounds/parallax_dust.dart';
import 'package:grids/ui/widgets/backgrounds/particle_accelerator_ring.dart';
import 'package:grids/ui/widgets/backgrounds/plasma_lightning.dart';
import 'package:grids/ui/widgets/backgrounds/sound_waves.dart';
import 'package:grids/ui/widgets/win_animations/code_burst.dart';
import 'package:grids/ui/widgets/win_animations/holographic_overlay.dart';
import 'package:grids/ui/widgets/win_animations/particle_implosion.dart';
import 'package:grids/ui/widgets/win_animations/shockwave_ring.dart';
import 'package:grids_engine/cell.dart';
import 'package:widgetbook/widgetbook.dart';

/// Standalone Widgetbook for previewing all background scenes.
///
/// Run with:
///   flutter run -t tool/background_demo.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();
  runApp(const BackgroundWidgetbook());
}

/// Dark background color used across the cyber theme.
const _darkBg = Color(0xFF0D0E15);

/// Default neon cyan accent.
const _defaultCyan = Color(0xFF00FFCC);

/// Wraps a background widget in a full-bleed dark container.
Widget _wrap(Widget child, {Color bg = _darkBg}) {
  return ColoredBox(
    color: bg,
    child: SizedBox.expand(child: child),
  );
}

/// Renders a real CyberTheme grid at [gridSize] × [gridSize] with interactive
/// tappable cells.
class _InteractivePuzzleGrid extends StatefulWidget {
  const _InteractivePuzzleGrid({
    this.gridSize = 5,
    this.isSolved = false,
    this.showErrors = false,
    this.lockedCells = false,
    this.mechanic = _CellMechanic.blank,
  });

  final int gridSize;
  final bool isSolved;
  final bool showErrors;
  final bool lockedCells;
  final _CellMechanic mechanic;

  @override
  State<_InteractivePuzzleGrid> createState() => _InteractivePuzzleGridState();
}

enum _CellMechanic { blank, number, diamond, flower, dash, diagonalDash, void_ }

class _InteractivePuzzleGridState extends State<_InteractivePuzzleGrid> {
  static const _referenceCellSize = 100.0;
  static const _minGridDimension = 3;
  static const _theme = CyberTheme();

  late Set<int> _litCells;
  int? _pressedCell;

  @override
  void initState() {
    super.initState();
    _seedLitCells();
  }

  @override
  void didUpdateWidget(_InteractivePuzzleGrid old) {
    super.didUpdateWidget(old);
    if (old.gridSize != widget.gridSize) _seedLitCells();
  }

  void _seedLitCells() {
    final rng = Random(42);
    final total = widget.gridSize * widget.gridSize;
    _litCells = {
      for (var i = 0; i < total; i++)
        if (rng.nextDouble() < 0.4) i,
    };
  }

  void _toggleCell(int index) {
    setState(() {
      if (_litCells.contains(index)) {
        _litCells.remove(index);
      } else {
        _litCells.add(index);
      }
    });
  }

  Cell _buildMechanic(_CellMechanic type, int idx) {
    final color = CellColor.values[idx % CellColor.values.length];
    return switch (type) {
      _CellMechanic.blank => const BlankCell(),
      _CellMechanic.number => NumberCell((idx % 4) + 1, color: color),
      _CellMechanic.diamond => DiamondCell(color),
      _CellMechanic.flower => FlowerCell(idx % 5),
      _CellMechanic.dash => DashCell(color),
      _CellMechanic.diagonalDash => DiagonalDashCell(color),
      _CellMechanic.void_ => const VoidCell(),
    };
  }

  Widget _buildMechanicChild(BuildContext context, Cell mechanic) {
    return switch (mechanic) {
      BlankCell() || VoidCell() => const SizedBox.shrink(),
      NumberCell() => Center(
        child: _theme.buildNumberMechanic(context, mechanic),
      ),
      DiamondCell() => Center(
        child: _theme.buildDiamondMechanic(context, mechanic),
      ),
      FlowerCell() => Center(
        child: _theme.buildFlowerMechanic(context, mechanic),
      ),
      DashCell() => Center(
        child: _theme.buildDashMechanic(context, mechanic),
      ),
      DiagonalDashCell() => Center(
        child: _theme.buildDiagonalDashMechanic(context, mechanic),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = widget.gridSize;
    final clampedSize = max(gridSize, _minGridDimension);
    final rng = Random(7); // Deterministic for error/lock positions.

    return Center(
      child: FittedBox(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: clampedSize * _referenceCellSize,
              height: clampedSize * _referenceCellSize,
            ),
            _theme.buildGridBackground(
              context,
              isSolved: widget.isSolved,
              child: SizedBox(
                width: gridSize * _referenceCellSize,
                height: gridSize * _referenceCellSize,
                child: Column(
                  children: List.generate(
                    gridSize,
                    (y) => SizedBox(
                      height: _referenceCellSize,
                      child: Row(
                        children: List.generate(gridSize, (x) {
                          final idx = y * gridSize + x;
                          final isLit = _litCells.contains(idx);
                          final isLocked =
                              widget.lockedCells && rng.nextDouble() < 0.2;
                          final hasError =
                              widget.showErrors && isLit && idx % 5 == 0;

                          final mechanic = _buildMechanic(
                            widget.mechanic,
                            idx,
                          );

                          return SizedBox(
                            width: _referenceCellSize,
                            height: _referenceCellSize,
                            child: Padding(
                              padding: EdgeInsets.all(_theme.cellPadding),
                              child: GestureDetector(
                                onTapDown: (_) =>
                                    setState(() => _pressedCell = idx),
                                onTapUp: (_) {
                                  setState(() => _pressedCell = null);
                                  if (!isLocked) _toggleCell(idx);
                                },
                                onTapCancel: () =>
                                    setState(() => _pressedCell = null),
                                child: _theme.buildCellBackground(
                                  context,
                                  mechanic: mechanic,
                                  isLocked: isLocked,
                                  isLit: isLit,
                                  hasError: hasError,
                                  isHovered: false,
                                  isFocused: false,
                                  isPressed: _pressedCell == idx,
                                  child: _buildMechanicChild(
                                    context,
                                    mechanic,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wrapper that places a win animation over a real CyberTheme puzzle grid and
/// provides a Replay button to re-trigger the one-shot animation.
class _WinAnimationPreview extends StatefulWidget {
  const _WinAnimationPreview({
    required this.gridSize,
    required this.animationBuilder,
    this.color = _defaultCyan,
  });

  final int gridSize;
  final Color color;
  final Widget Function(Key key) animationBuilder;

  @override
  State<_WinAnimationPreview> createState() => _WinAnimationPreviewState();
}

class _WinAnimationPreviewState extends State<_WinAnimationPreview> {
  var _animKey = UniqueKey();

  void _replay() => setState(() => _animKey = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: _darkBg, child: SizedBox.expand()),
        _InteractivePuzzleGrid(
          gridSize: widget.gridSize,
          isSolved: true,
        ),
        widget.animationBuilder(_animKey),
        Positioned(
          right: 12,
          bottom: 12,
          child: FloatingActionButton.small(
            backgroundColor: widget.color.withAlpha(200),
            onPressed: _replay,
            child: const Icon(Icons.replay, color: _darkBg),
          ),
        ),
      ],
    );
  }
}

class BackgroundWidgetbook extends StatelessWidget {
  const BackgroundWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        ViewportAddon(Viewports.all),
        TextScaleAddon(),
        // SemanticsAddon is stable enough for widgetbook usage.
        // ignore: experimental_member_use
        SemanticsAddon(),
      ],
      directories: [
        WidgetbookCategory(
          name: 'Backgrounds',
          children: [
            WidgetbookComponent(
              name: 'ArScanLines',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    ArScanLines(
                      lineSpacing: context.knobs.double.slider(
                        label: 'lineSpacing',
                        initialValue: 3,
                        min: 1,
                        max: 10,
                      ),
                      lineColor: context.knobs.color(
                        label: 'lineColor',
                        initialValue: _defaultCyan,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'BioNeuralNetwork',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    BioNeuralNetwork(
                      nodeCount: context.knobs.int.slider(
                        label: 'nodeCount',
                        initialValue: 40,
                        min: 5,
                        max: 100,
                      ),
                      color: context.knobs.color(
                        label: 'color',
                        initialValue: _defaultCyan,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'FlowingPlasmaTrails',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    FlowingPlasmaTrails(
                      trailCount: context.knobs.int.slider(
                        label: 'trailCount',
                        initialValue: 6,
                        min: 1,
                        max: 15,
                      ),
                      trailColor: context.knobs.color(
                        label: 'trailColor',
                        initialValue: _defaultCyan,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'GaussianOrbs',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(const GaussianOrbs()),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'MatrixDataRain',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    MatrixDataRain(
                      columnWidth: context.knobs.double.slider(
                        label: 'columnWidth',
                        initialValue: 18,
                        min: 8,
                        max: 40,
                      ),
                      charHeight: context.knobs.double.slider(
                        label: 'charHeight',
                        initialValue: 14,
                        min: 8,
                        max: 30,
                      ),
                      fallSpeed: context.knobs.double.slider(
                        label: 'fallSpeed',
                        initialValue: 30,
                        min: 5,
                        max: 100,
                      ),
                      color: context.knobs.color(
                        label: 'color',
                        initialValue: const Color(0xFF0A3A2A),
                      ),
                      accentColor: context.knobs.color(
                        label: 'accentColor',
                        initialValue: _defaultCyan,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'ParallaxDust',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    ParallaxDust(
                      density: context.knobs.double.slider(
                        label: 'density',
                        initialValue: 0.0005,
                        min: 0.0001,
                        max: 0.002,
                        precision: 4,
                      ),
                      maxShift: context.knobs.double.slider(
                        label: 'maxShift',
                        initialValue: 12,
                        max: 40,
                      ),
                      minBrightness: context.knobs.double.slider(
                        label: 'minBrightness',
                        initialValue: 0.15,
                        max: 1,
                      ),
                      maxBrightness: context.knobs.double.slider(
                        label: 'maxBrightness',
                        initialValue: 0.50,
                        max: 1,
                      ),
                      driftScale: context.knobs.double.slider(
                        label: 'driftScale',
                        initialValue: 0.03,
                        max: 0.2,
                        precision: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'ParticleAcceleratorRing',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    ParticleAcceleratorRing(
                      particleCount: context.knobs.int.slider(
                        label: 'particleCount',
                        initialValue: 60,
                        min: 10,
                        max: 150,
                      ),
                      spread: context.knobs.double.slider(
                        label: 'spread',
                        initialValue: 40,
                        min: 5,
                        max: 120,
                      ),
                      color: context.knobs.color(
                        label: 'color',
                        initialValue: _defaultCyan,
                      ),
                      secondaryColor: context.knobs.color(
                        label: 'secondaryColor',
                        initialValue: const Color(0xFF00BB99),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'PlasmaLightning',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    PlasmaLightning(
                      color: context.knobs.color(
                        label: 'color',
                        initialValue: _defaultCyan,
                      ),
                      boltWidth: context.knobs.double.slider(
                        label: 'boltWidth',
                        initialValue: 1.5,
                        min: 0.5,
                        max: 5,
                      ),
                      spawnInterval: context.knobs.double.slider(
                        label: 'spawnInterval',
                        initialValue: 3.5,
                        min: 0.5,
                        max: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'SoundWaves',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    SoundWaves(
                      lineCount: context.knobs.int.slider(
                        label: 'lineCount',
                        initialValue: 3,
                        min: 1,
                      ),
                      lineSpacing: context.knobs.double.slider(
                        label: 'lineSpacing',
                        initialValue: 12,
                        min: 2,
                        max: 40,
                      ),
                      color: context.knobs.color(
                        label: 'color',
                        initialValue: _defaultCyan,
                      ),
                      amplitude: context.knobs.double.slider(
                        label: 'amplitude',
                        initialValue: 8,
                        min: 1,
                        max: 30,
                      ),
                      mirror: context.knobs.boolean(
                        label: 'mirror',
                        initialValue: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Grid',
          children: [
            WidgetbookComponent(
              name: 'PuzzleGrid',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) {
                    final gridSize = context.knobs.int.slider(
                      label: 'gridSize',
                      initialValue: 5,
                      min: 1,
                      max: 8,
                    );
                    final isSolved = context.knobs.boolean(
                      label: 'isSolved',
                    );
                    final showErrors = context.knobs.boolean(
                      label: 'showErrors',
                    );
                    final lockedCells = context.knobs.boolean(
                      label: 'lockedCells',
                    );
                    final mechanic = context.knobs.object.dropdown(
                      label: 'mechanic',
                      options: _CellMechanic.values,
                      labelBuilder: (m) => m.name,
                    );
                    return _wrap(
                      _InteractivePuzzleGrid(
                        gridSize: gridSize,
                        isSolved: isSolved,
                        showErrors: showErrors,
                        lockedCells: lockedCells,
                        mechanic: mechanic,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Win Animations',
          children: [
            WidgetbookComponent(
              name: 'CodeBurst',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) {
                    final gridSize = context.knobs.int.slider(
                      label: 'gridSize',
                      initialValue: 5,
                      min: 1,
                      max: 8,
                    );
                    final color = context.knobs.color(
                      label: 'color',
                      initialValue: _defaultCyan,
                    );
                    final particleCount = context.knobs.int.slider(
                      label: 'particleCount',
                      initialValue: 120,
                      min: 20,
                      max: 300,
                    );
                    final durationMs = context.knobs.int.slider(
                      label: 'duration (ms)',
                      initialValue: 2500,
                      min: 500,
                      max: 5000,
                    );
                    return _WinAnimationPreview(
                      gridSize: gridSize,
                      color: color,
                      animationBuilder: (key) => CodeBurst(
                        key: key,
                        color: color,
                        particleCount: particleCount,
                        duration: Duration(milliseconds: durationMs),
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'ParticleImplosion',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) {
                    final gridSize = context.knobs.int.slider(
                      label: 'gridSize',
                      initialValue: 5,
                      min: 1,
                      max: 8,
                    );
                    final color = context.knobs.color(
                      label: 'color',
                      initialValue: _defaultCyan,
                    );
                    final particleCount = context.knobs.int.slider(
                      label: 'particleCount',
                      initialValue: 80,
                      min: 10,
                      max: 200,
                    );
                    final durationMs = context.knobs.int.slider(
                      label: 'duration (ms)',
                      initialValue: 2500,
                      min: 500,
                      max: 5000,
                    );
                    return _WinAnimationPreview(
                      gridSize: gridSize,
                      color: color,
                      animationBuilder: (key) => ParticleImplosion(
                        key: key,
                        color: color,
                        particleCount: particleCount,
                        duration: Duration(milliseconds: durationMs),
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'HolographicOverlay',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) {
                    final gridSize = context.knobs.int.slider(
                      label: 'gridSize',
                      initialValue: 5,
                      min: 1,
                      max: 8,
                    );
                    final color = context.knobs.color(
                      label: 'color',
                      initialValue: _defaultCyan,
                    );
                    final text = context.knobs.string(
                      label: 'text',
                      initialValue: 'SOLVED',
                    );
                    final durationMs = context.knobs.int.slider(
                      label: 'duration (ms)',
                      initialValue: 3000,
                      min: 500,
                      max: 6000,
                    );
                    return _WinAnimationPreview(
                      gridSize: gridSize,
                      color: color,
                      animationBuilder: (key) => HolographicOverlay(
                        key: key,
                        color: color,
                        text: text,
                        duration: Duration(milliseconds: durationMs),
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'ShockwaveRing',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) {
                    final gridSize = context.knobs.int.slider(
                      label: 'gridSize',
                      initialValue: 5,
                      min: 1,
                      max: 8,
                    );
                    final color = context.knobs.color(
                      label: 'color',
                      initialValue: _defaultCyan,
                    );
                    final ringCount = context.knobs.int.slider(
                      label: 'ringCount',
                      initialValue: 5,
                      min: 1,
                      max: 10,
                    );
                    final durationMs = context.knobs.int.slider(
                      label: 'duration (ms)',
                      initialValue: 2000,
                      min: 500,
                      max: 5000,
                    );
                    return _WinAnimationPreview(
                      gridSize: gridSize,
                      color: color,
                      animationBuilder: (key) => ShockwaveRing(
                        key: key,
                        color: color,
                        ringCount: ringCount,
                        duration: Duration(milliseconds: durationMs),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
