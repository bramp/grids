import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/providers/level_provider.dart';
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

      final demoGrid = GridFormat.parse('''
        1   R2  B3  Y4  P5   W1   C2
        o   Ro  Bo  Yo  Po   Wo   Co
        F0  F1  F2  F3  F4   F1*  F4*
        -   R-  B-  Y-  P-   W-   C-
        /   R/  B/  Y/  P/   W/   C/
       (.) (1)  1* (R-) R-* (F2)  F2*
      ''');

      final puzzleProvider = LevelProvider()
        ..loadCustomPuzzle(demoGrid)
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
