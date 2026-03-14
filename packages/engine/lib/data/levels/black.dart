import 'package:grids_engine/grid_format.dart';
import 'package:grids_engine/level.dart';

final black = [
  Level(
    id: 'black_1',
    puzzle: GridFormat.parse('''
        . . W .
        . . . Y-
        Y4 . (*F0) .
        . (*F0) . .
        . Y- . W
        . . . .
        . . . .
        Y8 . . .
        . . . .
        . . . .
      '''),
    knownSolutions: [
      GridFormat.parseMask('''
          . * . *
          * * . .
          * . * .
          . * . .
          . . * .
          * . * *
          . . * .
          * . * .
          * * . *
          * * * *
        '''),
    ],
  ),

  // TODO(bramp): Skipped level 2-9 because there were progressive puzzles.
];
