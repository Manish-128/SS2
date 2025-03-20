import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shield_sister_2/new_pages/main_manual_page.dart'; // Replace with actual import path

void main() {
  testWidgets('MainManualPage UI Test', (WidgetTester tester) async {
    // Build our MainManualPage widget
    await tester.pumpWidget(
      const MaterialApp(
        home: MainManualPage(),
      ),
    );

    // Verify if 'Safety Manuals' title is present
    expect(find.text('Safety Manuals'), findsOneWidget);

    // Check if default selected section is 'How to Access'
    expect(find.text('What is a SOS?'), findsOneWidget);

    // Tap on 'Safety Blogs' button
    await tester.tap(find.text('Safety Blogs'));
    await tester.pump();

    // Verify if 'Safety Blogs' content is displayed
    expect(find.text("Women's safety at workplace"), findsOneWidget);

    // Tap on 'Quick Manuals' button
    await tester.tap(find.text('Quick Manuals'));
    await tester.pump();

    // Verify if 'Quick Manuals' content is displayed
    expect(find.text('8 Self-Defense Moves Every Woman Needs to Know'), findsOneWidget);

    // Tap on 'Misc' button
    await tester.tap(find.text('Misc'));
    await tester.pump();

    // Verify if 'Misc' content is displayed (same as AccessManual)
    expect(find.text('What is a SOS?'), findsOneWidget);
  });
}