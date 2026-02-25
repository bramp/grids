import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/grid_format.dart';

final mineLevels = [
  Puzzle(
    id: 'mine_1',
    note: 'Learn that diamonds need to be connected',
    initialGrid: GridFormat.parse('''
        o
        o
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          *
          *
        '''),
    ],
  ),
  Puzzle(
    id: 'mine_2',
    initialGrid: GridFormat.parse('''
        o
        .
        .
        o
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          *
          *
          *
          *
        '''),
    ],
  ),
  Puzzle(
    id: 'mine_3',
    initialGrid: GridFormat.parse('''
        . . o
        . . .
        o . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . *
          . . *
          * * *
        '''),
    ],
  ),
  Puzzle(
    id: 'mine_4',
    initialGrid: GridFormat.parse('''
        () . o
        . () .
        o . ()
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . .
          . . .
          . . .
        '''),
    ],
  ),
  Puzzle(
    id: 'mine_5',
    initialGrid: GridFormat.parse('''
        o o
        o o
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * *
          . .
        '''),
    ],
  ),
  Puzzle(
    id: 'mine_6',
    initialGrid: GridFormat.parse('''
        (*o) .  o
          .  .  .
          o  . (*o)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . *
          * . *
          * . *
        '''),
    ],
  ),

  Puzzle(
    id: 'mine_7',
    initialGrid: GridFormat.parse('''
         .  (o)  .
         o   .   o
         .  (o)  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . .
          . * .
          . . *
        '''),
    ],
  ),

  Puzzle(
    id: 'mine_8',
    initialGrid: GridFormat.parse('''
        o o
        o o
        o o
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . .
          * *
          . .
        '''),
    ],
  ),
  Puzzle(
    id: 'mine_9',
    initialGrid: GridFormat.parse('''
        o o o .
        . . . .
        . o o o
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . * .
          . * * .
          . * . .
        '''),
    ],
  ),
  Puzzle(
    id: 'mine_10',
    initialGrid: GridFormat.parse('''
        (o)  .  o  o
         .   .  .  .
         .   .  .  .
        (*o) .  o (*o)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . *
          * * * *
          * * . .
          * . * *
        '''),
    ],
  ),
  Puzzle(
    id: 'mine_11',
    initialGrid: GridFormat.parse('''
        o o o o
        o o o o
        o o o o
        o o o o
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . * *
          * * . .
          . . * *
          * * . .
        '''),
    ],
  ),
  Puzzle(
    id: 'mine_12',
    initialGrid: GridFormat.parse('''
        . o o o
        . o . o
        o . o o
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . * *
          . * . .
          . * * .
        '''),
    ],
  ),
  // TODO(bramp): mine_13 is a walking puzzle
  Puzzle(
    id: 'mine_13',
    initialGrid: GridFormat.parse('''
        o . o
        . . .
        o . o
        o . o
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . .
          . . .
          * . *
          * . *
        '''),
    ],
  ),

  Puzzle(
    id: 'mine_14',
    note: 'Introduction to multiple colours',
    initialGrid: GridFormat.parse('''
          Bo   Yo    Ko
          .    .     .
        (*Bo) (Yo) (*Ko)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . *
          * . *
          * . *
        '''),
    ],
  ),

  Puzzle(
    id: 'mine_15',
    note: 'Introduction to colours can mix',
    initialGrid: GridFormat.parse('''
         Yo   .   Bo
          .   .   .
        (*Bo) .   Yo
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . *
          * . *
          * * *
        '''),
    ],
  ),

  Puzzle(
    id: 'mine_16',
    initialGrid: GridFormat.parse('''
        Yo  Bo  Yo
        Bo  Yo  Yo
        Yo  Yo  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . *
          . . *
          * * .
        '''),
    ],
  ),

  Puzzle(
    id: 'mine_17',
    initialGrid: GridFormat.parse('''
        Bo  Yo  .
        Bo  Yo  Yo
        Yo  Yo  Yo
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . *
          . * .
          . * .
        '''),
    ],
  ),

  Puzzle(
    id: 'mine_18',
    initialGrid: GridFormat.parse('''
        Ko  Yo  Bo
        .   Yo  Yo
        Bo  Yo  Ko
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
    id: 'mine_19',
    initialGrid: GridFormat.parse('''
        Ko  Yo . (*Ko)
        Yo . . .
        . . . Yo
        (*Ko) . Yo Ko
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . *
          * . . *
          * . . *
          * . * *
        '''),
    ],
  ),

  Puzzle(
    id: 'mine_20',
    initialGrid: GridFormat.parse('''
        Ko  Yo  Yo  Ko
        Yo  .   .   Yo
        Yo  .   .   Yo
        Ko  Yo  Yo  Ko
      '''),
  ),

  Puzzle(
    id: 'mine_21',
    initialGrid: GridFormat.parse('''
        Ko  Yo  Yo  .
        Yo  .   .   Yo
        Yo  .   .   Yo
        .   Yo  Yo  Ko
      '''),
  ),

  Puzzle(
    id: 'mine_22',
    initialGrid: GridFormat.parse('''
        .     Wo    .     Wo    (*Bo)
        Wo    ()    .     (Yo)  Wo
        .     .     Yo    Ko    .
        Wo    (Yo)  Ko    Yo    .
        Bo    Wo    ()    .     .
      '''),
  ),

  Puzzle(
    id: 'mine_23',
    initialGrid: GridFormat.parse('''
        .     .     Bo    (Ko) (Yo)
        .     Yo    .     .     (*Wo)
        .     Ko    .     Ko    .
        (*Wo) .     .     Yo    .
        (Ko) (Yo) Bo    .     .
      '''),
  ),

  // Skipped mine_24 / mine_25 are simple walking puzzles
  // TODO(bramp): mine_26 is a walking puzzle
  // TODO(bramp): mine_27 is a walking puzzle
  // TODO(bramp): mine_28 is a walking puzzle
  // Skipped mine_29 / mine_30 are simple walking puzzles
  Puzzle(
    id: 'mine_31',
    initialGrid: GridFormat.parse('''
        Yo (*)    Yo   (*Yo)
        Yo   (*Yo) .    .
        .    .    .    .
        (*Yo) Yo   .    Yo
      '''),
  ),

  Puzzle(
    id: 'mine_32',
    initialGrid: GridFormat.parse('''
        .    .    Yo   Yo
        (*Yo) ()   .    Yo
        Yo   .    .    .
        (*Yo) Yo   .    Yo
      '''),
  ),

  Puzzle(
    id: 'mine_33',
    initialGrid: GridFormat.parse('''
        Yo   .    .    Yo
        Yo   .    .    Yo
        Yo   .    .    (*)
        (Yo) Yo   .    (Yo)
      '''),
  ),

  Puzzle(
    id: 'mine_34',
    initialGrid: GridFormat.parse('''
        .    Yo   Yo   Yo   .
        Yo   ()   Yo   ()   Yo
        Yo   Yo   .    Yo   Yo
        Yo   ()   Yo   ()   Yo
        .    Yo   Yo   Yo   .
      '''),
  ),

  Puzzle(
    id: 'mine_35',
    initialGrid: GridFormat.parse('''
        .    Yo   Yo   Yo   .
        Yo   .    (Yo) .    Yo
        .    (*Yo) .    (Yo) .
        Yo   .    (*Yo) .    Yo
        .    Yo   .    Yo   .
      '''),
  ),

  Puzzle(
    id: 'mine_36',
    initialGrid: GridFormat.parse('''
        Ko   Ko   .    .    .    .    .
        .    (*Ko) .    Wo   .    .    .
        .    .    Yo   (*Ko) .    .    .
        .    (*Ko) .    .    (*Ko) .    .
        .    .    (*Ko) .    Yo   .    .
        .    Ko   .    Ko   .    Ko   .
        .    .    (*Wo) Wo   (*Wo) .    .
      '''),
  ),

  Puzzle(
    id: 'mine_shortcut_1',
    initialGrid: GridFormat.parse('''
        Yo Wo Yo Wo Po
        Po .  Yo Wo Wo
        Po Wo Po Wo Yo
      '''),
  ),

  // TODO(bramp): mine_shortcut_2 is a walking puzzle
  Puzzle(
    id: 'mine_shortcut_2',
    initialGrid: GridFormat.parse('''
        o . . o
        o . . o
        o . . o
        o . . o
      '''),
  ),

  Puzzle(
    id: 'mine_shortcut_3',
    initialGrid: GridFormat.parse('''
        (*Co) Yo   Yo   Yo   (*Co)
        .    (Yo) .    Yo   .
        .    (Yo) .    Yo   .
        (*Co) Yo   Yo   Yo   (*Co)
      '''),
  ),

  Puzzle(
    id: 'mine_shortcut_4',
    initialGrid: GridFormat.parse('''
        Co .  Co Yo
        Yo Co .  Yo
        Yo Yo .  .
        Yo Yo Yo Co
      '''),
  ),

  Puzzle(
    id: 'mine_bonus_1',
    initialGrid: GridFormat.parse('''
        W1 .  .  .  .
        .  .  .  Y6 .
        .  . (W1) . .
        .  Y3 .  B6 .
        (W1) . . .  .
      '''),
  ),

  Puzzle(
    id: 'mine_bonus_2',
    initialGrid: GridFormat.parse('''
        .  .  Y3
        .  Y2 .
        Y1 .  .
      '''),
  ),

  Puzzle(
    id: 'mine_bonus_3',
    initialGrid: GridFormat.parse('''
        .  .  Wo .
        Wo .  .  Wo
        .  Y1 .  .
        .  B3 Wo .
      '''),
  ),

  Puzzle(
    id: 'mine_bonus_4',
    initialGrid: GridFormat.parse('''
        Yo .  B2 W4
        .  Yo .  .
        B2 .  .  Yo
        W4 .  Yo .
      '''),
  ),

  Puzzle(
    id: 'mine_bonus_5',
    initialGrid: GridFormat.parse('''
        B7 .  Yo Yo
        .  .  Yo Yo
        Wo Wo .  .
        Wo Wo .  B7
      '''),
  ),

  Puzzle(
    id: 'mine_bonus_6',
    initialGrid: GridFormat.parse('''
        Bo .  .  Bo
        .  Ro Ro Y3
        .  Ro Ro .
        Bo W3 Y3 Bo
      '''),
  ),

  Puzzle(
    id: 'mine_bonus_7',
    initialGrid: GridFormat.parse('''
        Bo .  .  Y6
        .  .  .  .
        .  .  .  .
        B6 .  .  Yo
      '''),
  ),

  Puzzle(
    id: 'mine_bonus_8',
    initialGrid: GridFormat.parse('''
        .  .  Wo B3
        Yo .  .  Wo
        .  Wo .  .
        W6 .  Yo .
      '''),
  ),

  Puzzle(
    id: 'mine_bonus_9',
    initialGrid: GridFormat.parse('''
        W4 .  .  Wo
        .  Wo .  .
        .  .  Wo .
        Wo .  .  Y4
      '''),
  ),

  Puzzle(
    id: 'mine_bonus_10',
    initialGrid: GridFormat.parse('''
        (*Y5) .  .  Yo
        .    Yo .  .
        .    .  Yo .
        Yo   .  .  (Y5)
      '''),
  ),

  Puzzle(
    id: 'mine_bonus_11',
    initialGrid: GridFormat.parse('''
        Po Yo Yo Yo
        Po Po Yo Po
        Po Yo Po Po
        Yo Yo Yo Po
      '''),
  ),
];
