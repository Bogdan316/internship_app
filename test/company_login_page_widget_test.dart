import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:internship_app_fis/base_widgets/custom_elevated_button.dart';
import 'package:internship_app_fis/main.dart';

void main() {
  group('LoginPage - Company', () {
    testWidgets('has signup and login buttons', (WidgetTester tester) async {
      await tester.pumpWidget(const InternshipApp());

      var tabs = find.byType(Tab);
      await tester.tap(tabs.last);
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      expect(buttons, findsNWidgets(2));
    });

    testWidgets('has username and password TextFields',
        (WidgetTester tester) async {
      await tester.pumpWidget(const InternshipApp());

      var tabs = find.byType(Tab);
      await tester.tap(tabs.last);
      await tester.pumpAndSettle();

      var fields = find.byType(TextField);
      var icons = find.byType(Icon);

      expect(fields, findsNWidgets(2));
      expect(icons, findsNWidgets(2));
    });

    testWidgets(
        'pressing the buttons with no username and password should show a SnackBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(const InternshipApp());

      var tabs = find.byType(Tab);
      await tester.tap(tabs.last);
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      await tester.tap(buttons.first);
      await tester.pump();

      final findSnackBar = find.text('OK');
      expect(findSnackBar, findsOneWidget);
    });
  });
}
