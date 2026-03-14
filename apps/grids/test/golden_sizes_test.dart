import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grids/providers/level_provider.dart';
import 'package:grids/providers/theme_provider.dart';
import 'package:grids/services/analytics_service.dart';
import 'package:grids/services/consent_service.dart';
import 'package:grids/ui/grid_widget.dart';
import 'package:grids_engine/grid_format.dart';
import 'package:provider/provider.dart';

import 'mocks/mock_progress_service.dart';

void main() {
  testWidgets('Golden grid sizes', tags: ['golden', 'mac'], (tester) async {
    tester.view.physicalSize = const Size(1080, 1080);
    tester.view.devicePixelRatio = 2;

    final progressService = await MockProgressService.init();
    final analyticsService = AnalyticsService(
      ConsentService(progressService.preferencesService),
    );
    final themeProvider = ThemeProvider();
    final levelProvider = LevelProvider(progressService, analyticsService)
      ..loadCustomPuzzle(
        GridFormat.parse('1'),
        id: 'size_1x1',
      );
    await _pumpAndMatch(
      tester,
      levelProvider,
      themeProvider,
      '1x1',
    );

    // 2x2
    levelProvider.loadCustomPuzzle(
      GridFormat.parse('''
        1 2
        3 4
      '''),
      id: 'size_2x2',
    );
    await _pumpAndMatch(
      tester,
      levelProvider,
      themeProvider,
      '2x2',
    );

    // 3x3
    levelProvider.loadCustomPuzzle(
      GridFormat.parse('''
        1 2 3
        4 5 6
        7 8 9
      '''),
      id: 'size_3x3',
    );
    await _pumpAndMatch(
      tester,
      levelProvider,
      themeProvider,
      '3x3',
    );

    // 4x4
    levelProvider.loadCustomPuzzle(
      GridFormat.parse('''
        1  2  3  4
        5  6  7  8
        9  R1 B2 Y3
        P4 W5 C6 G7
      '''),
      id: 'size_4x4',
    );
    await _pumpAndMatch(
      tester,
      levelProvider,
      themeProvider,
      '4x4',
    );

    // 8x8
    levelProvider.loadCustomPuzzle(
      GridFormat.parse('''
        1  2  3  4  5  6  7  8
        R1 R2 R3 R4 R5 R6 R7 R8
        B1 B2 B3 B4 B5 B6 B7 B8
        Y1 Y2 Y3 Y4 Y5 Y6 Y7 Y8
        P1 P2 P3 P4 P5 P6 P7 P8
        W1 W2 W3 W4 W5 W6 W7 W8
        C1 C2 C3 C4 C5 C6 C7 C8
        G1 G2 G3 G4 G5 G6 G7 G8
      '''),
      id: 'size_8x8',
    );
    await _pumpAndMatch(
      tester,
      levelProvider,
      themeProvider,
      '8x8',
    );
  });
}

Future<void> _pumpAndMatch(
  WidgetTester tester,
  LevelProvider levelProvider,
  ThemeProvider themeProvider,
  String sizeName,
) async {
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
          backgroundColor: themeProvider.activeTheme.backgroundColor,
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

  await tester.pump(const Duration(milliseconds: 100));

  await expectLater(
    find.byType(GridWidget),
    matchesGoldenFile('goldens/size_$sizeName.png'),
  );

  await tester.pumpAndSettle(const Duration(seconds: 3));
}
