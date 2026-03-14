import 'package:grids_engine/grid_format.dart';
import 'package:grids_engine/level.dart';

final waterfall = [
  Level(
    id: 'waterfall_1',
    puzzle: GridFormat.parse('''
        (*Y) . Y . (*Y)
        . . Y . Y
        Y Y . Y Y
        Y . Y . .
        (*Y) . Y . (*Y)
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * * . *
          . . . . *
          . * * * .
          * . . . .
          * . * * *
        '''),
    ],
  ),

  Level(
    id: 'waterfall_2',
    puzzle: GridFormat.parse('''
        Y4 . (P4) W4 .
        W6 . . . .
        . . . . .
        . . . . .
        . . . . .
        . P5 Y5 . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . * .
          . * . * *
          . * . . *
          . . * * .
          . * * . .
          . * . . *
        '''),
    ],
  ),

  Level(
    id: 'waterfall_3',
    puzzle: GridFormat.parse('''
        F0 . F0 . . F0
        . (*F4) . . (F2) .
        F0 . F0 F0 . .
        . . F0 F0 . F0
        . (F2) . . (*F4) .
        F0 . . F0 . F0
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * . * * .
          * * * . . *
          . * . * . *
          * . * . * .
          * . . * * *
          . * * . * .
        '''),
    ],
  ),

  Level(
    id: 'waterfall_4',
    puzzle: GridFormat.parse('''
        . . . . . . . .
        . (*) (*) (*P-) . . . .
        . . ( ) . Y- . . .
        . . ( ) (*) . P- . .
        . . ( ) (*) ( ) ( ) (Y-) .
        . . . (*) . . . .
        . . . . . . . .
        . . . . . . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . . * . . .
          . * * * . * . .
          . * . . . . * .
          * * . * * * . *
          . * . * . . . .
          . . * * . * * *
          . . . * . * . .
          . . . . * * . .
        '''),
    ],
  ),

  // TODO(bramp): waterfall 5-11 are walking puzzles
  Level(
    id: 'waterfall_12',
    puzzle: GridFormat.parse('''
        (C) C . . .
        . Y Y (*W) .
        . . (*Y) Y .
        . (*Y) Y W .
        (*C) C . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . . . . .
          * * . * .
          * . * * .
          * * . * .
          * * . . .
        '''),
    ],
  ),
  Level(
    id: 'waterfall_13',
    puzzle: GridFormat.parse('''
        B (*) (Y) . W (*C) (B)
        . (Y) Y P . . C
        . . P (*Y) . . .
        . (W) . . . . .
        C . . . . (*) (Y)
        (*B) (C) . . . Y B
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          * * . . . * .
          * . * * . * .
          * . * * . * .
          * . . . . * .
          * * * * * * .
          * . . . . . .
        '''),
    ],
  ),
];
