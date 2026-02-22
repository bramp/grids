import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/puzzle.dart';

/// A hardcoded repository of levels to build the initial game progression.
///
/// To add a known solution to a puzzle, run:
///   `dart run bin/solve.dart --mask PUZZLE_ID`
/// and copy the output directly.
//
class LevelRepository {
  /// Ordered list of levels for the main progression.
  /// https://steamcommunity.com/sharedfiles/filedetails/?id=2861109284
  static final List<Puzzle> levels = [
    Puzzle(
      id: 'shrine_1',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_2',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_3',
      initialGrid: GridFormat.parse('''
        . 1
        . 1
        1 .
        1 .
      '''),
      knownSolutions: [
        GridFormat.parseMask('''
          . *
          . *
          * .
          . *
        '''),
      ],
    ),
    Puzzle(
      id: 'shrine_4',
      initialGrid: GridFormat.parse('''
        . 1
        1 .
        1 .
        . 1
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
    Puzzle(
      id: 'shrine_5',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_6',
      initialGrid: GridFormat.parse('''
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
    shrine_7 requires a start and end - which is not supported yet.
    Puzzle(
      id: 'shrine_7',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_9',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_17',
      initialGrid: GridFormat.parse('''
         B1
         Y1
      '''),
      knownSolutions: [
        GridFormat.parseMask('''
          .
          *
        '''),
      ],
    ),
    Puzzle(
      id: 'shrine_18',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_19',
      initialGrid: GridFormat.parse('''
         Y1 Y1 B1 B1
         B1 Y1 B1 Y1
         B1 Y1 B1 Y1
         Y1 Y1 B1 B1
      '''),
      knownSolutions: [
        GridFormat.parseMask('''
          . . * *
          * . * .
          . * . *
          * . * .
        '''),
      ],
    ),
    Puzzle(
      id: 'shrine_20',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_21',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_22',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_23',
      initialGrid: GridFormat.parse('''
         B1 B1 Y1 B1
        Y1 Y1 Y1 B1
         B1 B1 B1 Y1
         Y1 Y1 B1 Y1
      '''),
    ),
    // shrine 24 is a repeat of 23.
    */
    Puzzle(
      id: 'shrine_25',
      initialGrid: GridFormat.parse('''
         . . .
         B4 . Y4
         . . .
      '''),
      knownSolutions: [
        GridFormat.parseMask('''
          . . .
          . * *
          * * .
        '''),
      ],
    ),
    Puzzle(
      id: 'shrine_26',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_27',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_28',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_29',
      initialGrid: GridFormat.parse('''
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
    // TODO(bramp): shrine_30 is an end-start problem
    Puzzle(
      id: 'shrine_30',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_31',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_32',
      initialGrid: GridFormat.parse('''
         . .  .  .
         . Y4  B4  .
         . . W4 .
         . . K4 .
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
    Puzzle(
      id: 'shrine_33',
      initialGrid: GridFormat.parse('''
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

    Puzzle(
      id: 'shrine_34',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_38',
      note: 'Beginning of the negative numbers',
      initialGrid: GridFormat.parse('''
        -2 . .
        . . .
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

    Puzzle(
      id: 'shrine_39',
      initialGrid: GridFormat.parse('''
        . . .
        -3 . .
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
    Puzzle(
      id: 'shrine_40',
      initialGrid: GridFormat.parse('''
        . . .
        -4 . .
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
    Puzzle(
      id: 'shrine_41',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_42',
      initialGrid: GridFormat.parse('''
        -3 . .
        . -3 .
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
    Puzzle(
      id: 'shrine_43',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_44',
      initialGrid: GridFormat.parse('''
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
    Puzzle(
      id: 'shrine_45',
      initialGrid: GridFormat.parse('''
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

    Puzzle(
      id: 'shrine_46',
      note: 'Learn if a area sums to zero, the area can be any size',
      initialGrid: GridFormat.parse('''
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

    Puzzle(
      id: 'shrine_47',
      note: 'Learn that areas can never have a net negative sum',
      initialGrid: GridFormat.parse('''
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

    Puzzle(
      id: 'shrine_48',
      initialGrid: GridFormat.parse('''
        -1 .  .  -1
        (1)  .  .   (1)
        (1)   .  .   (1)
        1 .  .  1
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

    Puzzle(
      id: 'shrine_49',
      initialGrid: GridFormat.parse('''
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

    Puzzle(
      id: 'shrine_50',
      initialGrid: GridFormat.parse('''
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

    Puzzle(
      id: 'shrine_51',
      initialGrid: GridFormat.parse('''
          9 . . -1
          -1 . . -1
          -1 . . -1
          -1 . . 9
        ''', defaultColor: CellColor.yellow),
      knownSolutions: [
        GridFormat.parseMask('''
          . . . .
          . . . .
          . * * .
          . * * .
        '''),
      ],
    ),

    Puzzle(
      id: 'shrine_52',
      initialGrid: GridFormat.parse('''
          -7 .  .  3
          .   9 .  .
          .   .  9 .
          3  .  .  -7
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

    Puzzle(
      id: 'shrine_53',
      initialGrid: GridFormat.parse('''
          1   .  1  -1
          -1  .   .  -1
          -1 -1 1  -1
          -1  .   .  -1
          -1  .   .  -1
          -1  1  .   9
        ''', defaultColor: CellColor.yellow),
      knownSolutions: [
        GridFormat.parseMask('''
          . . . .
          . . . .
          . . * .
          . . . .
          . . . .
          . * . .
        '''),
      ],
    ),
    // TODO(bramp): shrine_54 is a start-end problem
    // TODO(bramp): shrine_55 is a start-end problem
    // TODO(bramp): shrine_56 is a previous start-end problem
    Puzzle(
      id: 'shrine_57',
      initialGrid: GridFormat.parse('''
        (2)  .  (*3)  .  (2)
        .    .   .   .  .
        (*3) .  (5)  .  (*3)
        .    .   .   .  .
        (2)  .  (*3) .  (2)
      '''),
      knownSolutions: [
        GridFormat.parseMask('''
          . . * . .
          . . * * *
          * . . . *
          * * * * *
          . . * . .
        '''),
      ],
    ),

    Puzzle(
      id: 'shrine_58',
      initialGrid: GridFormat.parse('''
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

    Puzzle(
      id: 'shrine_59',
      initialGrid: GridFormat.parse('''
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

    Puzzle(
      id: 'shrine_60',
      initialGrid: GridFormat.parse('''
        (5)    .    .    .     .   (5)
         .   (*6)   .    .     .    .
         .     .    .   (B4)   .    .
         .     .    .    .     .    .
         .     .    .    .    (*6)  .
        (5)  (*)   .    .     .     5
      '''),
    ),

    // TODO(bramp): Shortcut #2 start to finish puzzle
    // TODO(bramp): Bonus_5 diamond puzzle
    // TODO(bramp): New puzzle type - Gardens / Flowers
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

    // Next puzzle here
  ];
}
