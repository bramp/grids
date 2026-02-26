import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/level.dart';

final shrineLevels = [
  Level(
    id: 'shrine_1',
    puzzle: GridFormat.parse('''
        . .
        1 .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . .
          * .
        '''),
    ],
  ),
  Level(
    id: 'shrine_2',
    puzzle: GridFormat.parse('''
        . 1
        1 .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . *
          * .
        '''),
    ],
  ),
  // TODO(bramp): shrine_3 is a start and end - which is not supported yet.
  Level(
    id: 'shrine_4',
    puzzle: GridFormat.parse('''
        . 1
        . 1
        1 .
        1 .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . *
          * .
          . *
          * .
        '''),
    ],
  ),
  Level(
    id: 'shrine_5',
    puzzle: GridFormat.parse('''
        (.) 1
         1  .
         1  .
        (.) 1
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . *
          * .
          * .
          . *
        '''),
    ],
  ),
  Level(
    id: 'shrine_6',
    puzzle: GridFormat.parse('''
        (*1) .  . (1)
         .   1  .  .
         .   .  1  .
        (1)  .  .  1
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . * .
          . * . *
          * . * .
          . * . *
        '''),
    ],
  ),
  /*
    TODO(bramp): shrine_7 is a start and end - which is not supported yet.
    Level(
    id: 'shrine_7',
      puzzle: GridFormat.parse('''
         .   .   1
         .   .   .
        (*1) .   .
         1   .   .
         .   .   1
         1   .   .
         .   1   1
      '''),
      knownSolutions: [
        GridFormat.parseMask('''
          . . *
          . . .
          * . .
          . * .
          * . *
          . * .
          * . *
        '''),
      ],
    ),
    */
  // TODO(bramp): level 8 is a walking path problem
  Level(
    id: 'shrine_9',
    puzzle: GridFormat.parse('''
         .   .
         2   .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . .
          * *
        '''),
    ],
  ),
  // TODO(bramp): level 10-16 are walking path problems
  Level(
    id: 'shrine_17',
    puzzle: GridFormat.parse('''
         B1
         Y1
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          *
          .
        '''),
    ],
  ),
  Level(
    id: 'shrine_18',
    puzzle: GridFormat.parse('''
         (B1) Y1
          Y1 (*Y1)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . *
          * *
        '''),
    ],
  ),
  Level(
    id: 'shrine_19',
    puzzle: GridFormat.parse('''
         Y1 Y1 B1 B1
         B1 Y1 B1 Y1
         B1 Y1 B1 Y1
         Y1 Y1 B1 B1
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . .
          . * . *
          . * . *
          * * . .
        '''),
    ],
  ),
  Level(
    id: 'shrine_20',
    puzzle: GridFormat.parse('''
         .  .  .  .
         .  .  B1 Y1
         Y1 B1 .  .
         .  .  .  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . *
          * . * .
          . * . *
          * . . .
        '''),
    ],
  ),
  Level(
    id: 'shrine_21',
    puzzle: GridFormat.parse('''
         .  .  B1  .
         .  .  B1 B1
         Y1 Y1 .  .
         .  Y1  .  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . * .
          . . * *
          * * . .
          . * . .
        '''),
    ],
  ),
  Level(
    id: 'shrine_22',
    puzzle: GridFormat.parse('''
         K1 Y1 P1 W1
         Y1 B1 K1 P1
         P1 W1 B1 W1
         B1 K1 Y1 P1
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
  /*
     shrine_23 / shrine_24 requires a start and end - which is not supported yet.
    Level(
    id: 'shrine_23',
      puzzle: GridFormat.parse('''
         B1 B1 Y1 B1
        Y1 Y1 Y1 B1
         B1 B1 B1 Y1
         Y1 Y1 B1 Y1
      '''),
    ),
    // shrine 24 is a repeat of 23.
    */
  Level(
    id: 'shrine_25',
    puzzle: GridFormat.parse('''
         .  .  .
         B4 . Y4
         .  .  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . .
          . * *
          * * .
        '''),
    ],
  ),
  Level(
    id: 'shrine_26',
    puzzle: GridFormat.parse('''
         . . .
         B4 . Y3
         . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . .
          . * *
          * . *
        '''),
    ],
  ),
  Level(
    id: 'shrine_27',
    puzzle: GridFormat.parse('''
         . . .
         . B4 Y2
         . . .
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
    id: 'shrine_28',
    puzzle: GridFormat.parse('''
         . . .
         . B4 Y1
         . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . .
          * . *
          . * .
        '''),
    ],
  ),
  Level(
    id: 'shrine_29',
    puzzle: GridFormat.parse('''
         B3 . Y2
         . . .
         Y2 . B2
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . *
          * . *
          * . .
        '''),
    ],
  ),
  // TODO(bramp): shrine_30 is an start-end problem
  Level(
    id: 'shrine_30',
    puzzle: GridFormat.parse('''
         . . B3
         . . Y2
         . . B4
         Y2 . .
         B4 . .
         . . Y2
         . . B4
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . .
          . * *
          . . .
          * * .
          . . .
          . * *
          . . .
        '''),
    ],
  ),
  Level(
    id: 'shrine_31',
    puzzle: GridFormat.parse('''
         . .  .  .
         . .  .  .
         . B4 Y4 .
         . Y4 B4 .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . * *
          * . * .
          * . * .
          * * . .
        '''),
    ],
  ),
  Level(
    id: 'shrine_32',
    puzzle: GridFormat.parse('''
         . .   .  .
         . Y4  B4 .
         . .   W4 .
         . .   K4 .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . *
          * * . *
          * . * *
          * . . .
        '''),
    ],
  ),
  Level(
    id: 'shrine_33',
    puzzle: GridFormat.parse('''
         . .  .  . .  .
         . K3 W3 . B3 Y3
         . B3 Y3 . K3 W3
         . .  .  . .  .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * * . * *
          . . * . . *
          * * . * * .
          * . . * . .
        '''),
    ],
  ),

  Level(
    id: 'shrine_34',
    puzzle: GridFormat.parse('''
         . . . . . . Y1
         . . . Y5 W4 B3 W2
         . . . K6 . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . * * * .
          * * . . * . *
          * * * * . . *
        '''),
    ],
  ),

  // TODO(bramp): shrine_35 / shrine_36 is a start-end problem
  // TODO(bramp): shrine_37 is a start-end problem
  Level(
    id: 'shrine_38',
    note: 'Beginning of the negative numbers',
    puzzle: GridFormat.parse('''
         -2  .  .
          .  .  .
        (*6) . (4)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * . *
          * . .
          * * .
        '''),
    ],
  ),

  Level(
    id: 'shrine_39',
    puzzle: GridFormat.parse('''
         .   .  .
        -3   .  .
        (*6) . (4)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          * . .
          * * .
        '''),
    ],
  ),
  Level(
    id: 'shrine_40',
    puzzle: GridFormat.parse('''
          .  .  .
         -4  .  .
        (*6) . (4)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * *
          * . .
          * . .
        '''),
    ],
  ),
  Level(
    id: 'shrine_41',
    puzzle: GridFormat.parse('''
        .     .  -2
        .     .  -1
        (*5) .  (6)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * .
          * * .
          * * .
        '''),
    ],
  ),
  Level(
    id: 'shrine_42',
    puzzle: GridFormat.parse('''
         -3   .  .
          .  -3  .
        (*6) (6) .
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
    id: 'shrine_43',
    puzzle: GridFormat.parse('''
        Y6 . . .
        . 3 -1 .
        . -1 3 .
        . . . Y6
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . .
          . * * .
          . * * .
          . . . .
        '''),
    ],
  ),
  Level(
    id: 'shrine_44',
    puzzle: GridFormat.parse('''
        6 . . .
        . Y3 -1 .
        . -1 Y3 .
        . . . 6
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . .
          * * . *
          * . * *
          . . . .
        '''),
    ],
  ),
  Level(
    id: 'shrine_45',
    puzzle: GridFormat.parse('''
        (*4) .    .     .
        .    (3)  -1   .
        .     -1  (3)  .
        .      .    .   (*4)
      ''', defaultColor: CellColor.yellow),
    knownSolutions: [
      GridFormat.parseMask('''
          * . * .
          * . . *
          * * . .
          . * * *
        '''),
    ],
  ),

  Level(
    id: 'shrine_46',
    note: 'Learn if a area sums to zero, the area can be any size',
    puzzle: GridFormat.parse('''
        Y1 . Y1 -2
        .  . .  .
        Y1 . Y1 .
        2 . .  Y1
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * . *
          * * * *
          . * . *
          * * * .
        '''),
    ],
  ),

  Level(
    id: 'shrine_47',
    note: 'Learn that areas can never have a net negative sum',
    puzzle: GridFormat.parse('''
        Y-1 .  B1  -1
        Y1  .  .   .
        .   .  .   Y1
        B-1 1 .   Y-1
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * * .
          . * . .
          * * . *
          * . . *
        '''),
    ],
  ),

  Level(
    id: 'shrine_48',
    puzzle: GridFormat.parse('''
        -1   .  .  -1
        (1)  .  .  (1)
        (1)  .  .  (1)
       (*1)  .  . (*1)
      ''', defaultColor: CellColor.yellow),
    knownSolutions: [
      GridFormat.parseMask('''
          * * * *
          . * * .
          . * * .
          * * * *
        '''),
    ],
  ),

  Level(
    id: 'shrine_49',
    puzzle: GridFormat.parse('''
        -1   -1 -1  -1
        (1)  -1 -1  (1)
        (1)  -1 -1  (1)
        (*1)  1  1  (*1)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . .
          . * * .
          . * * .
          * * * *
        '''),
    ],
  ),

  Level(
    id: 'shrine_50',
    puzzle: GridFormat.parse('''
          (1)  -1 (*1) -1
          (*1) -1 (1) -1
          (1)  -1 (*1) -1
          (*1) -1  (1) -1
        ''', defaultColor: CellColor.yellow),
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
    id: 'shrine_51',
    puzzle: GridFormat.parse('''
           9 . . -1
          -1 . . -1
          -1 . . -1
          -1 . .  9
        ''', defaultColor: CellColor.yellow),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . .
          . * * .
          . * * .
          . . . .
        '''),
    ],
  ),

  Level(
    id: 'shrine_52',
    puzzle: GridFormat.parse('''
         -7  .  .  3
          .  9  .  .
          .  .  9  .
          3  .  . -7
        ''', defaultColor: CellColor.yellow),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . .
          * . * *
          * * . *
          . . . .
        '''),
    ],
  ),

  Level(
    id: 'shrine_53',
    puzzle: GridFormat.parse('''
           1  .  1  -1
          -1  .  .  -1
          -1 -1  1  -1
          -1  .  .  -1
          -1  1  .   9
        ''', defaultColor: CellColor.yellow),
    knownSolutions: [
      GridFormat.parseMask('''
          * . * .
          . . . .
          . . * .
          . . . .
          . * . .
        '''),
    ],
  ),
  // TODO(bramp): shrine_54 is a start-end problem
  // TODO(bramp): shrine_55 is a start-end problem
  // TODO(bramp): shrine_56 is a previous start-end problem
  Level(
    id: 'shrine_57',
    puzzle: GridFormat.parse('''
        (2)  .  (*3)  .  (2)
        .    .   .   .  .
        (*3) .  (5)  .  (*3)
        .    .   .   .  .
        (2)  .  (*3) .  (2)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * * . .
          . * . * *
          * . . . *
          * * . * .
          . . * * .
        '''),
    ],
  ),

  Level(
    id: 'shrine_58',
    puzzle: GridFormat.parse('''
        (3)  .  (*3) .  (3)
        .    .   .   .   .
        (*3) .   .   .  (*3)
        .    .   .   .   .
        (3)  .  (*3) .  (3)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . * . .
          . * * . *
          * * . * *
          . * * . .
          . . * * .
        '''),
    ],
  ),

  Level(
    id: 'shrine_59',
    puzzle: GridFormat.parse('''
        (2)  .   .    .   (2)
         .   .   .    .    .
         .   .  (*6)  .    .
         .   .   .    .    .
        (2)  .   .    .   (2)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . * . .
          * * . * *
          . . * * .
          * * . * *
          . . * . .
        '''),
    ],
  ),

  Level(
    id: 'shrine_60',
    puzzle: GridFormat.parse('''
        (5)    .    .    .     .   (5)
         .   (*6)   .    .     .    .
         .     .    .   (B4)   .    .
         .     .    .    .     .    .
         .     .    .    .    (*6)  .
        (5)  (*)   .    .     .     5
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . . . .
          . * * * . .
          . * . . * .
          . * . . * .
          . * * * * .
          . * . . . .
        '''),
    ],
  ),

  // TODO(bramp): Shortcut #2 start to finish puzzle
  // TODO(bramp): Bonus_5 diamond puzzle
  // TODO(bramp): New puzzle type - Gardens / Flowers
];
