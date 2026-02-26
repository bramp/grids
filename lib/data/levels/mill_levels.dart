import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/level.dart';

final millLevels = [
  Level(
    id: 'mill_1',
    puzzle: GridFormat.parse('''
        (*) (*) ( )   .    .    .
        ( ) (*-) ( )  .   -  .
        ( ) (*) (*)  .    .    .
      '''),
  ),

  Level(
    id: 'mill_2',
    puzzle: GridFormat.parse('''
        ( ) (*) ( )  .    .    .
        (*) (*-) ( )  .    -    .
        ( ) (*) ( )  .    .    .
      '''),
  ),

  Level(
    id: 'mill_3',
    puzzle: GridFormat.parse('''
        ( )  (*.) ()  .    .    .
        (*-) (*.) ()  .    -  .
        ( )  (*.) ()  .    .    .
      '''),
  ),

  Level(
    id: 'mill_4',
    puzzle: GridFormat.parse('''
        ( )  (*.) ( )  .    .    .
        (*-) (*.) ( )  .    (-) .
        ( )  (*.) ( )  .    .    .
      '''),
  ),

  Level(
    id: 'mill_5',
    puzzle: GridFormat.parse('''
        -    .    .    .    .
        .    .    .    (-)  ( )
        .    .    .    ( )  ( )
      '''),
  ),

  Level(
    id: 'mill_6',
    puzzle: GridFormat.parse('''
        .    .    .    (*)  ( )
        -    .    .    (-)  ( )
        .    .    .    (*)  ( )
      '''),
  ),

  Level(
    id: 'mill_7',
    puzzle: GridFormat.parse('''
        ( )  (*) ( )  .    .    .
        (*) (*-) (*)  .    -    .
        ( )  (*) ( )  .    .    .
      '''),
  ),

  Level(
    id: 'mill_8',
    puzzle: GridFormat.parse('''
        ( )  (*)  .   .   .
        (*) (*-)  .   -   .
        ( )  (*)  .   .   .
      '''),
  ),

  Level(
    id: 'mill_9',
    puzzle: GridFormat.parse('''
        (*)  (*-)  .   .   -   .
        (*)  (*)   .   .   .   .
      '''),
  ),

  Level(
    id: 'mill_10',
    puzzle: GridFormat.parse('''
        (*-) (*)  -    .    -    .
        (*)  (*)  .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_11',
    puzzle: GridFormat.parse('''
        (*)  (*-) .    .    -    .    .  (*-) (*)
        (*)  (*)  .    .    .    .    .  (*)  (*)
      '''),
  ),

  Level(
    id: 'mill_12',
    puzzle: GridFormat.parse('''
        . . . . .
        . - . . .
        . . - . .
        . . . - .
        . . . . .
      '''),
  ),

  Level(
    id: 'mill_13',
    puzzle: GridFormat.parse('''
        (*-) .    -    .    -  (*) .
        ( )  .    .   ( )   -   .  .
      '''),
  ),

  Level(
    id: 'mill_14',
    note: 'Mixing of colours',
    puzzle: GridFormat.parse('''
        (*)   ( )  (*)  (*)    .  . . .
        (*B-) (*)  ( )  (*-)  B-  . . -
        (*)   ( )  ( )  (*)    .  . . .
      '''),
  ),

  Level(
    id: 'mill_15',
    puzzle: GridFormat.parse('''
        ( )  ( )   (*)  ( )   .    .    .    .
        (-) (*G-)  (*)  (W-)  -   *G-   .   W-
        ( )  (*)   ( )  ( )   .    .    .    .
      '''),
  ),

  // TODODid up to here
  Level(
    id: 'mill_16',
    puzzle: GridFormat.parse('''
        (*)  (*)  (*)  .    .    .    .    .
        (*)  (*-) (*)  (*)  (*)  (*B-) (*)  (*B-)
        (*)  (*)  (*)  .    .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_17',
    puzzle: GridFormat.parse('''
        .    .    (*)  (*)  (*)  .    .    .    .    .    .
        .    (*-) .    .    (*)  (*)  (*)  (*)  (*B-) (*)  (*R-)
        .    .    .    .    (*)  (*)  (*)  .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_18',
    puzzle: GridFormat.parse('''
        (*)  (*)  .    .    .    .
        (*-) (*Y-) .    (*-) (*W-) .
        (*)  (*)  .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_19',
    puzzle: GridFormat.parse('''
        .    .    .    (*)  (*)  (*)
        (*-) .    (*Y-) (*-) (*W-) (*)
        .    .    .    (*)  (*)  (*)
      '''),
  ),

  Level(
    id: 'mill_20',
    puzzle: GridFormat.parse('''
        .    .    (*)  (*)  .    .    .    (*)
        (*)  (*G-) (*)  (*-) (*W-) .    (*)  (*)
        .    .    (*)  (*)  .    .    .    (*)
      '''),
  ),

  Level(
    id: 'mill_21',
    puzzle: GridFormat.parse('''
        -    .    .    .    .
        Y-   .    -    .    .
        -    .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_22',
    puzzle: GridFormat.parse('''
        (*Y-) .    Y-   .    Y-   .    .
        (*)  .    -    .    -    .    .
      '''),
  ),

  Level(
    id: 'mill_23',
    puzzle: GridFormat.parse('''
        (*)  (*)  (*)  .    .    .
        (*)  (*/) (*)  (*)  (*/) .
        (*)  (*)  (*)  .    .    .
      '''),
  ),

  Level(
    id: 'mill_24',
    puzzle: GridFormat.parse('''
        .    .    .    (*)  (*)  (*)
        .    /    .    (*)  (*/) (*)
        .    .    .    (*)  (*)  (*)
      '''),
  ),

  Level(
    id: 'mill_25',
    puzzle: GridFormat.parse('''
        (*)  (*)  (*)  .    .    .
        .    (*-) .    .    (*/) .
        (*)  (*)  (*)  .    .    .
      '''),
  ),

  Level(
    id: 'mill_26',
    puzzle: GridFormat.parse('''
        (*)  (*)  (*)  .    .    .
        (*)  (*/) (*)  (*)  (*/) .
        (*)  (*)  (*)  .    .    .
      '''),
  ),

  Level(
    id: 'mill_27',
    puzzle: GridFormat.parse('''
        (*)  (*)  (*)  .    .    .
        .    (*/) .    (*)  (*/) .
        (*)  (*)  (*)  .    .    .
      '''),
  ),

  Level(
    id: 'mill_28',
    puzzle: GridFormat.parse('''
        (*)  (*)  (*)  /    .
        (*)  (*)  (*)  .    .
        (*)  /    (*)  .    .
      '''),
  ),

  Level(
    id: 'mill_29',
    puzzle: GridFormat.parse('''
        (*)  (*)  .    .    .    .
        (*-) .    /    /    (-)  .
        (*)  (*)  .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_33',
    puzzle: GridFormat.parse('''
        /    .    .    .    .
        .    /    -    /    .
        ()   .    .    .    -
        ()   /    ()   .    .
      '''),
  ),

  Level(
    id: 'mill_34',
    puzzle: GridFormat.parse('''
        .    .    (*)  .    /
        ()   ()   .    .    .
        .    .    .    .    ()
        .    /    .    ()   ()
        /    .    ()   .    .
      '''),
  ),

  Level(
    id: 'mill_35',
    puzzle: GridFormat.parse('''
        .    ()   .    .    /    .
        .    (*-) .    .    .    .
        .    .    .    -    .    .
        /    .    .    .    .    /
        .    ()   (*-) .    ()   .
        .    .    .    ()   /    .
      '''),
  ),

  Level(
    id: 'mill_36',
    puzzle: GridFormat.parse('''
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

  Level(
    id: 'mill_bonus_1',
    puzzle: GridFormat.parse('''
        O-   .    O-   .    .    .
        -    .    .    -    .    .
        O-   .    O-   .    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_2',
    puzzle: GridFormat.parse('''
        (/)  ()   .    .    .
        .    ()   .    .    O/
        ()   /    .    O/   ()
      '''),
  ),

  Level(
    id: 'mill_bonus_3',
    puzzle: GridFormat.parse('''
        C/   O/   .    ()   .    C/   /
      '''),
  ),

  Level(
    id: 'mill_bonus_4',
    puzzle: GridFormat.parse('''
        .    .    .    .    ()   .    .    .    .    .
        .    /    O/   .    W/   /    .    B/   W/   ()
        .    .    .    .    ()   .    .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_5',
    puzzle: GridFormat.parse('''
        (*)  .    .    .    .    .    .    .    .    ()
        O/   .    C/   O/   /    .    C/   .    .    /
        (*)  .    .    .    .    .    .    .    .    ()
      '''),
  ),

  Level(
    id: 'mill_bonus_6',
    puzzle: GridFormat.parse('''
        ()   ()   ()   .    .    .
        .    /    .    /    .    .
        ()   ()   ()   .    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_7',
    puzzle: GridFormat.parse('''
        ()   ()   .    /    .    .
        ()   ()   ()   .    .    .
        .    ()   /    .    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_8',
    puzzle: GridFormat.parse('''
        ()   ()   .    .    .    .
        ()   /    .    .    /    ()
        ()   ()   ()   ()   .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_9',
    puzzle: GridFormat.parse('''
        ()   ()   .    .    .    .
        .    /    .    .    /    ()
        ()   ()   ()   ()   .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_10',
    puzzle: GridFormat.parse('''
        ()   ()   .    .    .    .
        .    /    .    .    /    ()
        ()   ()   ()   ()   .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_11',
    puzzle: GridFormat.parse('''
        /    ()   .    /    ()   ()
        .    .    .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_12',
    puzzle: GridFormat.parse('''
        ()   ()   .    -    .    /
        .    .    .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_13',
    puzzle: GridFormat.parse('''
        ()   ()   .    .    .    .
        .    /    .    /    .    .
        ()   ()   .    .    ()   .
      '''),
  ),

  Level(
    id: 'mill_bonus_14',
    puzzle: GridFormat.parse('''
        O-   ()   .    .    .    O-   .    .    O-
        .    -    .    -    ()   .    .    -    .
        .    .    .    /    /    .    .    .    O-
      '''),
  ),

  Level(
    id: 'mill_bonus_15',
    puzzle: GridFormat.parse('''
        .    .    /    .    .    ()   /    .    .    .
        .    .    .    .    .    ()   .    .    .    .
        .    .    .    /    .    .    .    /    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_16',
    puzzle: GridFormat.parse('''
        .    .    /    .    .    ()   /    .    .    .
        .    .    .    .    .    ()   .    .    .    .
        .    .    .    /    .    .    .    /    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_17',
    puzzle: GridFormat.parse('''
        .    .    .    .    O/   .
        C/   O/   .    C/   .    .
        .    .    ()   ()   .    .
        O/   .    /    .    .    O/
        .    .    .    .    O/   .
      '''),
  ),

  Level(
    id: 'mill_bonus_18',
    puzzle: GridFormat.parse('''
        .    .    .    .    .    .
        .    .    .    .    ()   .
        .    O-   ()   /    O-   .
        .    .    ()   /    .    .
        .    ()   .    .    O-   .
        .    .    .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_19',
    puzzle: GridFormat.parse('''
        .    .    .    .    .    .
        .    Po   .    Po   ()   Po
        .    O-   /    /    O-   .
        .    .    /    /    .    .
        .    ()   O-   Po   O-   Po
        .    .    .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_20',
    puzzle: GridFormat.parse('''
        .    /    .    .    O/   .
        .    .    O/   .    O/   O/
        .    .    .    .    .    .
        O/   .    .    .    O/   .
        .    O/   .    .    .    /
      '''),
  ),

  Level(
    id: 'mill_bonus_21',
    puzzle: GridFormat.parse('''
        .    .    .
        O/   .    .
        .    .    O/
        .    O/   .
        O/   .    .
        .    .    O/
      '''),
  ),

  Level(
    id: 'mill_bonus_22',
    puzzle: GridFormat.parse('''
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

  Level(
    id: 'mill_bonus_23',
    puzzle: GridFormat.parse('''
        .    .    .    -    O/   .    .
        .    .    .    .    .    .    .
        .    .    .    O-   .    .    -
        .    .    .    .    .    .    .
        O-   .    .    .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_24',
    puzzle: GridFormat.parse('''
        O5   .    R2   .    R2   .
        .    .    .    .    .    .
        .    .    .    .    .    R2
        .    R1   .    .    .    .
        .    .    .    .    .    O5
      '''),
  ),

  Level(
    id: 'mill_bonus_25',
    puzzle: GridFormat.parse('''
        .    .    .    .    .
        .    O-   .    O-   .
        .    .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_26',
    puzzle: GridFormat.parse('''
        .    O2   .    O2   .
        .    O-   O2   O-   .
        .    .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_27',
    puzzle: GridFormat.parse('''
        .    .    .    .    O-   .
        .    O-   .    .    O4   .
        .    .    .    .    .    .
      '''),
  ),

  Level(
    id: 'mill_bonus_28',
    puzzle: GridFormat.parse('''
        .    .    .    .    /    .
        .    /    .    /    .    .
        .    .    .    .    /    .
      '''),
  ),

  Level(
    id: 'mill_bonus_29',
    puzzle: GridFormat.parse('''
        .    /    .    .    .    .
        .    .    ()   .    /    .
        .    .    .    .    /    .
      '''),
  ),

  Level(
    id: 'mill_bonus_30',
    puzzle: GridFormat.parse('''
        ()   /    .    .    .    ()
        O6   .    .    .    .    O6
        ()   .    .    .    /    ()
      '''),
  ),

  Level(
    id: 'mill_bonus_31',
    puzzle: GridFormat.parse('''
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

  Level(
    id: 'mill_bonus_32',
    puzzle: GridFormat.parse('''
        .    O-   .
        .    O4   .
        .    O-   .
      '''),
  ),

  Level(
    id: 'mill_bonus_33',
    puzzle: GridFormat.parse('''
        .    .    .    .    P-   .
        O4   O-   .    .    .    .
        .    O-   .    .    /    .
      '''),
  ),

  Level(
    id: 'mill_bonus_34',
    puzzle: GridFormat.parse('''
        .    O-   .    .    .
        W4   P-   .    P-   .
        O-   .    .    /    .
        .    .    .    .    .
      '''),
  ),
];
