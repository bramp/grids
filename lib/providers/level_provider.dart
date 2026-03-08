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
import 'package:grids/services/progress_service.dart';

/// The active puzzle grid that the user is interacting with.
class LevelProvider extends ChangeNotifier {
  LevelProvider(this._progressService) {
    _maxUnlockedLevelIndex = 0; // Default

    // Seed progress from stored values
    final lastPlayed = _progressService.getLastLevelPlayed();
    if (lastPlayed != null) {
      final index = LevelRepository.levels.indexWhere(
        (l) => l.id == lastPlayed,
      );
      if (index != -1) {
        _currentLevelIndex = index;
      }
    }

    // Determine max unlocked block
    // TODO(bramp): This concept may need tweaking,
    // if we implement a branch of levels.
    for (var i = 0; i < LevelRepository.levels.length; i++) {
      if (_progressService.isLevelUnlocked(LevelRepository.levels[i].id)) {
        if (i > _maxUnlockedLevelIndex) {
          _maxUnlockedLevelIndex = i;
        }
      }
    }

    // Guarantee the first level is always unlocked
    if (!_progressService.isLevelUnlocked(LevelRepository.levels[0].id)) {
      unawaited(
        _progressService.saveLevelUnlocked(LevelRepository.levels[0].id),
      );
    }

    _loadLevel(_currentLevelIndex);
  }

  final ProgressService _progressService;
  final PuzzleValidator _validator = PuzzleValidator();

  int _currentLevelIndex = 0;
  int _maxUnlockedLevelIndex = 0;
  late Level _currentLevel;
  late Puzzle _puzzle;

  // Track cells that have been flipped during the current drag event.
  final Set<GridPoint> _currentlyDraggedCells = {};

  // Track the cell currently being hovered/pressed by the drag pointer.
  GridPoint? _activeDragPoint;

  // The state (lit or unlit) that the current drag operation is applying.
  bool? _dragActionLit;

  // Validation is only populated when the user explicitly taps "Check Answer"
  ValidationResult? _lastValidation;

  DateTime? _levelStartTime;
  int _solveAttempts = 0;

  Level get currentLevel => _currentLevel;
  Puzzle get puzzle => _puzzle;
  ValidationResult? get validation => _lastValidation;
  GridPoint? get activeDragPoint => _activeDragPoint;

  bool get isSolved => _lastValidation?.isValid ?? false;

  void _loadLevel(int index) {
    var loadIndex = index;
    if (loadIndex >= LevelRepository.levels.length) {
      // Loop back to start or handle "game complete" state
      loadIndex = 0;
    }

    _currentLevelIndex = loadIndex;
    _currentLevel = LevelRepository.levels[loadIndex];

    // Check if we have a saved solution state for this level
    final savedState = _progressService.getSolution(
      _currentLevel.id,
      _currentLevel.puzzle.width,
      _currentLevel.puzzle.height,
    );

    if (savedState != null) {
      _puzzle = _currentLevel.puzzle.copyWith(state: savedState);
    } else {
      _puzzle = _currentLevel.puzzle;
    }

    _lastValidation = null;
    _levelStartTime = clock.now();
    _solveAttempts = 0;
  }

  /// Refreshes the active state dynamically after async init.
  void refresh() {
    _loadLevel(_currentLevelIndex);
    notifyListeners();
  }

  bool get hasPreviousLevel => _currentLevelIndex > 0;
  bool get hasNextLevel =>
      _currentLevelIndex < LevelRepository.levels.length - 1 &&
      _currentLevelIndex < _maxUnlockedLevelIndex;

  /// Toggles the specified cell, updating validation and notifying listeners.
  void toggleCell(GridPoint pt) {
    _puzzle = _puzzle.toggle(pt);
    _lastValidation = null; // Clear previous validation attempt
    unawaited(_progressService.saveSolution(_currentLevel.id, _puzzle.state));
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

  /// Updates the currently highlighted drag point.
  void setHoveredDragPoint(GridPoint? pt) {
    if (_activeDragPoint != pt) {
      _activeDragPoint = pt;
      notifyListeners();
    }
  }

  /// Clears the dragging sweep tracking when the user releases their finger.
  void endDrag() {
    if (_currentlyDraggedCells.isNotEmpty) {
      unawaited(_progressService.saveSolution(_currentLevel.id, _puzzle.state));
    }
    _currentlyDraggedCells.clear();
    _dragActionLit = null;
    _activeDragPoint = null;
    notifyListeners();
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

        // Save advancement progress
        if (_maxUnlockedLevelIndex < LevelRepository.levels.length) {
          final unlockedLevelId =
              LevelRepository.levels[_maxUnlockedLevelIndex].id;
          unawaited(_progressService.saveLevelUnlocked(unlockedLevelId));
        }
      }

      // Save their solution for this level
      unawaited(_progressService.saveSolution(_currentLevel.id, _puzzle.state));
    }
    notifyListeners();
  }

  String? get nextLevelId =>
      hasNextLevel ? LevelRepository.levels[_currentLevelIndex + 1].id : null;

  /// Advances the game to the next available level puzzle.
  void nextLevel() {
    if (hasNextLevel) {
      _loadLevel(_currentLevelIndex + 1);
      unawaited(_progressService.saveLastLevelPlayed(_currentLevel.id));
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
      unawaited(_progressService.saveLastLevelPlayed(_currentLevel.id));
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
    unawaited(_progressService.saveLastLevelPlayed(_currentLevel.id));
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
        unawaited(_progressService.saveLevelUnlocked(id));
      }
      _loadLevel(index);
      unawaited(_progressService.saveLastLevelPlayed(_currentLevel.id));
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
