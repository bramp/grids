// ignore_for_file: avoid_print, prefer_final_locals // CLI tool.
// NOTE: This generator is a work in progress.
import 'dart:math';

import 'package:args/args.dart';

import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid.dart';

import 'package:grids/engine/grid_state.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/puzzle_validator.dart';

import 'package:grids/engine/solver.dart';

void main(List<String> args) {
  final parser = ArgParser()
    ..addOption('width', abbr: 'w', defaultsTo: '4')
    ..addOption('height', abbr: 'h', defaultsTo: '4')
    ..addMultiOption(
      'mechanics',
      abbr: 'm',
      allowed: ['number', 'diamond', 'flower'],
      defaultsTo: ['number'],
    )
    ..addOption('seed', abbr: 's')
    ..addOption('max-solutions', abbr: 'x', defaultsTo: '16');

  final results = parser.parse(args);
  final width = int.parse(results['width'] as String);
  final height = int.parse(results['height'] as String);
  final allowedMechanics = results['mechanics'] as List<String>;
  final seed = results['seed'] != null
      ? int.parse(results['seed'] as String)
      : Random().nextInt(1000000);
  final maxSolutions = int.parse(results['max-solutions'] as String);

  print('Generating $width x $height puzzle (seed: $seed)...');
  final random = Random(seed);

  final puzzle = generate(
    width: width,
    height: height,
    allowedMechanics: allowedMechanics,
    maxSolutions: maxSolutions,
    random: random,
  );

  print('\nGenerated Puzzle:');
  print(puzzle.toAsciiString());

  final solver = PuzzleSolver();
  final result = solver.solve(puzzle, analyze: true);

  print('Solutions found: ${result.solutions.length}');
  if (result.solutions.isEmpty) {
    print(
      'WARNING: No solutions found for the generated target. '
      'This indicates a generator bug.',
    );
  }
  print('Average Error Cells: ${result.averageErrors.toStringAsFixed(2)}');
  print('Median Error Cells: ${result.medianErrors.toStringAsFixed(2)}');
}

Puzzle generate({
  required int width,
  required int height,
  required List<String> allowedMechanics,
  required int maxSolutions,
  required Random random,
}) {
  final solver = PuzzleSolver();

  while (true) {
    final puzzle = _attemptGenerate(
      width: width,
      height: height,
      allowedMechanics: allowedMechanics,
      random: random,
    );

    final result = solver.solve(puzzle);
    if (result.solutions.isNotEmpty &&
        result.solutions.length <= maxSolutions) {
      return puzzle;
    }
  }
}

Puzzle _attemptGenerate({
  required int width,
  required int height,
  required List<String> allowedMechanics,
  required Random random,
}) {
  // 1. Generate random solution bits
  final size = width * height;
  var solutionBits = BigInt.zero;
  for (var i = 0; i < size; i++) {
    if (random.nextBool()) {
      solutionBits |= BigInt.one << i;
    }
  }

  var basePuzzle = Puzzle(
    grid: Grid.empty(width: width, height: height),
    state: GridState(width: width, height: height, bits: solutionBits),
  );

  final areas = basePuzzle.extractContiguousAreas();
  final newMechanics = List<Cell>.from(basePuzzle.mechanics);
  var nextColorIndex = 0;

  // 2. Place random mechanics based on the solution
  for (final area in areas) {
    if (area.isEmpty) continue;

    final roll = random.nextDouble();
    if (roll < 0.6) {
      // 60% chance to put a mechanic in this area
      final typeRoll = random.nextInt(allowedMechanics.length);
      final type = allowedMechanics[typeRoll];

      if (type == 'number') {
        final pt = area[random.nextInt(area.length)];
        final isLit = basePuzzle.isLit(pt);
        newMechanics[pt] = NumberCell(area.length).lock(isLit: isLit);
      } else if (type == 'diamond' && area.length >= 2) {
        final pts = area.toList()..shuffle(random);
        final color =
            CellColor.values[nextColorIndex % CellColor.values.length];
        nextColorIndex++;
        newMechanics[pts[0]] = DiamondCell(
          color,
        ).lock(isLit: basePuzzle.isLit(pts[0]));
        newMechanics[pts[1]] = DiamondCell(
          color,
        ).lock(isLit: basePuzzle.isLit(pts[1]));
      } else if (type == 'flower') {
        final pt = area[random.nextInt(area.length)];
        final isLit = basePuzzle.isLit(pt);
        final (x, y) = basePuzzle.xy(pt);
        var neighborCount = 0;
        final neighborOffsets = [(-1, 0), (1, 0), (0, -1), (0, 1)];
        for (final offset in neighborOffsets) {
          final nx = x + offset.$1;
          final ny = y + offset.$2;
          if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
            if (basePuzzle.isLit(basePuzzle.pointAt(nx, ny)) == isLit) {
              neighborCount++;
            }
          }
        }
        newMechanics[pt] = FlowerCell(neighborCount).lock(isLit: isLit);
      }
    }
  }

  // Use a state for the final puzzle that starts with only locked cells set
  var initialBits = BigInt.zero;
  for (var i = 0; i < size; i++) {
    final cell = newMechanics[i];
    if (cell.isLocked && (cell.lockedLit ?? false)) {
      initialBits |= BigInt.one << i;
    }
  }

  final initialPuzzle = Puzzle(
    grid: Grid(width: width, height: height, mechanics: newMechanics),
    state: GridState(width: width, height: height, bits: initialBits),
  );

  // 3. Verify the target solution is actually valid
  final solutionPuzzle = initialPuzzle.copyWith(
    state: GridState(width: width, height: height, bits: solutionBits),
  );

  final validator = PuzzleValidator().filter(solutionPuzzle);
  final validation = validator.validate(solutionPuzzle);
  if (!validation.isValid) {
    print('Error: Target solution is INVALID according to mechanics!');
    for (final error in validation.errors) {
      print('  at ${error.point}: ${error.message}');
    }
    // Return early if we generated an invalid puzzle
    return initialPuzzle;
  }

  // 4. Return the generated candidate
  return initialPuzzle;
}
