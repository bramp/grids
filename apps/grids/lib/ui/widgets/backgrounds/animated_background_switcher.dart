import 'package:flutter/material.dart';

import 'package:grids/ui/widgets/backgrounds/background_scene.dart';

/// Cross-fades between [BackgroundScene]s when the scene changes.
///
/// Wrap this around your scene to get automatic opacity transitions.
/// The transition uses the scene's [BackgroundScene.name] as the
/// [ValueKey] so that identical scenes don't re-animate.
class AnimatedBackgroundSwitcher extends StatelessWidget {
  const AnimatedBackgroundSwitcher({
    required this.scene,
    super.key,
    this.duration = const Duration(milliseconds: 1200),
  });

  /// The currently active scene.
  final BackgroundScene scene;

  /// How long the cross-fade takes.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      child: KeyedSubtree(
        key: ValueKey(scene.name),
        child: scene.build(),
      ),
    );
  }
}
