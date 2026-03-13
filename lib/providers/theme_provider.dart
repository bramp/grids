import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:grids/ui/themes/cyber_theme.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';

class ThemeProvider extends ChangeNotifier {
  final List<PuzzleTheme> _themes = [const CyberTheme()];
  late PuzzleTheme _activeTheme = _themes.first;

  List<PuzzleTheme> get availableThemes => UnmodifiableListView(_themes);
  PuzzleTheme get activeTheme => _activeTheme;

  void setTheme(PuzzleTheme theme) {
    if (_themes.contains(theme) && _activeTheme != theme) {
      _activeTheme = theme;
      notifyListeners();
    }
  }
}
