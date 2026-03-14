import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:grids/ui/widgets/backgrounds/ar_scan_lines.dart';
import 'package:grids/ui/widgets/backgrounds/bio_neural_network.dart';
import 'package:grids/ui/widgets/backgrounds/flowing_plasma_trails.dart';
import 'package:grids/ui/widgets/backgrounds/gaussian_orbs.dart';
import 'package:grids/ui/widgets/backgrounds/matrix_data_rain.dart';
import 'package:grids/ui/widgets/backgrounds/parallax_dust.dart';
import 'package:grids/ui/widgets/backgrounds/particle_accelerator_ring.dart';
import 'package:grids/ui/widgets/backgrounds/plasma_lightning.dart';
import 'package:grids/ui/widgets/backgrounds/sound_waves.dart';
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
      ],
    );
  }
}
