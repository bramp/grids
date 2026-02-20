import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/cell.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/engine/grid_state.dart';

void main() {
  group('GridState Base Functionality', () {
    test('Initialization is purely unlit', () {
      final state = GridState.empty(width: 3, height: 3);
      expect(state.isLit(const GridPoint(0, 0)), isFalse);
      expect(state.isLit(const GridPoint(2, 2)), isFalse);
      expect(
        state.isLit(const GridPoint(3, 3)),
        isFalse,
      ); // OOB safely returns false
    });

    test('toggle flips the state immutably', () {
      final state1 = GridState.empty(width: 3, height: 3);
      final state2 = state1.toggle(const GridPoint(1, 1));

      expect(state1.isLit(const GridPoint(1, 1)), isFalse);
      expect(state2.isLit(const GridPoint(1, 1)), isTrue);

      final state3 = state2.toggle(const GridPoint(1, 1));
      expect(state3.isLit(const GridPoint(1, 1)), isFalse);
    });

    test('extractContiguousAreas returns single area for blank grid', () {
      final state = GridState.empty(width: 3, height: 3);
      final areas = state.extractContiguousAreas();

      expect(areas.length, 1);
      expect(areas.first.length, 9);
    });

    test('extractContiguousAreas works with a checkerboard split', () {
      // 0 1 0
      // 1 1 1
      // 0 1 0
      final state = GridState.empty(width: 3, height: 3)
          .toggle(const GridPoint(1, 0))
          .toggle(const GridPoint(0, 1))
          .toggle(const GridPoint(1, 1))
          .toggle(const GridPoint(2, 1))
          .toggle(const GridPoint(1, 2));

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
      final state = GridState.empty(width: 2, height: 2)
          .withMechanic(const GridPoint(0, 0), const DiamondCell(CellColor.red))
          .withMechanic(const GridPoint(1, 1), const NumberCell(3));

      expect(state.getMechanic(const GridPoint(0, 0)), isA<DiamondCell>());
      expect(state.getMechanic(const GridPoint(1, 1)), isA<NumberCell>());
      expect(state.getMechanic(const GridPoint(0, 1)), isA<BlankCell>());
    });
  });
}
