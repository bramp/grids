import 'package:flutter/material.dart';
import 'package:grids/ui/widgets/backgrounds/abstract_sound_waves.dart';
import 'package:grids/ui/widgets/backgrounds/ar_scan_lines.dart';
import 'package:grids/ui/widgets/backgrounds/bio_neural_network.dart';
import 'package:grids/ui/widgets/backgrounds/blueprint_grid.dart';
import 'package:grids/ui/widgets/backgrounds/celestial_blueprint_grid.dart';
import 'package:grids/ui/widgets/backgrounds/deep_level_cavern_scan.dart';
import 'package:grids/ui/widgets/backgrounds/flowing_plasma_trails.dart';
import 'package:grids/ui/widgets/backgrounds/gaussian_orbs.dart';
import 'package:grids/ui/widgets/backgrounds/geometric_data_topography.dart';
import 'package:grids/ui/widgets/backgrounds/holographic_topography.dart';
import 'package:grids/ui/widgets/backgrounds/matrix_data_rain.dart';
import 'package:grids/ui/widgets/backgrounds/parallax_dust.dart';
import 'package:grids/ui/widgets/backgrounds/particle_accelerator_ring.dart';
import 'package:grids/ui/widgets/backgrounds/plasma_lightning.dart';
import 'package:widgetbook/widgetbook.dart';

/// Standalone Widgetbook for previewing all background scenes.
///
/// Run with:
///   flutter run -t tool/background_demo.dart
void main() {
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

class BackgroundWidgetbook extends StatelessWidget {
  const BackgroundWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookCategory(
          name: 'Backgrounds',
          children: [
            WidgetbookComponent(
              name: 'AbstractSoundWaves',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    AbstractSoundWaves(
                      lineCount: context.knobs.int.slider(
                        label: 'lineCount',
                        initialValue: 3,
                        min: 1,
                        max: 8,
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
                    ),
                  ),
                ),
              ],
            ),
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
              name: 'BlueprintGrid',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    BlueprintGrid(
                      majorSpacing: context.knobs.double.slider(
                        label: 'majorSpacing',
                        initialValue: 80,
                        min: 20,
                        max: 200,
                      ),
                      minorSpacing: context.knobs.double.slider(
                        label: 'minorSpacing',
                        initialValue: 20,
                        min: 5,
                        max: 60,
                      ),
                      scrollSpeed: context.knobs.double.slider(
                        label: 'scrollSpeed',
                        initialValue: 1,
                        max: 5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'CelestialBlueprintGrid',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    CelestialBlueprintGrid(
                      starCount: context.knobs.int.slider(
                        label: 'starCount',
                        initialValue: 30,
                        min: 5,
                        max: 80,
                      ),
                      gridSpacing: context.knobs.int.slider(
                        label: 'gridSpacing',
                        initialValue: 120,
                        min: 40,
                        max: 300,
                      ),
                      color: context.knobs.color(
                        label: 'color',
                        initialValue: const Color(0xFF00BBAA),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'DeepLevelCavernScan',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    DeepLevelCavernScan(
                      pingCount: context.knobs.int.slider(
                        label: 'pingCount',
                        initialValue: 5,
                        min: 1,
                        max: 15,
                      ),
                      gridSpacing: context.knobs.int.slider(
                        label: 'gridSpacing',
                        initialValue: 60,
                        min: 20,
                        max: 150,
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
              name: 'GeometricDataTopography',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    GeometricDataTopography(
                      cols: context.knobs.int.slider(
                        label: 'cols',
                        initialValue: 16,
                        min: 4,
                        max: 32,
                      ),
                      rows: context.knobs.int.slider(
                        label: 'rows',
                        initialValue: 12,
                        min: 4,
                        max: 24,
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
              name: 'HolographicTopography',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _wrap(
                    HolographicTopography(
                      ringCount: context.knobs.int.slider(
                        label: 'ringCount',
                        initialValue: 8,
                        min: 2,
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
                        initialValue: const Color(0xFF1A2A2A),
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
                  builder: (context) => _wrap(const PlasmaLightning()),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
