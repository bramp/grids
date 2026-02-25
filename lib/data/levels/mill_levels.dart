import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/grid_format.dart';

final millLevels = [
  Puzzle(
    id: 'mill_1',
    initialGrid: GridFormat.parse('''
        (*) (*) ( )   .    .    .
        ( ) (*-) ( )  .   -  .
        ( ) (*) (*)  .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_2',
    initialGrid: GridFormat.parse('''
        ( ) (*) ( )  .    .    .
        (*) (*-) ( )  .    -    .
        ( ) (*) ( )  .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_3',
    initialGrid: GridFormat.parse('''
        ( )  (*.) ()  .    .    .
        (*-) (*.) ()  .    -  .
        ( )  (*.) ()  .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_4',
    initialGrid: GridFormat.parse('''
        ( )  (*.) ( )  .    .    .
        (*-) (*.) ( )  .    (-) .
        ( )  (*.) ( )  .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_5',
    initialGrid: GridFormat.parse('''
        -    .    .    .    .
        .    .    .    (-)  ( )
        .    .    .    ( )  ( )
      '''),
  ),

  Puzzle(
    id: 'mill_6',
    initialGrid: GridFormat.parse('''
        .    .    .    (*)  ( )
        -    .    .    (-)  ( )
        .    .    .    (*)  ( )
      '''),
  ),

  Puzzle(
    id: 'mill_7',
    initialGrid: GridFormat.parse('''
        ( )  (*) ( )  .    .    .
        (*) (*-) (*)  .    -    .
        ( )  (*) ( )  .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_8',
    initialGrid: GridFormat.parse('''
        ( )  (*)  .   .   .
        (*) (*-)  .   -   .
        ( )  (*)  .   .   .
      '''),
  ),

  Puzzle(
    id: 'mill_9',
    initialGrid: GridFormat.parse('''
        (*)  (*-)  .   .   -   .
        (*)  (*)   .   .   .   .
      '''),
  ),

  Puzzle(
    id: 'mill_10',
    initialGrid: GridFormat.parse('''
        (*-) (*)  -    .    -    .
        (*)  (*)  .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_11',
    initialGrid: GridFormat.parse('''
        (*)  (*-) .    .    -    .    .  (*-) (*)
        (*)  (*)  .    .    .    .    .  (*)  (*)
      '''),
  ),

  Puzzle(
    id: 'mill_12',
    initialGrid: GridFormat.parse('''
        . . . . .
        . - . . .
        . . - . .
        . . . - .
        . . . . .
      '''),
  ),

  Puzzle(
    id: 'mill_13',
    initialGrid: GridFormat.parse('''
        (*-) .    -    .    -  (*) .
        ( )  .    .   ( )   -   .  .
      '''),
  ),

  Puzzle(
    id: 'mill_14',
    note: 'Mixing of colours',
    initialGrid: GridFormat.parse('''
        (*)   ( )  (*)  (*)    .  . . .
        (*B-) (*)  ( )  (*-)  B-  . . -
        (*)   ( )  ( )  (*)    .  . . .
      '''),
  ),

  Puzzle(
    id: 'mill_15',
    initialGrid: GridFormat.parse('''
        ( )  ( )   (*)  ( )   .    .    .    .
        (-) (*G-)  (*)  (W-)  -   *G-   .   W-
        ( )  (*)   ( )  ( )   .    .    .    .
      '''),
  ),

  // TODO Did up to here
  Puzzle(
    id: 'mill_16',
    initialGrid: GridFormat.parse('''
        (*)  (*)  (*)  .    .    .    .    .
        (*)  (*-) (*)  (*)  (*)  (*B-) (*)  (*B-)
        (*)  (*)  (*)  .    .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_17',
    initialGrid: GridFormat.parse('''
        .    .    (*)  (*)  (*)  .    .    .    .    .    .
        .    (*-) .    .    (*)  (*)  (*)  (*)  (*B-) (*)  (*R-)
        .    .    .    .    (*)  (*)  (*)  .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_18',
    initialGrid: GridFormat.parse('''
        (*)  (*)  .    .    .    .
        (*-) (*Y-) .    (*-) (*W-) .
        (*)  (*)  .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_19',
    initialGrid: GridFormat.parse('''
        .    .    .    (*)  (*)  (*)
        (*-) .    (*Y-) (*-) (*W-) (*)
        .    .    .    (*)  (*)  (*)
      '''),
  ),

  Puzzle(
    id: 'mill_20',
    initialGrid: GridFormat.parse('''
        .    .    (*)  (*)  .    .    .    (*)
        (*)  (*G-) (*)  (*-) (*W-) .    (*)  (*)
        .    .    (*)  (*)  .    .    .    (*)
      '''),
  ),

  Puzzle(
    id: 'mill_21',
    initialGrid: GridFormat.parse('''
        -    .    .    .    .
        Y-   .    -    .    .
        -    .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_22',
    initialGrid: GridFormat.parse('''
        (*Y-) .    Y-   .    Y-   .    .
        (*)  .    -    .    -    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_23',
    initialGrid: GridFormat.parse('''
        (*)  (*)  (*)  .    .    .
        (*)  (*/) (*)  (*)  (*/) .
        (*)  (*)  (*)  .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_24',
    initialGrid: GridFormat.parse('''
        .    .    .    (*)  (*)  (*)
        .    /    .    (*)  (*/) (*)
        .    .    .    (*)  (*)  (*)
      '''),
  ),

  Puzzle(
    id: 'mill_25',
    initialGrid: GridFormat.parse('''
        (*)  (*)  (*)  .    .    .
        .    (*-) .    .    (*/) .
        (*)  (*)  (*)  .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_26',
    initialGrid: GridFormat.parse('''
        (*)  (*)  (*)  .    .    .
        (*)  (*/) (*)  (*)  (*/) .
        (*)  (*)  (*)  .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_27',
    initialGrid: GridFormat.parse('''
        (*)  (*)  (*)  .    .    .
        .    (*/) .    (*)  (*/) .
        (*)  (*)  (*)  .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_28',
    initialGrid: GridFormat.parse('''
        (*)  (*)  (*)  /    .
        (*)  (*)  (*)  .    .
        (*)  /    (*)  .    .
      '''),
  ),

  Puzzle(
    id: 'mill_29',
    initialGrid: GridFormat.parse('''
        (*)  (*)  .    .    .    .
        (*-) .    /    /    (-)  .
        (*)  (*)  .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_33',
    initialGrid: GridFormat.parse('''
        /    .    .    .    .
        .    /    -    /    .
        ()   .    .    .    -
        ()   /    ()   .    .
      '''),
  ),

  Puzzle(
    id: 'mill_34',
    initialGrid: GridFormat.parse('''
        .    .    (*)  .    /
        ()   ()   .    .    .
        .    .    .    .    ()
        .    /    .    ()   ()
        /    .    ()   .    .
      '''),
  ),

  Puzzle(
    id: 'mill_35',
    initialGrid: GridFormat.parse('''
        .    ()   .    .    /    .
        .    (*-) .    .    .    .
        .    .    .    -    .    .
        /    .    .    .    .    /
        .    ()   (*-) .    ()   .
        .    .    .    ()   /    .
      '''),
  ),

  Puzzle(
    id: 'mill_36',
    initialGrid: GridFormat.parse('''
        .    .    .    .    .    .    .    .    .    .
        .    .    .    .    .    ()   /    .    .    .
        .    .    /    .    .    (*-) .    .    .    .
        .    ()   .    ()   .    /    .    .    .    .
        .    .    -    .    ()   .    .    .    .    .
        .    .    /    .    .    .    ()   .    .    .
        .    .    .    .    .    .    (*-) .    .    .
        .    .    .    .    .    .    .    .    .    .
        .    .    /    (*-) .    .    .    .    .    .
        .    .    .    .    .    .    .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_1',
    initialGrid: GridFormat.parse('''
        O-   .    O-   .    .    .
        -    .    .    -    .    .
        O-   .    O-   .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_2',
    initialGrid: GridFormat.parse('''
        (/)  ()   .    .    .
        .    ()   .    .    O/
        ()   /    .    O/   ()
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_3',
    initialGrid: GridFormat.parse('''
        C/   O/   .    ()   .    C/   /
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_4',
    initialGrid: GridFormat.parse('''
        .    .    .    .    ()   .    .    .    .    .
        .    /    O/   .    W/   /    .    B/   W/   ()
        .    .    .    .    ()   .    .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_5',
    initialGrid: GridFormat.parse('''
        (*)  .    .    .    .    .    .    .    .    ()
        O/   .    C/   O/   /    .    C/   .    .    /
        (*)  .    .    .    .    .    .    .    .    ()
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_6',
    initialGrid: GridFormat.parse('''
        ()   ()   ()   .    .    .
        .    /    .    /    .    .
        ()   ()   ()   .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_7',
    initialGrid: GridFormat.parse('''
        ()   ()   .    /    .    .
        ()   ()   ()   .    .    .
        .    ()   /    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_8',
    initialGrid: GridFormat.parse('''
        ()   ()   .    .    .    .
        ()   /    .    .    /    ()
        ()   ()   ()   ()   .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_9',
    initialGrid: GridFormat.parse('''
        ()   ()   .    .    .    .
        .    /    .    .    /    ()
        ()   ()   ()   ()   .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_10',
    initialGrid: GridFormat.parse('''
        ()   ()   .    .    .    .
        .    /    .    .    /    ()
        ()   ()   ()   ()   .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_11',
    initialGrid: GridFormat.parse('''
        /    ()   .    /    ()   ()
        .    .    .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_12',
    initialGrid: GridFormat.parse('''
        ()   ()   .    -    .    /
        .    .    .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_13',
    initialGrid: GridFormat.parse('''
        ()   ()   .    .    .    .
        .    /    .    /    .    .
        ()   ()   .    .    ()   .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_14',
    initialGrid: GridFormat.parse('''
        O-   ()   .    .    .    O-   .    .    O-
        .    -    .    -    ()   .    .    -    .
        .    .    .    /    /    .    .    .    O-
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_15',
    initialGrid: GridFormat.parse('''
        .    .    /    .    .    ()   /    .    .    .
        .    .    .    .    .    ()   .    .    .    .
        .    .    .    /    .    .    .    /    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_16',
    initialGrid: GridFormat.parse('''
        .    .    /    .    .    ()   /    .    .    .
        .    .    .    .    .    ()   .    .    .    .
        .    .    .    /    .    .    .    /    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_17',
    initialGrid: GridFormat.parse('''
        .    .    .    .    O/   .
        C/   O/   .    C/   .    .
        .    .    ()   ()   .    .
        O/   .    /    .    .    O/
        .    .    .    .    O/   .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_18',
    initialGrid: GridFormat.parse('''
        .    .    .    .    .    .
        .    .    .    .    ()   .
        .    O-   ()   /    O-   .
        .    .    ()   /    .    .
        .    ()   .    .    O-   .
        .    .    .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_19',
    initialGrid: GridFormat.parse('''
        .    .    .    .    .    .
        .    Po   .    Po   ()   Po
        .    O-   /    /    O-   .
        .    .    /    /    .    .
        .    ()   O-   Po   O-   Po
        .    .    .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_20',
    initialGrid: GridFormat.parse('''
        .    /    .    .    O/   .
        .    .    O/   .    O/   O/
        .    .    .    .    .    .
        O/   .    .    .    O/   .
        .    O/   .    .    .    /
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_21',
    initialGrid: GridFormat.parse('''
        .    .    .
        O/   .    .
        .    .    O/
        .    O/   .
        O/   .    .
        .    .    O/
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_22',
    initialGrid: GridFormat.parse('''
        ()   ()   O/   Po   O/   .    .    O/   O/   .
        O/   .    O/   O/   .    .    .    .    .    .
        .    .    .    Po   O/   /    .    O/   .    O/
        O/   Po   .    .    .    .    .    .    .    .
        .    .    .    .    .    O/   O/   .    .    .
        O/   .    .    .    .    .    .    .    .    O/
        O/   .    O/   O/   .    O/   .    O/   .    .
        .    .    .    .    O/   O/   .    .    .    .
        .    .    O/   Po   .    .    .    .    ()   /
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_23',
    initialGrid: GridFormat.parse('''
        .    .    .    -    O/   .    .
        .    .    .    .    .    .    .
        .    .    .    O-   .    .    -
        .    .    .    .    .    .    .
        O-   .    .    .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_24',
    initialGrid: GridFormat.parse('''
        O5   .    R2   .    R2   .
        .    .    .    .    .    .
        .    .    .    .    .    R2
        .    R1   .    .    .    .
        .    .    .    .    .    O5
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_25',
    initialGrid: GridFormat.parse('''
        .    .    .    .    .
        .    O-   .    O-   .
        .    .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_26',
    initialGrid: GridFormat.parse('''
        .    O2   .    O2   .
        .    O-   O2   O-   .
        .    .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_27',
    initialGrid: GridFormat.parse('''
        .    .    .    .    O-   .
        .    O-   .    .    O4   .
        .    .    .    .    .    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_28',
    initialGrid: GridFormat.parse('''
        .    .    .    .    /    .
        .    /    .    /    .    .
        .    .    .    .    /    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_29',
    initialGrid: GridFormat.parse('''
        .    /    .    .    .    .
        .    .    ()   .    /    .
        .    .    .    .    /    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_30',
    initialGrid: GridFormat.parse('''
        ()   /    .    .    .    ()
        O6   .    .    .    .    O6
        ()   .    .    .    /    ()
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_31',
    initialGrid: GridFormat.parse('''
        /    /    O2   .    .    .    .    .    .
        .    .    ()   O2   .    .    .    .    C6
        .    .    .    .    .    .    .    .    .
        .    .    .    .    .    .    .    .    .
        .    O1   .    .    .    /    C1   .    O4
        .    .    .    .    .    .    .    .    .
        .    .    .    .    .    .    .    .    .
        O3   .    .    .    .    ()   .    .    C6
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_32',
    initialGrid: GridFormat.parse('''
        .    O-   .
        .    O4   .
        .    O-   .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_33',
    initialGrid: GridFormat.parse('''
        .    .    .    .    P-   .
        O4   O-   .    .    .    .
        .    O-   .    .    /    .
      '''),
  ),

  Puzzle(
    id: 'mill_bonus_34',
    initialGrid: GridFormat.parse('''
        .    O-   .    .    .
        W4   P-   .    P-   .
        O-   .    .    /    .
        .    .    .    .    .
      '''),
  ),
];
