import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grids/ui/screens/privacy_policy_screen.dart';

void main() {
  testWidgets('PrivacyPolicyScreen renders key sections', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PrivacyPolicyScreen()),
    );

    // Wait for rootBundle.loadString to complete.
    await tester.pumpAndSettle();

    // HtmlWidget renders as RichText, so we need findRichText: true.
    expect(find.text('Privacy Policy'), findsWidgets); // app bar title
    expect(
      find.textContaining('What We Collect', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('in Charge', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Sharing', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('How Long', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Kids', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Future Updates', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Say Hi', findRichText: true),
      findsOneWidget,
    );
  });
}
