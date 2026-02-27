import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/puzzle.dart';

/// Utility class for parsing and printing puzzles using ASCII representations.
class GridFormat {
  /// Parses an ASCII lit/unlit mask into a GridState.
  /// Characters containing `*` are considered lit.
  static GridState parseMask(String ascii) {
    return parse(ascii).state;
  }

  /// Parses an ASCII grid representation into a Puzzle.
  ///
  /// The format supports modifiers:
  /// - `*` (Asterisk): Indicates the cell starts as "lit" (pre-lit). Can be
  ///   placed before or after the symbol (e.g., `*R` or `R*`).
  /// - `( )` (Parentheses): Indicates the cell is "locked" (static). Locked
  ///   cells cannot be toggled by the user during play.
  /// - `R, K, Y, B, P, W, C`: Color prefixes for mechanics (e.g., `Ro` for
  ///   a Red Diamond, `B1` for a Blue 1).
  ///
  /// Standard mechanic symbols:
  /// - `o`: Diamond mechanic.
  /// - `1-9`: Number mechanic.
  /// - `.` or `·`: Blank cell.
  ///
  /// Legacy support:
  /// - A lone color prefix (e.g., `R`) is treated as a Diamond of that color.
  static Puzzle parse(
    String ascii, {
    CellColor defaultColor = CellColor.black,
  }) {
    final rows = ascii
        .trim()
        .split('\n')
        .map((r) => r.trim())
        .where((r) => r.isNotEmpty)
        .toList();
    assert(rows.isNotEmpty, 'ASCII grid cannot be empty');

    final tokenRegex = RegExp(r'\([^)]*\)|\S+');

    final parsedRows = rows.map((row) {
      return tokenRegex
          .allMatches(row)
          .map((m) => m.group(0)!)
          .where((token) => token.isNotEmpty)
          .toList();
    }).toList();

    final height = parsedRows.length;
    final width = parsedRows[0].length;

    final mechanics = List<Cell>.filled(width * height, const BlankCell());
    var bits = BigInt.zero;

    try {
      for (var y = 0; y < height; y++) {
        if (parsedRows[y].length != width) {
          throw ArgumentError(
            'ASCII grid must have uniform row widths. '
            'Row 0 has width $width, but row $y has width '
            '${parsedRows[y].length}.',
          );
        }
        for (var x = 0; x < width; x++) {
          final token = parsedRows[y][x];
          try {
            var subToken = token;

            // Strip ANSI escape codes
            subToken = subToken.replaceAll(RegExp(r'\x1B\[[0-9;]*[mK]'), '');

            var isLocked = false;
            var isLit = false;
            CellColor? color;

            const colorPrefixes = {
              'R': CellColor.red,
              'K': CellColor.black,
              'Y': CellColor.yellow,
              'B': CellColor.blue,
              'P': CellColor.purple,
              'W': CellColor.white,
              'C': CellColor.cyan,
              'O': CellColor.orange,
              'G': CellColor.green,
            };

            // Recursive modifier stripping
            while (true) {
              if (subToken.startsWith('(') && subToken.endsWith(')')) {
                isLocked = true;
                subToken = subToken.substring(1, subToken.length - 1).trim();
                continue;
              }
              if (subToken.startsWith('*')) {
                isLit = true;
                subToken = subToken.substring(1).trim();
                continue;
              }
              if (subToken.endsWith('*')) {
                isLit = true;
                subToken = subToken.substring(0, subToken.length - 1).trim();
                continue;
              }

              var foundColor = false;
              if (subToken.isNotEmpty) {
                for (final prefix in colorPrefixes.keys) {
                  if (subToken.startsWith(prefix)) {
                    color = colorPrefixes[prefix];
                    subToken = subToken.substring(1).trim();
                    foundColor = true;
                    break;
                  }
                }
              }
              if (foundColor) continue;
              break;
            }

            Cell cell;
            if (subToken == 'o') {
              cell = DiamondCell(color ?? defaultColor);
            } else if (subToken == '-') {
              cell = DashCell(color ?? defaultColor);
            } else if (subToken == '/') {
              cell = DiagonalDashCell(color ?? defaultColor);
            } else if (subToken.startsWith('F') &&
                subToken.length == 2 &&
                int.tryParse(subToken[1]) != null) {
              final n = int.parse(subToken[1]);
              if (n < 0 || n > 4) {
                throw ArgumentError(
                  "FlowerCell petals must be 0-4. Got: '$subToken'",
                );
              }
              cell = FlowerCell(n);
            } else if (int.tryParse(subToken) != null) {
              final n = int.parse(subToken);
              if (n == 0) {
                throw ArgumentError(
                  "Number cell value '0' is not allowed in ASCII grid.",
                );
              }
              cell = NumberCell(n, color: color ?? defaultColor);
            } else if (subToken == '.' || subToken == '·') {
              cell = const BlankCell();
            } else if (subToken == ' ' || subToken == 'x') {
              cell = const VoidCell();
            } else if (subToken.isEmpty) {
              if (color != null) {
                cell = DiamondCell(color);
              } else {
                cell = const BlankCell();
              }
            } else {
              throw ArgumentError(
                "Unknown symbol '$subToken' in ASCII grid.",
              );
            }

            if (isLocked) {
              cell = cell.lock(isLit: isLit);
            }

            final index = y * width + x;
            mechanics[index] = cell;
            if (isLit) {
              bits |= BigInt.one << index;
            }
          } catch (e) {
            throw ArgumentError(
              'Error parsing ASCII grid at row $y, col $x '
              "(token: '$token'):\n$e",
            );
          }
        }
      }
    } catch (e) {
      throw ArgumentError('$e\n\nFull grid:\n$ascii');
    }

    return Puzzle(
      grid: Grid(width: width, height: height, mechanics: mechanics),
      state: GridState(width: width, height: height, bits: bits),
    );
  }

  /// Returns a beautiful debug ASCII representation of the grid.
  static String toAsciiString(
    Puzzle puzzle, {
    bool useColor = false,
    Set<GridPoint> errors = const {},
  }) {
    final tokens = List.generate(
      puzzle.width,
      (_) => List<String>.filled(puzzle.height, ''),
    );

    for (var y = 0; y < puzzle.height; y++) {
      for (var x = 0; x < puzzle.width; x++) {
        final index = y * puzzle.width + x;
        final cell = puzzle.mechanics[index];
        final isLit = puzzle.isLit(GridPoint(index));

        var token = switch (cell) {
          NumberCell() => '${_getSymbolColor(cell.color) ?? ''}${cell.number}',
          DiamondCell() => '${_getSymbolColor(cell.color) ?? ''}o',
          FlowerCell() => 'F${cell.orangePetals}',
          DashCell() => '${_getSymbolColor(cell.color) ?? ''}-',
          DiagonalDashCell() => '${_getSymbolColor(cell.color) ?? ''}/',
          VoidCell() => 'x',
          BlankCell() => '.',
        };

        if (isLit) token = '$token*';
        if (cell.isLocked) token = '($token)';

        tokens[x][y] = token;
      }
    }

    var maxWidth = 0;
    for (var x = 0; x < puzzle.width; x++) {
      for (var y = 0; y < puzzle.height; y++) {
        if (tokens[x][y].length > maxWidth) maxWidth = tokens[x][y].length;
      }
    }

    final buffer = StringBuffer();
    for (var y = 0; y < puzzle.height; y++) {
      for (var x = 0; x < puzzle.width; x++) {
        final token = tokens[x][y];
        final leftPadding = (maxWidth - token.length) ~/ 2;
        final rightPadding = maxWidth - token.length - leftPadding;
        final alignedToken = ' ' * leftPadding + token + ' ' * rightPadding;

        if (useColor) {
          final index = y * puzzle.width + x;
          final cell = puzzle.mechanics[index];
          final pt = GridPoint(index);
          final isLit = puzzle.isLit(pt);
          final hasError = errors.contains(pt);
          final fg = _getAnsiForeground(cell);
          final bg = hasError
              ? '\x1B[41m' // Red background for errors
              : (isLit ? '\x1B[48;5;18m' : '\x1B[40m');
          buffer.write('$bg$fg$alignedToken\x1B[0m ');
        } else {
          final isError = errors.contains(GridPoint(y * puzzle.width + x));
          if (isError) {
            final trimmed = token; // use original unpadded token
            final leftSpace = leftPadding > 0 ? leftPadding - 1 : 0;
            final rightSpace = rightPadding > 0 ? rightPadding - 1 : 0;

            final prefix = leftPadding > 0 ? '${' ' * leftSpace}[' : '[';
            final postfix = rightPadding > 0 ? ']${' ' * rightSpace}' : ']';

            buffer.write('$prefix$trimmed$postfix ');
          } else {
            buffer.write('$alignedToken ');
          }
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String? _getSymbolColor(CellColor? color) {
    if (color == null || color == CellColor.black) return null;
    return switch (color) {
      CellColor.red => 'R',
      CellColor.black => 'K',
      CellColor.blue => 'B',
      CellColor.yellow => 'Y',
      CellColor.purple => 'P',
      CellColor.white => 'W',
      CellColor.cyan => 'C',
      CellColor.orange => 'O',
      CellColor.green => 'G',
    };
  }

  static String _getAnsiForeground(Cell cell) {
    final color = switch (cell) {
      DiamondCell() => cell.color,
      DashCell() => cell.color,
      DiagonalDashCell() => cell.color,
      NumberCell() => cell.color,
      FlowerCell() => null, // Handled separately
      BlankCell() => null,
      VoidCell() => null,
    };

    if (cell is FlowerCell) {
      // Flowers are represented with orange petals
      return '\x1B[38;5;214m'; // approximate ANSI orange
    }

    if (color != null) {
      return switch (color) {
        CellColor.red => '\x1B[38;5;196m',
        CellColor.black => '\x1B[38;5;232m',
        CellColor.blue => '\x1B[38;5;33m',
        CellColor.yellow => '\x1B[38;5;220m',
        CellColor.purple => '\x1B[38;5;129m',
        CellColor.white => '\x1B[38;5;255m',
        CellColor.cyan => '\x1B[38;5;51m',
        CellColor.orange => '\x1B[38;5;214m',
        CellColor.green => '\x1B[38;5;46m',
      };
    }
    return '\x1B[37m';
  }

  /// Returns a plain mask string suitable for pasting into [parseMask].
  ///
  /// Each lit cell is represented as `*` and each unlit cell as `.`.
  static String toMaskString(GridState grid, {bool useColor = false}) {
    const reset = '\x1B[0m';
    const litColor = '\x1B[32m'; // green
    const unlitColor = '\x1B[90m'; // dark gray
    final buffer = StringBuffer();
    for (var y = 0; y < grid.height; y++) {
      buffer.write('          ');
      for (var x = 0; x < grid.width; x++) {
        final pt = GridPoint(y * grid.width + x);
        final lit = grid.isLit(pt);
        if (useColor) buffer.write(lit ? litColor : unlitColor);
        buffer.write(lit ? '*' : '.');
        if (useColor) buffer.write(reset);
        if (x < grid.width - 1) buffer.write(' ');
      }
      if (y < grid.height - 1) buffer.writeln();
    }
    return buffer.toString();
  }
}
