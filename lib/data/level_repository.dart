import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/puzzle.dart';

/// A hardcoded repository of levels to build the initial game progression.
class LevelRepository {
  /// The global legend used to parse puzzle ASCII strings.
  static final Map<String, CellState> legend = {
    // Empty playable cell
    '.': const CellState(),
    '·': const CellState(),
    '█': const CellState(isLit: true),

    // Diamonds
    'R': const CellState(cell: DiamondCell(CellColor.red)),
    'B': const CellState(cell: DiamondCell(CellColor.black)),
    'Y': const CellState(cell: DiamondCell(CellColor.yellow)),
    'U': const CellState(cell: DiamondCell(CellColor.blue)),

    // Numbers
    '1': const CellState(cell: NumberCell(1)),
    '2': const CellState(cell: NumberCell(2)),
    '3': const CellState(cell: NumberCell(3)),
    '4': const CellState(cell: NumberCell(4)),
    '5': const CellState(cell: NumberCell(5)),
    '6': const CellState(cell: NumberCell(6)),
    '7': const CellState(cell: NumberCell(7)),
    '8': const CellState(cell: NumberCell(8)),
    '9': const CellState(cell: NumberCell(9)),
  };

  /// Ordered list of levels for the main progression.
  /// https://steamcommunity.com/sharedfiles/filedetails/?id=2861109284
  static final List<Puzzle> levels = [
    Puzzle(
      id: 'shrine_1',
      initialGrid: GridState.fromAscii('''
        . .
        1 .
      ''', legend: legend),
      knownSolutions: const [
        '''
        . .
        1* .
        ''',
      ],
    ),
    Puzzle(
      id: 'shrine_2',
      initialGrid: GridState.fromAscii('''
        . 1
        1 .
      ''', legend: legend),
      knownSolutions: const [
        '''
        . 1*
        1* .
        ''',
      ],
    ),
    Puzzle(
      id: 'shrine_3',
      initialGrid: GridState.fromAscii('''
        . 1
        . 1
        1 .
        1 .
      ''', legend: legend),
      knownSolutions: const [
        '''
        . 1*
        . 1*
        1* .
        1 .*
        ''',
      ],
    ),
    Puzzle(
      id: 'shrine_4',
      initialGrid: GridState.fromAscii('''
        . 1
        1 .
        1 .
        . 1
      ''', legend: legend),
      knownSolutions: const [
        '''
        . 1*
        1* .
        1 .*
        .* 1
        ''',
      ],
    ),
    Puzzle(
      id: 'shrine_5',
      initialGrid: GridState.fromAscii('''
        (.) 1
         1  .
         1  .
        (.) 1
      ''', legend: legend),
      knownSolutions: const [
        '''
        (.) 1*
        1* .
        1* .
        (.) 1*
        ''',
      ],
    ),
    Puzzle(
      id: 'shrine_6',
      initialGrid: GridState.fromAscii('''
        (*1) .  . (1)
         .   1  .  .
         .   .  1  .
        (1)  .  .  1
      ''', legend: legend),
      knownSolutions: const [
        '''
        (1*) . .* (1)
        . 1* . .*
        .* . 1* .
        (1) .* . 1*
        ''',
      ],
    ),
    Puzzle(
      id: 'shrine_7',
      initialGrid: GridState.fromAscii('''
         .   .   1
         .   .   .
        (*1) .   .
         1   .   .
         .   .   1
         1   .   .
         .   1   1
      ''', legend: legend),
      knownSolutions: const [
        '''
        . . 1*
        . . .
        (1*) . .
        1 .* .
        .* . 1*
        1 .* .
        .* 1 1*
        ''',
      ],
    ),
    // TODO(bramp): level 8
    Puzzle(
      id: 'shrine_9',
      initialGrid: GridState.fromAscii('''
         .   .
         2   .
      ''', legend: legend),
      knownSolutions: const [
        '''
        . .
        2* .*
        ''',
      ],
    ),
    // TODO(bramp): level 10-16
    Puzzle(
      id: 'shrine_17',
      initialGrid: GridState.fromAscii('''
         U1
         Y1
      ''', legend: legend),
    ),
    Puzzle(
      id: 'shrine_18',
      initialGrid: GridState.fromAscii('''
         (U1) Y1
          Y1 (*Y1)
      ''', legend: legend),
    ),
    Puzzle(
      id: 'shrine_19',
      initialGrid: GridState.fromAscii('''
         Y1 Y1 U1 U1
         U1 Y1 U1 Y1
         U1 Y1 U1 Y1
         Y1 Y1 U1 U1
      ''', legend: legend),
    ),
    Puzzle(
      id: 'shrine_20',
      initialGrid: GridState.fromAscii('''
         .  .  .  .
         .  .  U1 Y1
         Y1 U1 .  .
         .  .  .  .
      ''', legend: legend),
    ),
    Puzzle(
      id: 'shrine_21',
      initialGrid: GridState.fromAscii('''
         .  .  U1  .
         .  .  U1 U1
         Y1 Y1 .  .
         .  Y1  .  .
      ''', legend: legend),
    ),
  ];
}
