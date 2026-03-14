import 'package:flutter/material.dart';

import 'package:grids/ui/widgets/backgrounds/ar_scan_lines.dart';
import 'package:grids/ui/widgets/backgrounds/background_scene.dart';
import 'package:grids/ui/widgets/backgrounds/bio_neural_network.dart';
import 'package:grids/ui/widgets/backgrounds/flowing_plasma_trails.dart';
import 'package:grids/ui/widgets/backgrounds/gaussian_orbs.dart';
import 'package:grids/ui/widgets/backgrounds/matrix_data_rain.dart';
import 'package:grids/ui/widgets/backgrounds/parallax_dust.dart';
import 'package:grids/ui/widgets/backgrounds/particle_accelerator_ring.dart';
import 'package:grids/ui/widgets/backgrounds/plasma_lightning.dart';
import 'package:grids/ui/widgets/backgrounds/sound_waves.dart';

/// Deep dark blue-black used across the cyber/dark scenes.
const _darkBg = Color(0xFF0D0E15);

/// All pre-built background scenes, indexed by name.
///
/// Each scene composes one or more background layers.  A puzzle (or group
/// of puzzles) can reference a scene by name to get its unique atmosphere.
///
/// The list is ordered roughly from "simplest" to "most complex" so the
/// demo app can iterate over them in a sensible order.
// keep-sorted start
final Map<String, BackgroundScene> backgroundScenes = {
  'AR Interface': const BackgroundScene(
    name: 'AR Interface',
    backgroundColor: _darkBg,
    layers: [
      ParallaxDust(),
      ArScanLines(),
    ],
  ),
  'Bio-Neural Network': const BackgroundScene(
    name: 'Bio-Neural Network',
    backgroundColor: _darkBg,
    layers: [
      ParallaxDust(),
      BioNeuralNetwork(),
    ],
  ),
  'Cyber (Default)': const BackgroundScene(
    name: 'Cyber (Default)',
    backgroundColor: _darkBg,
    layers: [
      ParallaxDust(),
      GaussianOrbs(),
      PlasmaLightning(),
    ],
  ),
  'Flowing Plasma Trails': const BackgroundScene(
    name: 'Flowing Plasma Trails',
    backgroundColor: _darkBg,
    layers: [
      ParallaxDust(),
      FlowingPlasmaTrails(),
      PlasmaLightning(),
    ],
  ),
  'Matrix Data Rain': const BackgroundScene(
    name: 'Matrix Data Rain',
    backgroundColor: _darkBg,
    layers: [
      ParallaxDust(),
      MatrixDataRain(),
    ],
  ),
  'Particle Accelerator': const BackgroundScene(
    name: 'Particle Accelerator',
    backgroundColor: _darkBg,
    layers: [
      ParallaxDust(),
      ParticleAcceleratorRing(),
    ],
  ),
  'Sound Waves': const BackgroundScene(
    name: 'Sound Waves',
    backgroundColor: _darkBg,
    layers: [
      ParallaxDust(),
      SoundWaves(),
    ],
  ),
};
// keep-sorted end
