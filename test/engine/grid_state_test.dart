import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';

void main() {
  group('GridState Base Functionality', () {
    test('Initialization is purely unlit', () {
      final state = GridState.empty(width: 3, height: 3);
      expect(state.isLit(state.pointAt(0, 0)), isFalse);
      expect(state.isLit(state.pointAt(2, 2)), isFalse);
    });

    test('toggle flips the state immutably', () {
      final state1 = GridState.empty(width: 3, height: 3);
      final pt = state1.pointAt(1, 1);
      final state2 = state1.toggle(pt);

      expect(state1.isLit(pt), isFalse);
      expect(state2.isLit(pt), isTrue);

      final state3 = state2.toggle(pt);
      expect(state3.isLit(pt), isFalse);
    });

    test('extractContiguousAreas returns single area for blank grid', () {
      final state = GridState.empty(width: 3, height: 3);
      final areas = state.extractContiguousAreas();

      expect(areas.length, 1);
      expect(areas.first.length, 9);
      expect(areas.first.every((pt) => pt >= 0 && pt < 9), isTrue);
    });

    test('extractContiguousAreas works with a checkerboard split', () {
      // 0 1 0
      // 1 1 1
      // 0 1 0
      final state = GridState.empty(width: 3, height: 3)
          .toggle(const GridPoint(1)) // (1, 0)
          .toggle(const GridPoint(3)) // (0, 1)
          .toggle(const GridPoint(4)) // (1, 1)
          .toggle(const GridPoint(5)) // (2, 1)
          .toggle(const GridPoint(7)); // (1, 2)

      final areas = state.extractContiguousAreas();

      // Should have 1 lit area (the cross of 5 cells)
      // and 4 separate unlit areas (the 4 corners)
      expect(areas.length, 5);

      final litAreas = areas.where((a) => state.isLit(a.first)).toList();
      final unlitAreas = areas.where((a) => !state.isLit(a.first)).toList();

      expect(litAreas.length, 1);
      expect(litAreas.first.length, 5);

      expect(unlitAreas.length, 4);
      expect(unlitAreas.every((a) => a.length == 1), isTrue);
    });

    test('withMechanic accurately configures and retains cells', () {
      final state = GridState.empty(width: 2, height: 2);
      final p00 = state.pointAt(0, 0);
      final p11 = state.pointAt(1, 1);
      final p01 = state.pointAt(0, 1);

      final state2 = state
          .withMechanic(p00, const DiamondCell(CellColor.red))
          .withMechanic(p11, const NumberCell(3));

      expect(state2.getMechanic(p00), isA<DiamondCell>());
      expect(state2.getMechanic(p11), isA<NumberCell>());
      expect(state2.getMechanic(p01), isA<BlankCell>());
    });
  });

  group('GridFormat.parse (Colored Symbols)', () {
    test('supports R, K, Y, B prefixes for numbers', () {
      final grid = GridFormat.parse(
        '''
        R1 K2
        Y3 B4
      ''',
      );

      final n1 = grid.getMechanic(grid.pointAt(0, 0)) as NumberCell;
      final n2 = grid.getMechanic(grid.pointAt(1, 0)) as NumberCell;
      final n3 = grid.getMechanic(grid.pointAt(0, 1)) as NumberCell;
      final n4 = grid.getMechanic(grid.pointAt(1, 1)) as NumberCell;

      expect(n1.color, CellColor.red);
      expect(n2.color, CellColor.black);
      expect(n3.color, CellColor.yellow);
      expect(n4.color, CellColor.blue);
    });
  });
}
