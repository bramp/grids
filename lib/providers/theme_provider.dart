import 'package:flutter/material.dart';
import 'package:grids/ui/themes/casino_theme.dart';
import 'package:grids/ui/themes/classic_theme.dart';
import 'package:grids/ui/themes/neo_theme.dart';
import 'package:grids/ui/themes/neon_theme.dart';
import 'package:grids/ui/themes/pixel_theme.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _themes = [
      const ClassicTheme(),
      const NeoTheme(),
      const CasinoTheme(),
      const PixelTheme(),
      const NeonTheme(),
    ];
    _activeTheme = _themes.first;
  }

  late List<PuzzleTheme> _themes;
  late PuzzleTheme _activeTheme;

  List<PuzzleTheme> get availableThemes => _themes;
  PuzzleTheme get activeTheme => _activeTheme;

  void setTheme(PuzzleTheme theme) {
    if (_themes.contains(theme) && _activeTheme != theme) {
      _activeTheme = theme;
      notifyListeners();
    }
  }
}
