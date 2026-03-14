import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:grids/services/analytics_service.dart';
import 'package:grids/services/consent_service.dart';
import 'package:grids/ui/grid_widget.dart';
import 'package:grids/ui/themes/puzzle_theme.dart';
import 'package:grids_engine/grid_format.dart';
import 'package:provider/provider.dart';

import 'mocks/mock_progress_service.dart';

void main() {
  testWidgets('Generate Golden theme screenshots', tags: ['golden', 'mac'], (
    tester,
  ) async {
    // Set a standard Android 1080p landscape resolution (1920x1080)
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 3; // Standard 3.0 density for 1080p

    final progressService = await MockProgressService.init();
    final analyticsService = AnalyticsService(
      ConsentService(progressService.preferencesService),
    );
    final themeProvider = ThemeProvider();

    for (final theme in themeProvider.availableThemes) {
      themeProvider.setTheme(theme);

      // --- Page 1: Main Demo ---
      final demoGrid = GridFormat.parse('''
        1   R2  B3  Y4  P5   W1   C2   G-1
        o   Ro  Bo  Yo  Po   Wo   Co   B-2
        F0  F1  F2  F3  F4   F1*  F4*  Y-3
        -   R-  B-  Y-  P-   W-   C-   P-4
        /   R/  B/  Y/  P/   W/   C/   C-5
       (.) (1)  1* (R-) R-* (F2)  F2*  W-1
      ''');

      final levelProvider = LevelProvider(progressService, analyticsService)
        ..loadCustomPuzzle(demoGrid, id: 'demo')
        ..checkAnswer();

      await _pumpAndMatch(
        tester,
        levelProvider,
        themeProvider,
        theme,
        'main',
      );

      // --- Page 2: Dice Dots Gallery ---
      // 16 columns, 10 rows. Fits a 16:9 landscape screen perfectly
      // with square cells.
      final galleryGrid = GridFormat.parse('''
         1   R1  B1  Y1  P1  W1  C1  G1  -1  R-1 B-1 Y-1 P-1 W-1 C-1 G-1
         2   R2  B2  Y2  P2  W2  C2  G2  -2  R-2 B-2 Y-2 P-2 W-2 C-2 G-2
         3   R3  B3  Y3  P3  W3  C3  G3  -3  R-3 B-3 Y-3 P-3 W-3 C-3 G-3
         4   R4  B4  Y4  P4  W4  C4  G4  -4  R-4 B-4 Y-4 P-4 W-4 C-4 G-4
         5   R5  B5  Y5  P5  W5  C5  G5  -5  R-5 B-5 Y-5 P-5 W-5 C-5 G-5
         6   R6  B6  Y6  P6  W6  C6  G6  -6  R-6 B-6 Y-6 P-6 W-6 C-6 G-6
         7   R7  B7  Y7  P7  W7  C7  G7  -7  R-7 B-7 Y-7 P-7 W-7 C-7 G-7
         8   R8  B8  Y8  P8  W8  C8  G8  -8  R-8 B-8 Y-8 P-8 W-8 C-8 G-8
         9   R9  B9  Y9  P9  W9  C9  G9  -9  R-9 B-9 Y-9 P-9 W-9 C-9 G-9
         1*  R2* B3* Y4* P5* W6* C7* G8*  -   R-  B/  Y/  (1) (R2) (B3) (Y4)
      ''');

      levelProvider.loadCustomPuzzle(galleryGrid, id: 'gallery');
      // we just want to see the dots clearly.
      // But let's toggle some cells to see "lit" states as defined in ASCII.

      await _pumpAndMatch(
        tester,
        levelProvider,
        themeProvider,
        theme,
        'gallery',
        physicalSize: const Size(4320, 2700),
        dpr: 3,
      );
    }
  });
}

Future<void> _pumpAndMatch(
  WidgetTester tester,
  LevelProvider levelProvider,
  ThemeProvider themeProvider,
  PuzzleTheme theme,
  String suffix, {
  Size? physicalSize,
  double? dpr,
}) async {
  // Use custom size if provided, otherwise default to context size
  final originalSize = tester.view.physicalSize;
  final originalDpr = tester.view.devicePixelRatio;

  if (physicalSize != null) tester.view.physicalSize = physicalSize;
  if (dpr != null) tester.view.devicePixelRatio = dpr;

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: levelProvider),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
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
  await tester.pump(const Duration(milliseconds: 100));

  final themeFilename = theme.name.toLowerCase().replaceAll(' ', '_');
  await expectLater(
    find.byType(GridWidget),
    matchesGoldenFile('goldens/theme_${themeFilename}_$suffix.png'),
  );

  // Fast forward animation timer
  await tester.pumpAndSettle(const Duration(seconds: 3));

  // Restore original view state
  tester.view.physicalSize = originalSize;
  tester.view.devicePixelRatio = originalDpr;
}
