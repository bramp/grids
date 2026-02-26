import 'dart:async';

import 'package:clock/clock.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:grids/data/level_repository.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/level.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/puzzle_validator.dart';
import 'package:grids/engine/rule_validator.dart';

/// The active puzzle grid that the user is interacting with.
class LevelProvider extends ChangeNotifier {
  LevelProvider() {
    _loadLevel(_currentLevelIndex);
  }
  final PuzzleValidator _validator = PuzzleValidator();

  int _currentLevelIndex = 0;
  int _maxUnlockedLevelIndex = 0;
  late Level _currentLevel;
  late Puzzle _puzzle;

  // Track cells that have been flipped during the current drag event.
  final Set<GridPoint> _currentlyDraggedCells = {};

  // The state (lit or unlit) that the current drag operation is applying.
  bool? _dragActionLit;

  // Validation is only populated when the user explicitly taps "Check Answer"
  ValidationResult? _lastValidation;

  DateTime? _levelStartTime;
  int _solveAttempts = 0;

  Level get currentLevel => _currentLevel;
  Puzzle get puzzle => _puzzle;
  ValidationResult? get validation => _lastValidation;

  bool get isSolved => _lastValidation?.isValid ?? false;

  void _loadLevel(int index) {
    var loadIndex = index;
    if (loadIndex >= LevelRepository.levels.length) {
      // Loop back to start or handle "game complete" state
      loadIndex = 0;
    }

    _currentLevelIndex = loadIndex;
    _currentLevel = LevelRepository.levels[loadIndex];
    _puzzle = _currentLevel.puzzle;
    _lastValidation = null;
    _levelStartTime = clock.now();
    _solveAttempts = 0;
  }

  bool get hasPreviousLevel => _currentLevelIndex > 0;
  bool get hasNextLevel =>
      _currentLevelIndex < LevelRepository.levels.length - 1 &&
      _currentLevelIndex < _maxUnlockedLevelIndex;

  /// Toggles the specified cell, updating validation and notifying listeners.
  void toggleCell(GridPoint pt) {
    _puzzle = _puzzle.toggle(pt);
    _lastValidation = null; // Clear previous validation attempt
    notifyListeners();
  }

  /// Toggles a cell specifically during a drag motion.
  /// The first cell touched determines if the drag is "lighting" or
  /// "unlighting" cells.
  void dragToggleCell(GridPoint pt) {
    if (_currentlyDraggedCells.contains(pt)) return;

    // First cell dictates the painting action for this entire drag operation
    if (_currentlyDraggedCells.isEmpty) {
      _puzzle = _puzzle.toggle(pt);
      _dragActionLit = _puzzle.isLit(pt);
      _currentlyDraggedCells.add(pt);
      _lastValidation = null;
      notifyListeners();
      return;
    }

    // For all passing cells, force them to match the active drag's action state
    final isCurrentlyLit = _puzzle.isLit(pt);
    if (isCurrentlyLit != _dragActionLit) {
      _puzzle = _puzzle.toggle(pt);
      _lastValidation = null;
      notifyListeners();
    }

    _currentlyDraggedCells.add(pt);
  }

  /// Clears the dragging sweep tracking when the user releases their finger.
  void endDrag() {
    _currentlyDraggedCells.clear();
    _dragActionLit = null;
  }

  /// Explicitly runs the validation rules against the current board state.
  void checkAnswer() {
    _solveAttempts++;
    _lastValidation = _validator.validate(_puzzle);
    final isValid = _lastValidation?.isValid == true;

    try {
      if (Firebase.apps.isNotEmpty) {
        final analytics = FirebaseAnalytics.instance;

        // Log the check answer attempt
        unawaited(
          analytics.logEvent(
            name: 'level_solve_attempt',
            parameters: {
              'level_id': _currentLevel.id,
              'is_correct': isValid ? 1 : 0,
              'attempt_number': _solveAttempts,
            },
          ),
        );

        if (isValid && _levelStartTime != null) {
          final timeMs = clock
              .now()
              .difference(_levelStartTime!)
              .inMilliseconds;
          // Log a successful solve with timing details
          unawaited(
            analytics.logEvent(
              name: 'level_complete',
              parameters: {
                'level_id': _currentLevel.id,
                'time_ms': timeMs,
                'total_attempts': _solveAttempts,
              },
            ),
          );
        }
      }
    } on Object catch (e) {
      debugPrint('Analytics error: $e');
    }

    if (isValid) {
      if (_currentLevelIndex >= _maxUnlockedLevelIndex) {
        _maxUnlockedLevelIndex = _currentLevelIndex + 1;
      }
    }
    notifyListeners();
  }

  String? get nextLevelId =>
      hasNextLevel ? LevelRepository.levels[_currentLevelIndex + 1].id : null;

  /// Advances the game to the next available level puzzle.
  void nextLevel() {
    if (hasNextLevel) {
      _loadLevel(_currentLevelIndex + 1);
      notifyListeners();
    }
  }

  String? get previousLevelId => hasPreviousLevel
      ? LevelRepository.levels[_currentLevelIndex - 1].id
      : null;

  /// Goes back to the previous level.
  void previousLevel() {
    if (hasPreviousLevel) {
      _loadLevel(_currentLevelIndex - 1);
      notifyListeners();
    }
  }

  /// Jumps directly to a level by index, bypassing the unlock gate.
  /// Intended for debug/development use only.
  void jumpToLevel(int index) {
    assert(
      index >= 0 && index < LevelRepository.levels.length,
      'Level index $index out of range',
    );
    _loadLevel(index);
    notifyListeners();
  }

  /// The index of the currently active level.
  int get currentLevelIndex => _currentLevelIndex;

  /// Loads a level by its ID.
  void loadLevelById(String id) {
    if (_currentLevel.id == id) return;
    final index = LevelRepository.levels.indexWhere((l) => l.id == id);
    if (index != -1) {
      if (index > _maxUnlockedLevelIndex) {
        _maxUnlockedLevelIndex = index;
      }
      _loadLevel(index);
      notifyListeners();
    }
  }

  /// Loads a custom puzzle directly. Primarily for testing or debug.
  void loadCustomPuzzle(Puzzle puzzle) {
    _currentLevel = Level(id: 'custom', puzzle: puzzle);
    _puzzle = puzzle;
    _lastValidation = null;
    _levelStartTime = clock.now();
    _solveAttempts = 0;
    notifyListeners();
  }
}
