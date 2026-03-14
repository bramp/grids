import 'package:flutter/material.dart';

/// A composable set of background layers that form a visual scene behind
/// the game UI.
///
/// Each scene has a solid [backgroundColor] and zero or more animated
/// [layers] stacked bottom-to-top.  Scenes are cheap to create and can be
/// swapped freely — use `AnimatedBackgroundSwitcher` for smooth transitions.
@immutable
class BackgroundScene {
  const BackgroundScene({
    required this.name,
    required this.backgroundColor,
    this.layers = const [],
  });

  /// Human-readable identifier (also used as the [AnimatedSwitcher] key).
  final String name;

  /// Solid color drawn behind all layers.
  final Color backgroundColor;

  /// Animated layers rendered bottom-to-top above [backgroundColor].
  final List<Widget> layers;

  /// Build a widget tree for this scene (background color + layers).
  Widget build() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: backgroundColor),
        for (final layer in layers) Positioned.fill(child: layer),
      ],
    );
  }
}
