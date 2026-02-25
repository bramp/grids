import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/grid_format.dart';

final gardenLevels = [
  Puzzle(
    id: 'garden_1',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_2',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_3',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_4',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_5',
    initialGrid: GridFormat.parse('''
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
  // TODO garden_6 though garden_11 are the same puzzles, but with different background colours. We should maybe drop them.
  Puzzle(
    id: 'garden_6',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_7',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_8',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_9',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_10',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_11',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_13',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_14',
    initialGrid: GridFormat.parse('''
        (*.) .  (*.)
         .  (*F3) .
        (*.) .  (*.)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * *
          . * *
          * * *
        '''),
    ],
  ),
  Puzzle(
    id: 'garden_15',
    initialGrid: GridFormat.parse('''
        . .  . .
        . (*F1) (F1) .
        . .  . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . * .
          * * . .
          . . * .
        '''),
    ],
  ),
  Puzzle(
    id: 'garden_16',
    initialGrid: GridFormat.parse('''
        (*F1) . . (*F1)
        . . . .
        . . . .
        (*F1) . . (*F1)
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
  Puzzle(
    id: 'garden_17',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_18',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_19',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_20',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_21',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_22',
    initialGrid: GridFormat.parse('''
        (F0) . .
        .   F2 .
        .   . (F2)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . *
          . * *
          * * *
        '''),
    ],
  ),

  Puzzle(
    id: 'garden_shortcut_1',
    initialGrid: GridFormat.parse('''
        Oo Wo Oo Wo Po
        Po  . Oo Wo Wo
        Po Wo Po Wo Oo
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . * . *
          * . * . .
          * . * . *
        '''),
    ],
  ),
  Puzzle(
    id: 'garden_shortcut_2',
    initialGrid: GridFormat.parse('''
        Co . . Co
        Co . . Co
        Co . . Co
        Co . . Co
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . .
          * * * *
          . * * .
          . * * .
        '''),
    ],
  ),
  Puzzle(
    id: 'garden_shortcut_3',
    initialGrid: GridFormat.parse('''
        (*Co) Yo   Yo   Yo  (*Co)
          .   (Yo)  .    Yo    .
          .   (Yo)  .    Yo    .
        (*Co) Yo   Yo   Yo  (*Co)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * * * *
          * . * . *
          * . * . *
          * * * * *
        '''),
    ],
  ),
  Puzzle(
    id: 'garden_shortcut_4',
    initialGrid: GridFormat.parse('''
        Co .  Co Yo
        Yo Co .  Yo
        Yo Yo .  .
        Yo Yo Yo Co
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * * *
          * * . *
          * * . .
          * * * *
        '''),
    ],
  ),

  Puzzle(
    id: 'garden_bonus_1',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_2',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_3',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_4',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_5',
    initialGrid: GridFormat.parse('''
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

  Puzzle(
    id: 'garden_bonus_6',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_7',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_8',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_9',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_10',
    initialGrid: GridFormat.parse('''
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

  Puzzle(
    id: 'garden_bonus_11',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_12',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_13',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_14',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_15',
    initialGrid: GridFormat.parse('''
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

  Puzzle(
    id: 'garden_bonus_16',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_17',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_18',
    initialGrid: GridFormat.parse('''
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
  Puzzle(
    id: 'garden_bonus_20',
    initialGrid: GridFormat.parse('''
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
];
