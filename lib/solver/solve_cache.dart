import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/puzzle.dart';
import 'package:grids/engine/puzzle_canonical.dart';
import 'package:grids/engine/solver.dart';

/// Cache for puzzle solve results, stored as per-puzzle JSON files on disk.
///
/// Each puzzle is keyed by its canonical signature (rotation/color invariant).
/// Files are named by SHA-1 hash of the key and stored in [cacheDir].
class SolveCache {
  SolveCache({this.cacheDir = '.cache/solve'});

  /// Directory where cache files are stored.
  final String cacheDir;

  /// Bump this when adding new cached metrics to force a re-solve.
  static const version = 1;

  /// Solves a puzzle, using the cache if available.
  /// Returns the [SolveResult] and the list of [Puzzle] solutions.
  ({SolveResult result, List<Puzzle> solutions}) solve(
    PuzzleSolver solver,
    Puzzle puzzle, {
    required bool analyze,
  }) {
    final key = PuzzleCanonical.signature(puzzle);
    final cached = _loadEntry(key);

    if (cached != null) {
      final solutionCount = cached['solutionCount'] as int;
      final histogramRaw = cached['errorHistogram'] as Map<String, dynamic>;
      final histogram = histogramRaw.map(
        (k, v) => MapEntry(int.parse(k), v as int),
      );
      final maskStrings = (cached['solutionMasks'] as List).cast<String>();
      final solutions = maskStrings.map((mask) {
        final state = GridFormat.parseMask(mask);
        return puzzle.copyWith(state: state);
      }).toList();

      assert(solutions.length == solutionCount, 'Cache mismatch');
      return (
        result: SolveResult(solutions, errorHistogram: histogram),
        solutions: solutions,
      );
    }

    // Cache miss — solve and store.
    final result = solver.solve(puzzle, analyze: analyze);
    final solutions = result.solutions;

    _saveEntry(key, {
      'solutionCount': solutions.length,
      'errorHistogram': result.errorHistogram.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
      'solutionMasks': solutions.map(GridFormat.toMaskString).toList(),
    });

    return (result: result, solutions: solutions);
  }

  /// Returns a stable SHA-1 hash of [s] as a hex string.
  static String hashKey(String s) => sha1.convert(utf8.encode(s)).toString();

  /// Loads a cached entry for [key]. Returns null on miss or version mismatch.
  Map<String, dynamic>? _loadEntry(String key) {
    try {
      final file = File('$cacheDir/${hashKey(key)}.json');
      if (!file.existsSync()) return null;
      final json = jsonDecode(file.readAsStringSync());
      if (json is! Map<String, dynamic>) return null;
      if (json['version'] != version) return null;
      if (json['key'] != key) return null;
      return json;
    } on Object catch (_) {
      return null;
    }
  }

  /// Saves a cache entry for [key] to disk.
  void _saveEntry(String key, Map<String, dynamic> data) {
    final dir = Directory(cacheDir);
    if (!dir.existsSync()) dir.createSync(recursive: true);
    final file = File('$cacheDir/${hashKey(key)}.json');
    const encoder = JsonEncoder.withIndent('  ');
    file.writeAsStringSync(
      encoder.convert({'version': version, 'key': key, ...data}),
    );
  }
}
