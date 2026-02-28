import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_shape.dart';
import 'package:grids/engine/puzzle.dart';

void main() {
  group('GridShape', () {
    test('signature is canonical and stable', () {
      const shape1 = GridShape({(0, 0), (1, 0), (0, 1)});
      const shape2 = GridShape({(0, 1), (0, 0), (1, 0)}); // Reordered
      expect(shape1.signature, shape2.signature);
      expect(shape1.signature, '0,0;0,1;1,0');
      expect(shape1, shape2);
    });

    test('rotations are calculated correctly', () {
      // Horizontal 2-cell: (0,0), (1,0)
      const shape = GridShape({(0, 0), (1, 0)});
      final rotations = shape.rotations;

      expect(rotations.length, 4);
      // Original: (0,0), (1,0)
      expect(rotations[0].offsets, {(0, 0), (1, 0)});
      // 90 deg CW: (x,y) -> (-y,x) => (0,0), (0,1)
      expect(rotations[1].offsets, {(0, 0), (0, 1)});
      // 180 deg: (0,0), (-1,0)
      expect(rotations[2].offsets, {(0, 0), (-1, 0)});
      // 270 deg: (0,0), (0,-1)
      expect(rotations[3].offsets, {(0, 0), (0, -1)});

      // All signatures should be distinct for this non-symmetrical shape
      final sigs = rotations.map((r) => r.signature).toSet();
      expect(sigs.length, 4);
    });

    test('hashCode and operator == work via signature', () {
      const shape1 = GridShape({(0, 0), (1, 0)});
      const shape2 = GridShape({(1, 0), (0, 0)});
      const shape3 = GridShape({(0, 0), (0, 1)});

      expect(shape1, shape2);
      expect(shape1.hashCode, shape2.hashCode);
      expect(shape1, isNot(shape3));
    });
  });

  group('GridArea', () {
    test('toShape computes relative offsets', () {
      final puzzle = Puzzle.empty(width: 5, height: 5);
      const area = GridArea([
        GridPoint(0), // (0,0)
        GridPoint(1), // (1,0)
        GridPoint(5), // (0,1)
      ]);

      // Relative to (0,0)
      final shape1 = area.toShape(const GridPoint(0), puzzle);
      expect(shape1.offsets, {(0, 0), (1, 0), (0, 1)});

      // Relative to (1,0)
      final shape2 = area.toShape(const GridPoint(1), puzzle);
      expect(shape2.offsets, {(-1, 0), (0, 0), (-1, 1)});
    });

    test('contains point', () {
      const area = GridArea([GridPoint(1), GridPoint(2)]);
      expect(area.contains(const GridPoint(1)), isTrue);
      expect(area.contains(const GridPoint(3)), isFalse);
    });
  });
}
