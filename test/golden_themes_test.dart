import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/grid_point.dart';
import 'package:grids/providers/puzzle_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:grids/ui/grid_widget.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Generate Golden theme screenshots', tags: ['golden', 'mac'], (
    tester,
  ) async {
    // Set a consistent large window size for taking screenshots
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 2.0;

    final themeProvider = ThemeProvider();

    for (final theme in themeProvider.availableThemes) {
      themeProvider.setTheme(theme);
      final puzzleProvider = PuzzleProvider()
        // Let's toggle some cells so we can see lit vs unlit
        ..dragToggleCell(const GridPoint(0, 0))
        ..dragToggleCell(const GridPoint(1, 1))
        ..endDrag()
        // Force validation to show error highlights or solved states
        ..checkAnswer();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: puzzleProvider),
            ChangeNotifierProvider.value(value: themeProvider),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: theme.backgroundColor,
              body: const Center(
                child: SizedBox(
                  width: 500,
                  height: 500,
                  child: GridWidget(),
                ),
              ),
            ),
          ),
        ),
      );

      // Allow animations to settle
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      final themeFilename = theme.name.toLowerCase().replaceAll(' ', '_');
      await expectLater(
        find.byType(GridWidget),
        matchesGoldenFile('goldens/theme_$themeFilename.png'),
      );
    }
  });
}
