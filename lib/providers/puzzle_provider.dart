import 'package:flutter/foundation.dart';
import 'package:grids/data/level_repository.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/puzzle_validator.dart';
import 'package:grids/engine/rule_validator.dart';

/// The active puzzle grid that the user is interacting with.
class PuzzleProvider extends ChangeNotifier {
  PuzzleProvider() {
    _loadLevel(_currentLevelIndex);
  }
  final PuzzleValidator _validator = PuzzleValidator();

  int _currentLevelIndex = 0;
  int _maxUnlockedLevelIndex = 0;
  late Puzzle _currentPuzzle;
  late GridState _grid;

  // Track cells that have been flipped during the current drag event.
  final Set<GridPoint> _currentlyDraggedCells = {};

  // The state (lit or unlit) that the current drag operation is applying.
  bool? _dragActionLit;

  // Validation is only populated when the user explicitly taps "Check Answer"
  ValidationResult? _lastValidation;

  Puzzle get currentPuzzle => _currentPuzzle;
  GridState get grid => _grid;
  ValidationResult? get validation => _lastValidation;

  bool get isSolved => _lastValidation?.isValid ?? false;

  void _loadLevel(int index) {
    var loadIndex = index;
    if (loadIndex >= LevelRepository.levels.length) {
      // Loop back to start or handle "game complete" state
      loadIndex = 0;
    }

    _currentLevelIndex = loadIndex;
    _currentPuzzle = LevelRepository.levels[loadIndex];
    _grid = _currentPuzzle.initialGrid;
    _lastValidation = null;
  }

  bool get hasPreviousLevel => _currentLevelIndex > 0;
  bool get hasNextLevel =>
      _currentLevelIndex < LevelRepository.levels.length - 1 &&
      _currentLevelIndex < _maxUnlockedLevelIndex;

  /// Toggles the specified cell, updating validation and notifying listeners.
  void toggleCell(GridPoint pt) {
    _grid = _grid.toggle(pt);
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
      _grid = _grid.toggle(pt);
      _dragActionLit = _grid.isLit(pt);
      _currentlyDraggedCells.add(pt);
      _lastValidation = null;
      notifyListeners();
      return;
    }

    // For all passing cells, force them to match the active drag's action state
    final isCurrentlyLit = _grid.isLit(pt);
    if (isCurrentlyLit != _dragActionLit) {
      _grid = _grid.toggle(pt);
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
    _lastValidation = _validator.validate(_grid);
    if (_lastValidation?.isValid == true) {
      if (_currentLevelIndex >= _maxUnlockedLevelIndex) {
        _maxUnlockedLevelIndex = _currentLevelIndex + 1;
      }
    }
    notifyListeners();
  }

  /// Advances the game to the next available level puzzle.
  void nextLevel() {
    if (hasNextLevel) {
      _loadLevel(_currentLevelIndex + 1);
      notifyListeners();
    }
  }

  /// Goes back to the previous level.
  void previousLevel() {
    if (hasPreviousLevel) {
      _loadLevel(_currentLevelIndex - 1);
      notifyListeners();
    }
  }
}
