import 'dart:async';

import 'package:clock/clock.dart';

import 'package:flutter/foundation.dart';
import 'package:grids/data/level_repository.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/level.dart';
import 'package:grids/engine/level_group.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/puzzle_validator.dart';
import 'package:grids/engine/rule_validator.dart';
import 'package:grids/services/analytics_service.dart';
import 'package:grids/services/progress_service.dart';

/// The active puzzle grid that the user is interacting with.
class LevelProvider extends ChangeNotifier {
  LevelProvider(this._progressService, this._analytics) {
    // Determine unlocked groups initially
    _refreshUnlockedGroups();

    // Default to the first level of the first available group
    _currentGroupId = LevelRepository.worldMap.keys.first;
    _currentLevelIndexInGroup = 0;

    // Seed progress from stored values
    final lastPlayed = _progressService.getLastLevelPlayed();
    if (lastPlayed != null) {
      // Find which group and index this level belongs to
      for (final group in LevelRepository.worldMap.values) {
        final index = group.levels.indexWhere((l) => l.id == lastPlayed);
        if (index != -1) {
          _currentGroupId = group.id;
          _currentLevelIndexInGroup = index;
          break;
        }
      }
    }

    _loadLevel(_currentGroupId, _currentLevelIndexInGroup);
  }

  final ProgressService _progressService;
  final AnalyticsService _analytics;
  final PuzzleValidator _validator = PuzzleValidator();

  String _currentGroupId = '';
  int _currentLevelIndexInGroup = 0;

  // Set of unlocked group IDs
  final Set<String> _unlockedGroups = {};

  late LevelGroup _currentGroup;
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

  Timer? _errorPulseTimer;
  bool _showErrors = true;
  int _errorPulseCount = 0;

  DateTime _levelStartTime = DateTime(0);
  int _solveAttempts = 0;

  /// Last cell toggled (for background animation reactions).
  GridPoint? _lastToggledPoint;
  int _toggleCount = 0;

  LevelGroup get currentGroup => _currentGroup;
  Level get currentLevel => _currentLevel;
  Puzzle get puzzle => _puzzle;
  ValidationResult? get validation {
    if (_lastValidation?.isValid == true) {
      return _lastValidation;
    }
    return _showErrors ? _lastValidation : null;
  }

  GridPoint? get activeDragPoint => _activeDragPoint;

  bool get isSolved => _lastValidation?.isValid ?? false;

  Set<String> get unlockedGroups => _unlockedGroups;

  void _refreshUnlockedGroups() {
    _unlockedGroups.clear();
    for (final group in LevelRepository.worldMap.values) {
      var canUnlock = true;
      for (final req in group.requiredGroups) {
        final reqGroup = LevelRepository.worldMap[req];
        if (reqGroup == null) continue;

        // A group is complete if all of its levels are solved
        final groupLevelIds = reqGroup.levels.map((l) => l.id).toList();
        if (!_progressService.areAllLevelsSolved(groupLevelIds)) {
          canUnlock = false;
          break;
        }
      }

      // Also check if the user has explicitly manually unlocked the first level
      // of this group as a legacy fallback, or if it's the very first root.
      final isRoot = group.requiredGroups.isEmpty;
      final hasProgress =
          group.levels.isNotEmpty &&
          _progressService.isLevelUnlocked(group.levels.first.id);

      if (canUnlock || isRoot || hasProgress) {
        _unlockedGroups.add(group.id);
        if (group.levels.isNotEmpty) {
          // Ensure at least the first level is marked unlocked for UI
          unawaited(
            _progressService.saveLevelUnlocked(group.levels.first.id),
          );
        }
      }
    }
  }

  void _loadLevel(String groupId, int indexInGroup) {
    var activeGroupId = groupId;
    var activeIndexInGroup = indexInGroup;

    if (!LevelRepository.worldMap.containsKey(activeGroupId)) {
      activeGroupId = LevelRepository.worldMap.keys.first;
      activeIndexInGroup = 0;
    }

    _currentGroup = LevelRepository.worldMap[activeGroupId]!;

    var loadIndex = activeIndexInGroup;
    if (loadIndex >= _currentGroup.levels.length || loadIndex < 0) {
      loadIndex = 0;
    }

    _currentGroupId = activeGroupId;
    _currentLevelIndexInGroup = loadIndex;
    _currentLevel = _currentGroup.levels[loadIndex];

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
    _errorPulseTimer?.cancel();
    _showErrors = true;
    _errorPulseCount = 0;

    if (savedState != null) {
      // If the loaded state is perfectly solved, restore the 'Solved' UI state
      final validation = _validator.validate(_puzzle);
      if (validation.isValid) {
        _lastValidation = validation;
      }
    }

    _levelStartTime = clock.now();
    _solveAttempts = 0;
  }

  /// Refreshes the active state dynamically after async init.
  void refresh() {
    _refreshUnlockedGroups();
    _loadLevel(_currentGroupId, _currentLevelIndexInGroup);
    notifyListeners();
  }

  bool get hasPreviousLevel => _currentLevelIndexInGroup > 0;

  bool get hasNextLevel {
    // We can go to the next level if it's within the same group
    // AND if that level is unlocked.
    // In our new graph, you can only 'nextLevel' within a group.
    if (_currentLevelIndexInGroup >= _currentGroup.levels.length - 1) {
      return false;
    }
    final nextLevelId = _currentGroup.levels[_currentLevelIndexInGroup + 1].id;
    return _progressService.isLevelUnlocked(nextLevelId);
  }

  /// Resets the current puzzle to its original (unsolved) state.
  void resetPuzzle() {
    _puzzle = _currentLevel.puzzle;
    _lastValidation = null;
    _errorPulseTimer?.cancel();
    _showErrors = true;
    _errorPulseCount = 0;
    _levelStartTime = clock.now();
    _solveAttempts = 0;
    unawaited(_progressService.clearSolution(_currentLevel.id));
    notifyListeners();
  }

  /// Last cell the player toggled and a monotonic counter so listeners
  /// can detect repeated taps on the same cell.
  GridPoint? get lastToggledPoint => _lastToggledPoint;
  int get toggleCount => _toggleCount;

  /// Toggles the specified cell, updating validation and notifying listeners.
  void toggleCell(GridPoint pt) {
    _puzzle = _puzzle.toggle(pt);
    _lastToggledPoint = pt;
    _toggleCount++;
    _lastValidation = null; // Clear previous validation attempt
    _errorPulseTimer?.cancel();
    _showErrors = true;
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
      _lastToggledPoint = pt;
      _toggleCount++;
      _dragActionLit = _puzzle.isLit(pt);
      _currentlyDraggedCells.add(pt);
      _lastValidation = null;
      _errorPulseTimer?.cancel();
      _showErrors = true;
      notifyListeners();
      return;
    }

    // For all passing cells, force them to match the active drag's action state
    final isCurrentlyLit = _puzzle.isLit(pt);
    if (isCurrentlyLit != _dragActionLit) {
      _puzzle = _puzzle.toggle(pt);
      _lastToggledPoint = pt;
      _toggleCount++;
      _lastValidation = null;
      _errorPulseTimer?.cancel();
      _showErrors = true;
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

    _errorPulseTimer?.cancel();
    _showErrors = true;
    _errorPulseCount = 0;

    if (!isValid) {
      // Flash errors on and off for 2 seconds (8 toggles at 250ms each)
      _errorPulseTimer = Timer.periodic(const Duration(milliseconds: 250), (
        timer,
      ) {
        _showErrors = !_showErrors;
        _errorPulseCount++;
        notifyListeners();

        if (_errorPulseCount >= 8) {
          timer.cancel();
          _showErrors = false;
          notifyListeners();
        }
      });
    }

    final timeMs = clock.now().difference(_levelStartTime).inMilliseconds;

    _analytics.logEvent(
      name: 'level_solve_attempt',
      parameters: {
        'level_id': _currentLevel.id,
        'is_correct': isValid ? 1 : 0,
        'attempt_number': _solveAttempts,
        'time_ms': timeMs,
      },
    );

    if (isValid) {
      _analytics.logEvent(
        name: 'level_complete',
        parameters: {
          'level_id': _currentLevel.id,
          'time_ms': timeMs,
          'attempt_number': _solveAttempts,
        },
      );
    }

    if (isValid) {
      // Mark this specific level as unlocked, and the NEXT level in the group
      unawaited(_progressService.saveLevelUnlocked(_currentLevel.id));
      if (_currentLevelIndexInGroup + 1 < _currentGroup.levels.length) {
        unawaited(
          _progressService.saveLevelUnlocked(
            _currentGroup.levels[_currentLevelIndexInGroup + 1].id,
          ),
        );
      }

      // Save their solution for this level
      unawaited(_progressService.saveSolution(_currentLevel.id, _puzzle.state));

      // Since they solved a level, it might have completed a group
      // and unlocked new groups
      _refreshUnlockedGroups();
    }
    notifyListeners();
  }

  String? get nextLevelId => hasNextLevel
      ? _currentGroup.levels[_currentLevelIndexInGroup + 1].id
      : null;

  /// Advances the game to the next available level puzzle
  /// within the current group.
  void nextLevel() {
    if (hasNextLevel) {
      _loadLevel(_currentGroupId, _currentLevelIndexInGroup + 1);
      unawaited(_progressService.saveLastLevelPlayed(_currentLevel.id));
      notifyListeners();
    }
  }

  String? get previousLevelId => hasPreviousLevel
      ? _currentGroup.levels[_currentLevelIndexInGroup - 1].id
      : null;

  /// Goes back to the previous level within the current group.
  void previousLevel() {
    if (hasPreviousLevel) {
      _loadLevel(_currentGroupId, _currentLevelIndexInGroup - 1);
      unawaited(_progressService.saveLastLevelPlayed(_currentLevel.id));
      notifyListeners();
    }
  }

  /// Jumps directly to a specific level group,
  /// to its first unsolved level or 0.
  void jumpToGroup(String groupId) {
    if (!LevelRepository.worldMap.containsKey(groupId)) return;

    final group = LevelRepository.worldMap[groupId]!;

    // Find the first level that is unlocked but not yet solved.
    // This correctly resumes progress without skipping levels that have
    // only been partially attempted (toggleCell saves partial state which
    // isLevelSolved would treat as "solved").
    var targetIndex = 0;
    for (var i = 0; i < group.levels.length; i++) {
      final level = group.levels[i];
      if (_progressService.isLevelUnlocked(level.id)) {
        targetIndex = i;
        // Check if this level was correctly solved (valid solution).
        final savedState = _progressService.getSolution(
          level.id,
          level.puzzle.width,
          level.puzzle.height,
        );
        if (savedState == null) break; // Never touched — start here.
        final validation = _validator.validate(
          level.puzzle.copyWith(state: savedState),
        );
        if (!validation.isValid) break; // Partial / wrong — resume here.
        // Otherwise this level is truly solved; continue to next.
      } else {
        // Not unlocked — can't go beyond here.
        break;
      }
    }

    _loadLevel(groupId, targetIndex);
    unawaited(_progressService.saveLastLevelPlayed(_currentLevel.id));
    notifyListeners();
  }

  /// Jumps directly to a level by index within the CURRENT group.
  /// Intended for debug/development use only.
  void jumpToLevel(int index) {
    if (index >= 0 && index < _currentGroup.levels.length) {
      _loadLevel(_currentGroupId, index);
      unawaited(_progressService.saveLastLevelPlayed(_currentLevel.id));
      notifyListeners();
    }
  }

  /// The index of the currently active level in the group.
  int get currentLevelIndex => _currentLevelIndexInGroup;

  /// Loads a level by its ID.
  void loadLevelById(String id) {
    if (_currentLevel.id == id) return;

    // Search all groups for this ID
    for (final groupId in LevelRepository.worldMap.keys) {
      final group = LevelRepository.worldMap[groupId]!;
      final index = group.levels.indexWhere((l) => l.id == id);

      if (index != -1) {
        // Found it.
        _loadLevel(groupId, index);
        unawaited(_progressService.saveLastLevelPlayed(_currentLevel.id));
        notifyListeners();
        return;
      }
    }
  }

  @override
  void dispose() {
    _errorPulseTimer?.cancel();
    super.dispose();
  }

  /// Loads a custom puzzle directly. Primarily for testing or debug.
  void loadCustomPuzzle(Puzzle puzzle, {String id = 'custom'}) {
    _currentLevel = Level(id: id, puzzle: puzzle);
    _puzzle = puzzle;
    _lastValidation = null;
    _levelStartTime = clock.now();
    _solveAttempts = 0;
    notifyListeners();
  }
}
