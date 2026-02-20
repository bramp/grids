import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';

/// Represents the exhaustive state of a single cell on the grid.
@immutable
class CellState {
  const CellState({this.isLit = false, this.cell = const BlankCell()});
  final bool isLit;
  final Cell cell;

  CellState copyWith({bool? isLit, Cell? cell}) {
    return CellState(
      isLit: isLit ?? this.isLit,
      cell: cell ?? this.cell,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CellState &&
          runtimeType == other.runtimeType &&
          isLit == other.isLit &&
          cell == other.cell;

  @override
  int get hashCode => isLit.hashCode ^ cell.hashCode;

  @override
  String toString() => 'CellState(isLit: $isLit, cell: $cell)';
}

/// Represents the immutable state of the puzzle grid using a 2D Array format
/// for strong bounds and type safety.
@immutable
class GridState {
  const GridState._(this.width, this.height, this.cells);

  /// Creates a completely blank grid of the specified dimensions.
  factory GridState.empty({required int width, required int height}) {
    final cells = List.generate(
      width,
      (x) => List.generate(height, (y) => const CellState(), growable: false),
      growable: false,
    );
    return GridState._(width, height, cells);
  }

  /// Creates a grid from a pre-built 2D array of cells.
  factory GridState.fromCells(List<List<CellState>> cells) {
    assert(cells.isNotEmpty, 'Grid must have at least width 1');
    assert(cells[0].isNotEmpty, 'Grid must have at least height 1');

    final width = cells.length;
    final height = cells[0].length;

    // Ensure all columns are matching height for safety
    for (final col in cells) {
      assert(col.length == height, 'Grid columns must be uniform height');
    }

    return GridState._(width, height, cells);
  }

  /// Parses an ASCII grid representation into a GridState using a mapping
  /// legend.
  ///
  /// Example:
  /// ```dart
  /// final grid = GridState.fromAscii('''
  ///   R . .
  ///   . R .
  ///   . . .
  /// ''', legend: {
  ///   'R': const CellState(isLit: false, cell: DiamondCell(CellColor.red)),
  ///   '.': const CellState(isLit: false),
  /// });
  /// ```
  factory GridState.fromAscii(
    String ascii, {
    required Map<String, CellState> legend,
  }) {
    final rows = ascii
        .trim()
        .split('\n')
        .map((r) => r.trim())
        .where((r) => r.isNotEmpty)
        .toList();
    assert(rows.isNotEmpty, 'ASCII grid cannot be empty');

    // We expect cells to be separated by spaces in the string for readability.
    final parsedRows = rows.map((row) {
      return row
          .split(RegExp(r'\s+'))
          .where((char) => char.isNotEmpty)
          .toList();
    }).toList();

    final height = parsedRows.length;
    final width = parsedRows[0].length;

    for (final r in parsedRows) {
      assert(r.length == width, 'ASCII grid must have uniform row widths');
    }

    // GridState stores by columns: cells[x][y]
    final cells = List.generate(
      width,
      (x) => List.generate(height, (y) {
        var token = parsedRows[y][x];
        var isLocked = false;
        var isLit = false;

        // Recursive symbolic parsing (e.g., "(1*)" -> Locked + Lit + "1")
        while (true) {
          if (token.startsWith('(') && token.endsWith(')')) {
            isLocked = true;
            token = token.substring(1, token.length - 1).trim();
            continue;
          }
          if (token.startsWith('*')) {
            isLit = true;
            token = token.substring(1).trim();
            continue;
          }
          if (token.endsWith('*')) {
            isLit = true;
            token = token.substring(0, token.length - 1).trim();
            continue;
          }
          break;
        }

        final base = legend[token];
        if (base == null) {
          throw ArgumentError(
            "Symbol '$token' (parsed from '${parsedRows[y][x]}') "
            'not found in legend.',
          );
        }

        var result = base;
        if (isLocked) {
          result = result.copyWith(cell: result.cell.lock());
        }
        if (isLit) {
          result = result.copyWith(isLit: true);
        }
        return result;
      }, growable: false),
      growable: false,
    );

    return GridState._(width, height, cells);
  }
  final int width;
  final int height;

  /// 2D array of cells. Stored as List of Columns (`List<List<CellState>>`).
  /// Accessed as `cells[x][y]`.
  final List<List<CellState>> cells;

  /// True if the grid cell at the given point is lit, false otherwise.
  /// If the point is out of bounds, returns false.
  bool isLit(GridPoint pt) {
    if (!isValid(pt)) return false;
    return cells[pt.x][pt.y].isLit;
  }

  /// Returns the cell at the given point, or a BlankCell if OOB.
  Cell getMechanic(GridPoint pt) {
    if (!isValid(pt)) return const BlankCell();
    return cells[pt.x][pt.y].cell;
  }

  /// Returns true if the cell at the given point is locked and cannot be
  /// toggled by the user.
  bool isLocked(GridPoint pt) {
    if (!isValid(pt)) return false;
    return cells[pt.x][pt.y].cell.isLocked;
  }

  /// Checks if the provided point is strictly within the bounds.
  bool isValid(GridPoint pt) {
    return pt.x >= 0 && pt.x < width && pt.y >= 0 && pt.y < height;
  }

  /// Returns a new GridState with the given point toggled.
  /// If the cell is locked, returns the current state unchanged.
  GridState toggle(GridPoint pt) {
    if (!isValid(pt) || isLocked(pt)) return this;

    final newCells = List.generate(
      width,
      (x) => List.generate(height, (y) {
        if (x == pt.x && y == pt.y) {
          return cells[x][y].copyWith(isLit: !cells[x][y].isLit);
        }
        return cells[x][y];
      }, growable: false),
      growable: false,
    );

    return GridState._(width, height, newCells);
  }

  /// Helper method for tests/setup to place a cell immutably.
  GridState withMechanic(GridPoint pt, Cell cell) {
    if (!isValid(pt)) return this;

    final newCells = List.generate(
      width,
      (x) => List.generate(height, (y) {
        if (x == pt.x && y == pt.y) {
          return cells[x][y].copyWith(cell: cell);
        }
        return cells[x][y];
      }, growable: false),
      growable: false,
    );

    return GridState._(width, height, newCells);
  }

  /// Extracts all contiguous areas of cells that share the exact same 'lit'
  /// state.
  /// Uses a standard flood-fill traversal algorithm.
  List<Set<GridPoint>> extractContiguousAreas() {
    final visited = <GridPoint>{};
    final areas = <Set<GridPoint>>[];

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final startPt = GridPoint(x, y);
        if (visited.contains(startPt)) continue;

        final targetLitState = isLit(startPt);
        final currentArea = <GridPoint>{};
        final queue = [startPt];
        visited.add(startPt);

        while (queue.isNotEmpty) {
          final pt = queue.removeAt(0);
          currentArea.add(pt);

          // Check orthogonal neighbors (up, down, left, right)
          final neighbors = [
            GridPoint(pt.x, pt.y - 1),
            GridPoint(pt.x, pt.y + 1),
            GridPoint(pt.x - 1, pt.y),
            GridPoint(pt.x + 1, pt.y),
          ];

          for (final n in neighbors) {
            if (isValid(n) &&
                !visited.contains(n) &&
                isLit(n) == targetLitState) {
              visited.add(n);
              queue.add(n);
            }
          }
        }
        areas.add(currentArea);
      }
    }
    return areas;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridState &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          const DeepCollectionEquality().equals(cells, other.cells);

  @override
  int get hashCode =>
      width.hashCode ^
      height.hashCode ^
      const DeepCollectionEquality().hash(cells);

  /// Returns a beautiful debug ASCII representation of the grid.
  String toAsciiString() {
    final buffer = StringBuffer();
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final cellState = cells[x][y];
        final cell = cellState.cell;

        var symbol = cellState.isLit ? '█' : '·';

        // Output cell overrides
        if (cell is NumberCell) {
          symbol = '${cell.number}';
        } else if (cell is DiamondCell) {
          symbol = cell.color == CellColor.red ? 'R' : 'B';
        }

        buffer
          ..write(symbol)
          ..write(' ');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }
}
