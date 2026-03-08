import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grids/engine/grid_format.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:grids/ui/grid_widget.dart';
import 'package:provider/provider.dart';
import 'mocks/mock_progress_service.dart';

void main() {
  testWidgets('Generate Golden theme screenshots', tags: ['golden', 'mac'], (
    tester,
  ) async {
    // Set a standard Android 1080p landscape resolution (1920x1080)
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 3.0; // Standard 3.0 density for 1080p

    final progressService = await MockProgressService.init();
    final themeProvider = ThemeProvider();

    for (final theme in themeProvider.availableThemes) {
      themeProvider.setTheme(theme);

      final demoGrid = GridFormat.parse('''
        1   R2  B3  Y4  P5   W1   C2   G-1
        o   Ro  Bo  Yo  Po   Wo   Co   B-2
        F0  F1  F2  F3  F4   F1*  F4*  Y-3
        -   R-  B-  Y-  P-   W-   C-   P-4
        /   R/  B/  Y/  P/   W/   C/   C-5
       (.) (1)  1* (R-) R-* (F2)  F2*  W-1
      ''');

      final puzzleProvider = LevelProvider(progressService)
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
                child: Padding(
                  padding: EdgeInsets.all(16),
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
