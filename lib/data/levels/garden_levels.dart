import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/level.dart';

final gardenLevels = [
  Level(
    id: 'garden_1',
    puzzle: GridFormat.parse('''
        x   .   x
        . (*F1) .
        x   .   x
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          x * x
          . * .
          x . x
        '''),
    ],
  ),
  Level(
    id: 'garden_2',
    puzzle: GridFormat.parse('''
        .   .   .
        . (*F2) .
        .   .   .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          . * .
          . * .
        '''),
    ],
  ),
  Level(
    id: 'garden_3',
    puzzle: GridFormat.parse('''
        . . .
        . (*F3) .
        . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          * * *
          . . .
        '''),
    ],
  ),
  Level(
    id: 'garden_4',
    puzzle: GridFormat.parse('''
        . . .
        . (*F4) .
        . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          * * *
          . * .
        '''),
    ],
  ),
  Level(
    id: 'garden_5',
    puzzle: GridFormat.parse('''
        . . .
        . (F0) .
        . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          * . *
          . * .
        '''),
    ],
  ),
  // TODO(bramp): garden_6 though garden_11 are the same puzzles, but with
  // different background colours. We should maybe drop them.
  Level(
    id: 'garden_6',
    puzzle: GridFormat.parse('''
        .   .   .
        . (*F3) .
        .   .   .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          * * .
          . * .
        '''),
    ],
  ),
  Level(
    id: 'garden_7',
    puzzle: GridFormat.parse('''
        .  .   .
        . (F3) .
        .  .   .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . .
          * . .
          . . .
        '''),
    ],
  ),
  Level(
    id: 'garden_8',
    puzzle: GridFormat.parse('''
        . . .
        . (*F1) .
        . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . .
          * * .
          . . .
        '''),
    ],
  ),
  Level(
    id: 'garden_9',
    puzzle: GridFormat.parse('''
        .   .   .
        . (*F1) .
        .   .   .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . .
          * * .
          . . .
        '''),
    ],
  ),
  Level(
    id: 'garden_10',
    puzzle: GridFormat.parse('''
        . . .
        . (*F2) .
        . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . .
          * * *
          . . .
        '''),
    ],
  ),
  Level(
    id: 'garden_11',
    puzzle: GridFormat.parse('''
        . . .
        . (*F4) .
        . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          * * *
          . * .
        '''),
    ],
  ),
  // Skipped garden_12 as it's a more complex puzzle
  Level(
    id: 'garden_13',
    puzzle: GridFormat.parse('''
        . . .
        . F1 .
        . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          . * .
          . . .
        '''),
    ],
  ),
  Level(
    id: 'garden_14',
    puzzle: GridFormat.parse('''
        (*.) .  (*.)
         .  (F1) .
        (*.) .  (*.)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * *
          . . *
          * * *
        '''),
    ],
  ),
  Level(
    id: 'garden_15',
    puzzle: GridFormat.parse('''
        .   .    .   .
        . (*F1) (F1) .
        .   .    .   .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . * .
          * * . .
          . . * .
        '''),
    ],
  ),
  Level(
    id: 'garden_16',
    puzzle: GridFormat.parse('''
        (*F1) .  . (*F1)
          .   .  .   .
          .   .  .   .
        (*F1) .  . (*F1)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . *
          . . . *
          * . . .
          * . * *
        '''),
    ],
  ),
  Level(
    id: 'garden_17',
    puzzle: GridFormat.parse('''
        (*F1) . . (F1)
        . . . .
        . . . .
        (F1) . . (*F1)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . .
          . . . *
          * . . .
          . . * *
        '''),
    ],
  ),
  Level(
    id: 'garden_18',
    puzzle: GridFormat.parse('''
        . F1 .
        F1 . F1
        . F1 .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          * * *
          . * .
        '''),
    ],
  ),
  Level(
    id: 'garden_19',
    puzzle: GridFormat.parse('''
        . (*F1) .
        (*F2) . (*F1)
        . (*F2) .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          * * *
          * * .
        '''),
    ],
  ),
  Level(
    id: 'garden_20',
    puzzle: GridFormat.parse('''
        (*F1) .  .
        F3   .  F3
        .    .  (*F1)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . *
          * * *
          * . *
        '''),
    ],
  ),
  Level(
    id: 'garden_21',
    puzzle: GridFormat.parse('''
        F0 . .
        .  . .
        .  . F0
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . .
          . . .
          . . *
        '''),
    ],
  ),
  Level(
    id: 'garden_22',
    puzzle: GridFormat.parse('''
        F0  .  .
        .  F2  .
        .   .  F0
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          * . .
          . . *
        '''),
    ],
  ),

  // TODODo Garden 24 - 29 walking puzzles
  Level(
    id: 'garden_shortcut_1',
    puzzle: GridFormat.parse('''
        F0 F0 F0 F0
        F0 F0 F0 F0
        F0 F0 F0 F0
        F0 F0 F0 F0
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * . *
          * . * .
          . * . *
          * . * .
        '''),
    ],
  ),
  Level(
    id: 'garden_shortcut_2',
    puzzle: GridFormat.parse('''
        F1 F1 F1 F1
        F1 F1 F1 F1
        F1 F1 F1 F1
        F1 F1 F1 F1
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . .
          . . * *
          * * . .
          . . * *
        '''),
    ],
  ),
  Level(
    id: 'garden_shortcut_3',
    puzzle: GridFormat.parse('''
        F2 F2 F2 F2
        F2 F2 F2 F2
        F2 F2 F2 F2
        F2 F2 F2 F2
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . .
          * * . .
          . . * *
          . . * *
        '''),
    ],
  ),
  Level(
    id: 'garden_shortcut_4',
    puzzle: GridFormat.parse('''
        .  .  F3  .   .  .
        F1 F0 (*) .   F4 F1
        F2 .  .   F1  .  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * * * * .
          * . * * * *
          * * . . * .
        '''),
    ],
  ),

  Level(
    id: 'garden_bonus_1',
    puzzle: GridFormat.parse('''
        P9 . . .
        . Y3 . .
        . . W1 .
        . . . W1
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * * *
          * . . *
          * . * .
          * * . *
        '''),
    ],
  ),

  Level(
    id: 'garden_bonus_2',
    puzzle: GridFormat.parse('''
        . P4 .
        . F3 .
        . F3 .
        . Y4 .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          * * *
          . . .
          * . *
        '''),
    ],
  ),

  Level(
    id: 'garden_bonus_3',
    puzzle: GridFormat.parse('''
        . P3 .
        . F3 .
        . F3 .
        . Y3 .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . .
          * * *
          * * *
          . . .
        '''),
    ],
  ),

  Level(
    id: 'garden_bonus_4',
    puzzle: GridFormat.parse('''
        P9 .  .  F2
        .  .  F1 .
        .  F1 F0 .
        F2 .  .  F0
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . .
          . * * .
          . * . *
          . . * .
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_5',
    puzzle: GridFormat.parse('''
        .  .  .  P8
        .  .  F2 .
        .  F2 .  .
        F2 .  .  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . .
          * * . .
          . . * .
          . . * .
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_6',
    puzzle: GridFormat.parse('''
        .    .   .   P1
        P2   . (F1)  .
        (F1) .   .   F2
        Y3   .   .   .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . * .
          * . . *
          . * * *
          . . * .
        '''),
    ],
  ),

  Level(
    id: 'garden_bonus_7',
    puzzle: GridFormat.parse('''
        P4 .  .  F3 .
        .  .  P4 .  .
        .  .  F4 .  .
        F2 .  .  .  .
        .  F1 Y6 .  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . . .
          . * * . *
          . * * * .
          . . * . .
          * * . . .
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_8',
    puzzle: GridFormat.parse('''
         Y  .  W   . (Y)
         Y  . (*W) .  Y
         Y  .  W   .  Y
        (Y) . (*W) .  Y
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . . . .
          * * * . .
          . * . . *
          . * * . *
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_9',
    puzzle: GridFormat.parse('''
        F1 .  .  F1
        W  W  W  W
        W  W  W  W
        F1 .  .  F1
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * . *
          . . * *
          * * . .
          . . * .
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_10',
    puzzle: GridFormat.parse('''
        .  .  .  B
        .  F1 W  .
        .  B  F1 .
        W  .  .  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . *
          . * . *
          . * . *
          . * * *
        '''),
    ],
  ),

  Level(
    id: 'garden_bonus_11',
    puzzle: GridFormat.parse('''
        .  .  Y . .
        .  F0 Y F0 .
        .  Y .  Y  .
        .  C F0 C  .
        Y .  .  .  Y
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * * * .
          * . * . *
          * * . * *
          * . * . *
          * . . . *
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_12',
    note:
        'The first puzzle where we learn a yellow diamond can connect '
        'to a yellow flower',
    puzzle: GridFormat.parse('''
        Y  .  Y  .
        .  F4 .  Y
        Y  .  .  Y
        .  Y  Y  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . .
          * * * .
          . * . *
          . . * *
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_13',
    puzzle: GridFormat.parse('''
        .  .  .  P
        . F0  P  .
        . P  F0  P
        P .   P  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . . .
          . * . *
          . . * .
          . * . .
        '''),
    ],
  ),

  Level(
    id: 'garden_bonus_14',
    puzzle: GridFormat.parse('''
        Y  .   F0 . . (*Y)
        . (*Y) . . . F0
        F0 .   Y . . .
        .  .   . Y . .
        .  .   . . (F4) .
        (Y)  .   F0 . . Y
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . * * *
          * * * . * .
          . * . * * *
          * . . * . *
          . . * . . .
          . * . * . .
        '''),
    ],
  ),
  /*
  Level(
    id: 'garden_bonus_15',
    puzzle: GridFormat.parse('''
        F1 F2 F1
        F2 F4 F2
        F1 F2 F1
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * *
          * * *
          * * *
        '''),
    ],
  ),

  Level(
    id: 'garden_bonus_16',
    puzzle: GridFormat.parse('''
        Yo .  .  .  Yo F1
        .  .  .  .  F1 .
        .  .  .  F1 .  .
        .  .  F1 .  .  .
        .  F1 .  .  .  .
        F1 Yo .  .  .  Yo
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * * . * *
          * . * . * *
          * . * * . *
          * . * * . *
          * * . * . *
          * * . * * *
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_17',
    puzzle: GridFormat.parse('''
        .  .  .  .  .  .
        .  .  .  Po .  .
        Yo .  .  F0 .  .
        .  .  F4 .  .  .
        .  F4 .  .  .  .
        .  .  .  F1 .  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * * * * *
          * * * * * *
          * . * . * *
          * * * * * *
          * * * * * *
          * * * * * *
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_18',
    puzzle: GridFormat.parse('''
        Wo .  .  .  .  Ko
        .  (Po) .  .  (Yo) .
        .  .  .  F1 .  .
        .  .  F1 .  .  .
        .  (Po) .  .  (Yo) .
        Ko .  .  .  .  Wo
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * * * * .
          * * * * * *
          * * * * * *
          * * * * * *
          * * * * * *
          . * * * * .
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_20',
    puzzle: GridFormat.parse('''
        (P-) .  Y- .  .
        .    .  .  .  .
        Y-   .  .  .  (P-)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . * * .
          . . . . *
          * * . * *
        '''),
    ],
  ),
  */
];
