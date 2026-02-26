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
  // TODOgarden_6 though garden_11 are the same puzzles, but with different
  // background colours. We should maybe drop them.
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

  /*
  Level(
    id: 'garden_bonus_1',
    puzzle: GridFormat.parse('''
        P9 . . .
        . O/ . .
        . . Wo .
        . . . Wo
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * * *
          * . . *
          * . * .
          * * * *
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_2',
    puzzle: GridFormat.parse('''
        . P4 .
        . F4 .
        . F2 .
        . O4 .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          * * *
          . * .
          * * *
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_3',
    puzzle: GridFormat.parse('''
        . P/ .
        . F3 .
        . F3 .
        . O/ .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          . * *
          * * .
          . * .
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_4',
    puzzle: GridFormat.parse('''
        P9 .  .  F1
        .  .  F1 .
        .  F1 F0 .
        F1 .  .  F0
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . . *
          . * * .
          . * . *
          * . * .
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
          * . * .
        '''),
    ],
  ),

  Level(
    id: 'garden_bonus_6',
    puzzle: GridFormat.parse('''
        . . . P1
        P2 . (F3) .
        (F1) . . F2
        O/ . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . * .
          * . * *
          . * * *
          . * * .
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_7',
    puzzle: GridFormat.parse('''
        P4 .  .  F3 .
        .  .  P4 .  .
        .  .  F4 .  .
        F1 .  .  .  .
        .  F1 O6 .  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . * .
          . * * . *
          * * * * .
          * . . . .
          * * * . .
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_8',
    puzzle: GridFormat.parse('''
        Oo . Wo . (Oo)
        Oo . (Wo) . Oo
        Oo . Wo . Oo
        (Oo) . (Wo) . Oo
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . * . *
          * . * . *
          * . * . *
          * . * . *
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_9',
    puzzle: GridFormat.parse('''
        F1 .  .  F1
        Wo Wo Wo Wo
        Wo Wo Wo Wo
        F1 .  .  F1
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . *
          * * . .
          . . * *
          * . * *
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_10',
    puzzle: GridFormat.parse('''
        F3 .  .  .
        .  F3 .  .
        .  .  F3 .
        .  .  .  F3
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . .
          * * * .
          . * * *
          . . * *
        '''),
    ],
  ),

  Level(
    id: 'garden_bonus_11',
    puzzle: GridFormat.parse('''
        .  W  Oo W  .
        W  F0 Oo F0 W
        W  Oo .  Oo W
        W  Co F0 Co W
        Oo .  .  .  Oo
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * * * .
          * * * * *
          * * . * *
          * * * * *
          * . . . *
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_12',
    puzzle: GridFormat.parse('''
        Oo Oo Oo Oo
        Oo .  .  Oo
        Oo .  .  Oo
        Oo Oo Oo Oo
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * * .
          * . . *
          * . . *
          . * * .
        '''),
    ],
  ),
  Level(
    id: 'garden_bonus_13',
    puzzle: GridFormat.parse('''
        F1 .  F1
        .  F4 .
        F1 .  F1
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
    id: 'garden_bonus_14',
    puzzle: GridFormat.parse('''
        F1 F1 F1
        F1 F0 F1
        F1 F1 F1
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . *
          . * .
          * . *
        '''),
    ],
  ),
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
        Oo .  .  .  Oo F1
        .  .  .  .  F1 .
        .  .  .  F1 .  .
        .  .  F1 .  .  .
        .  F1 .  .  .  .
        F1 Oo .  .  .  Oo
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
        Oo .  .  F0 .  .
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
        .  (Po) .  .  (Oo) .
        .  .  .  F1 .  .
        .  .  F1 .  .  .
        .  (Po) .  .  (Oo) .
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
        (P-) .  O- .  .
        .    .  .  .  .
        O-   .  .  .  (P-)
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
