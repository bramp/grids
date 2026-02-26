import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/level.dart';

final mineLevels = [
  Level(
    id: 'mine_1',
    note: 'Learn that diamonds need to be connected',
    puzzle: GridFormat.parse('''
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
  Level(
    id: 'mine_2',
    puzzle: GridFormat.parse('''
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
  Level(
    id: 'mine_3',
    puzzle: GridFormat.parse('''
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
  Level(
    id: 'mine_4',
    puzzle: GridFormat.parse('''
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
  Level(
    id: 'mine_5',
    puzzle: GridFormat.parse('''
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
  Level(
    id: 'mine_6',
    puzzle: GridFormat.parse('''
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

  Level(
    id: 'mine_7',
    puzzle: GridFormat.parse('''
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

  Level(
    id: 'mine_8',
    puzzle: GridFormat.parse('''
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
  Level(
    id: 'mine_9',
    puzzle: GridFormat.parse('''
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
  Level(
    id: 'mine_10',
    puzzle: GridFormat.parse('''
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
  Level(
    id: 'mine_11',
    puzzle: GridFormat.parse('''
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
  Level(
    id: 'mine_12',
    puzzle: GridFormat.parse('''
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
  Level(
    id: 'mine_13',
    puzzle: GridFormat.parse('''
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

  Level(
    id: 'mine_14',
    note: 'Introduction to multiple colours',
    puzzle: GridFormat.parse('''
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

  Level(
    id: 'mine_15',
    note: 'Introduction to colours can mix',
    puzzle: GridFormat.parse('''
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

  Level(
    id: 'mine_16',
    puzzle: GridFormat.parse('''
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

  Level(
    id: 'mine_17',
    puzzle: GridFormat.parse('''
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

  Level(
    id: 'mine_18',
    puzzle: GridFormat.parse('''
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

  Level(
    id: 'mine_19',
    puzzle: GridFormat.parse('''
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

  Level(
    id: 'mine_20',
    puzzle: GridFormat.parse('''
        Ko  Yo  Yo  Ko
        Yo  .   .   Yo
        Yo  .   .   Yo
        Ko  Yo  Yo  Ko
      '''),
  ),

  Level(
    id: 'mine_21',
    puzzle: GridFormat.parse('''
        Ko  Yo  Yo  .
        Yo  .   .   Yo
        Yo  .   .   Yo
        .   Yo  Yo  Ko
      '''),
  ),

  Level(
    id: 'mine_22',
    puzzle: GridFormat.parse('''
        .     Wo    .     Wo    (*Bo)
        Wo    ()    .     (Yo)  Wo
        .     .     Yo    Ko    .
        Wo    (Yo)  Ko    Yo    .
        Bo    Wo    ()    .     .
      '''),
  ),

  Level(
    id: 'mine_23',
    puzzle: GridFormat.parse('''
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
  Level(
    id: 'mine_31',
    puzzle: GridFormat.parse('''
        Yo (*)    Yo   (*Yo)
        Yo   (*Yo) .    .
        .    .    .    .
        (*Yo) Yo   .    Yo
      '''),
  ),

  Level(
    id: 'mine_32',
    puzzle: GridFormat.parse('''
        .    .    Yo   Yo
        (*Yo) ()   .    Yo
        Yo   .    .    .
        (*Yo) Yo   .    Yo
      '''),
  ),

  Level(
    id: 'mine_33',
    puzzle: GridFormat.parse('''
        Yo   .    .    Yo
        Yo   .    .    Yo
        Yo   .    .    (*)
        (Yo) Yo   .    (Yo)
      '''),
  ),

  Level(
    id: 'mine_34',
    puzzle: GridFormat.parse('''
        .    Yo   Yo   Yo   .
        Yo   ()   Yo   ()   Yo
        Yo   Yo   .    Yo   Yo
        Yo   ()   Yo   ()   Yo
        .    Yo   Yo   Yo   .
      '''),
  ),

  Level(
    id: 'mine_35',
    puzzle: GridFormat.parse('''
        .    Yo   Yo   Yo   .
        Yo   .    (Yo) .    Yo
        .    (*Yo) .    (Yo) .
        Yo   .    (*Yo) .    Yo
        .    Yo   .    Yo   .
      '''),
  ),

  Level(
    id: 'mine_36',
    puzzle: GridFormat.parse('''
        Ko   Ko   .    .    .    .    .
        .    (*Ko) .    Wo   .    .    .
        .    .    Yo   (*Ko) .    .    .
        .    (*Ko) .    .    (*Ko) .    .
        .    .    (*Ko) .    Yo   .    .
        .    Ko   .    Ko   .    Ko   .
        .    .    (*Wo) Wo   (*Wo) .    .
      '''),
  ),

  Level(
    id: 'mine_shortcut_1',
    puzzle: GridFormat.parse('''
        Yo Wo Yo Wo Po
        Po .  Yo Wo Wo
        Po Wo Po Wo Yo
      '''),
  ),

  // TODO(bramp): mine_shortcut_2 is a walking puzzle
  Level(
    id: 'mine_shortcut_2',
    puzzle: GridFormat.parse('''
        o . . o
        o . . o
        o . . o
        o . . o
      '''),
  ),

  Level(
    id: 'mine_shortcut_3',
    puzzle: GridFormat.parse('''
        (*Co) Yo   Yo   Yo   (*Co)
        .    (Yo) .    Yo   .
        .    (Yo) .    Yo   .
        (*Co) Yo   Yo   Yo   (*Co)
      '''),
  ),

  Level(
    id: 'mine_shortcut_4',
    puzzle: GridFormat.parse('''
        Co .  Co Yo
        Yo Co .  Yo
        Yo Yo .  .
        Yo Yo Yo Co
      '''),
  ),

  Level(
    id: 'mine_bonus_1',
    puzzle: GridFormat.parse('''
        W1 .  .  .  .
        .  .  .  Y6 .
        .  . (W1) . .
        .  Y3 .  B6 .
        (W1) . . .  .
      '''),
  ),

  Level(
    id: 'mine_bonus_2',
    puzzle: GridFormat.parse('''
        .  .  Y3
        .  Y2 .
        Y1 .  .
      '''),
  ),

  Level(
    id: 'mine_bonus_3',
    puzzle: GridFormat.parse('''
        .  .  Wo .
        Wo .  .  Wo
        .  Y1 .  .
        .  B3 Wo .
      '''),
  ),

  Level(
    id: 'mine_bonus_4',
    puzzle: GridFormat.parse('''
        Yo .  B2 W4
        .  Yo .  .
        B2 .  .  Yo
        W4 .  Yo .
      '''),
  ),

  Level(
    id: 'mine_bonus_5',
    puzzle: GridFormat.parse('''
        B7 .  Yo Yo
        .  .  Yo Yo
        Wo Wo .  .
        Wo Wo .  B7
      '''),
  ),

  Level(
    id: 'mine_bonus_6',
    puzzle: GridFormat.parse('''
        Bo .  .  Bo
        .  Ro Ro Y3
        .  Ro Ro .
        Bo W3 Y3 Bo
      '''),
  ),

  Level(
    id: 'mine_bonus_7',
    puzzle: GridFormat.parse('''
        Bo .  .  Y6
        .  .  .  .
        .  .  .  .
        B6 .  .  Yo
      '''),
  ),

  Level(
    id: 'mine_bonus_8',
    puzzle: GridFormat.parse('''
        .  .  Wo B3
        Yo .  .  Wo
        .  Wo .  .
        W6 .  Yo .
      '''),
  ),

  Level(
    id: 'mine_bonus_9',
    puzzle: GridFormat.parse('''
        W4 .  .  Wo
        .  Wo .  .
        .  .  Wo .
        Wo .  .  Y4
      '''),
  ),

  Level(
    id: 'mine_bonus_10',
    puzzle: GridFormat.parse('''
        (*Y5) .  .  Yo
        .    Yo .  .
        .    .  Yo .
        Yo   .  .  (Y5)
      '''),
  ),

  Level(
    id: 'mine_bonus_11',
    puzzle: GridFormat.parse('''
        Po Yo Yo Yo
        Po Po Yo Po
        Po Yo Po Po
        Yo Yo Yo Po
      '''),
  ),
];
