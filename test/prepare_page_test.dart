import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wash_ed_app/views/prepare/prepare_page.dart';

void main() {
  testWidgets('PreparePage renders all main sections',  (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const PreparePage(),
      ),
    );

    // Check for the presence of the main sections
    expect(find.text('Flood\nGuidance'), findsOneWidget);
    expect(find.text('Call for Help'), findsOneWidget);
    expect(find.text('Quick Safety Steps'), findsOneWidget);
    expect(find.text('Checklist'), findsOneWidget);

    expect (find.textContaining('Tell a trusted adult'), findsOneWidget);
    expect(find.text('Water and snacks for 3 days'), findsOneWidget);

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();
  
    final checklistItem = find.text('Water and snacks for 3 days');
    CheckboxListTile checklistTile = tester.widget(find.byType(CheckboxListTile).first);
    expect(checklistTile.value, false);

    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pumpAndSettle();
    checklistTile = tester.widget(find.byType(CheckboxListTile).first);
    expect(checklistTile.value, true);

    final textWidget = tester.widget<Text>(checklistItem);
    expect(textWidget.style?.decoration, TextDecoration.lineThrough);
  });
}