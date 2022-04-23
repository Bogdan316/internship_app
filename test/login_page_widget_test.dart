import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysql1/mysql1.dart';

import 'package:internship_app_fis/base_widgets/custom_elevated_button.dart';
import 'package:internship_app_fis/exceptions/user_already_exists.dart';
import 'package:internship_app_fis/main.dart';
import 'package:internship_app_fis/models/user.dart';
import 'package:internship_app_fis/services/user_service.dart';

import 'login_page_widget_test.mocks.dart';

@GenerateMocks([UserService, MySqlConnection])
void main() {
  final mockUserService = MockUserService(MockMySqlConnection());

  group('LoginPage - Company:', () {
    testWidgets('has signup and login buttons', (WidgetTester tester) async {
      await tester.pumpWidget(InternshipApp(mockUserService));

      var tabs = find.byType(Tab);
      await tester.tap(tabs.last);
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      expect(buttons, findsNWidgets(2));
    });

    testWidgets('has username and password TextFields',
        (WidgetTester tester) async {
      await tester.pumpWidget(InternshipApp(mockUserService));

      // switch to Company tab
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
      await tester.pumpWidget(InternshipApp(mockUserService));

      // switch to Company tab
      var tabs = find.byType(Tab);
      await tester.tap(tabs.last);
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      await tester.tap(buttons.first);
      await tester.pump();

      final findSnackBar =
          find.text('The username and password fields are mandatory.');
      expect(findSnackBar, findsOneWidget);
    });

    testWidgets('login should fail if the user does not exist',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Company('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');

      await tester.pumpWidget(InternshipApp(mockUserService));

      // switch to Company tab
      var tabs = find.byType(Tab);
      await tester.tap(tabs.last);
      await tester.pumpAndSettle();

      var fields = find.byType(TextField);
      await tester.enterText(fields.first, 'test_user');
      await tester.enterText(fields.last, 'test_pass');
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      when(mockUserService.getUser(testUser))
          .thenAnswer((_) => Future.value(null));

      await tester.tap(buttons.first);
      await tester.pumpAndSettle();

      final findSnackBar =
          find.text('Wrong username or password.', skipOffstage: false);
      expect(findSnackBar, findsOneWidget);
    });

    testWidgets('login should be successful if the user exists',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Company('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');

      await tester.pumpWidget(InternshipApp(mockUserService));

      // switch to Company tab
      var tabs = find.byType(Tab);
      await tester.tap(tabs.last);
      await tester.pumpAndSettle();

      var fields = find.byType(TextField);
      await tester.enterText(fields.first, 'test_user');
      await tester.enterText(fields.last, 'test_pass');
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      when(mockUserService.getUser(testUser)).thenAnswer((_) {
        testUser.setUserId(1);
        return Future.value(testUser);
      });

      await tester.tap(buttons.first);
      await tester.pumpAndSettle();

      final findSnackBar = find.text('Successful Login.', skipOffstage: false);
      expect(findSnackBar, findsOneWidget);
    });

    testWidgets('signup should fail if the user exists',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Company('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');

      await tester.pumpWidget(InternshipApp(mockUserService));

      // switch to Company tab
      var tabs = find.byType(Tab);
      await tester.tap(tabs.last);
      await tester.pumpAndSettle();

      var fields = find.byType(TextField);
      await tester.enterText(fields.first, 'test_user');
      await tester.enterText(fields.last, 'test_pass');
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      when(mockUserService.addUser(testUser))
          .thenAnswer((_) => throw UserAlreadyExistsException());

      await tester.tap(buttons.last);

      await tester.pumpAndSettle();

      final findSnackBar =
          find.text('The username already exists.', skipOffstage: false);
      expect(findSnackBar, findsOneWidget);
    });

    testWidgets('signup should be successful if the user does not exist',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Company('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');

      await tester.pumpWidget(InternshipApp(mockUserService));

      // switch to Company tab
      var tabs = find.byType(Tab);
      await tester.tap(tabs.last);
      await tester.pumpAndSettle();

      var fields = find.byType(TextField);
      await tester.enterText(fields.first, 'test_user');
      await tester.enterText(fields.last, 'test_pass');
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      when(mockUserService.addUser(testUser)).thenAnswer((_) async => () {
            testUser.setUserId(1);
            return;
          });

      await tester.tap(buttons.last);

      await tester.pumpAndSettle();

      final findSnackBar = find.text('Successful Signup.', skipOffstage: false);
      expect(findSnackBar, findsOneWidget);
    });
  });

  group('LoginPage - Student:', () {
    testWidgets('has signup and login buttons', (WidgetTester tester) async {
      await tester.pumpWidget(InternshipApp(mockUserService));

      var buttons = find.byType(CustomElevatedButton);

      expect(buttons, findsNWidgets(2));
    });

    testWidgets('has username and password TextFields',
        (WidgetTester tester) async {
      await tester.pumpWidget(InternshipApp(mockUserService));

      var fields = find.byType(TextField);
      var icons = find.byType(Icon);

      expect(fields, findsNWidgets(2));
      expect(icons, findsNWidgets(2));
    });

    testWidgets(
        'pressing the buttons with no username and password should show a SnackBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(InternshipApp(mockUserService));

      var buttons = find.byType(CustomElevatedButton);
      await tester.tap(buttons.first);
      await tester.pump();

      final findSnackBar = find.text('OK');
      expect(findSnackBar, findsOneWidget);
    });

    testWidgets('login should fail if the user does not exist',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Student('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');

      await tester.pumpWidget(InternshipApp(mockUserService));

      var fields = find.byType(TextField);
      await tester.enterText(fields.first, 'test_user');
      await tester.enterText(fields.last, 'test_pass');
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      when(mockUserService.getUser(testUser))
          .thenAnswer((_) => Future.value(null));

      await tester.tap(buttons.first);
      await tester.pumpAndSettle();

      final findSnackBar =
          find.text('Wrong username or password.', skipOffstage: false);
      expect(findSnackBar, findsOneWidget);
    });

    testWidgets('login should be successful if the user exists',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Student('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');

      await tester.pumpWidget(InternshipApp(mockUserService));

      var fields = find.byType(TextField);
      await tester.enterText(fields.first, 'test_user');
      await tester.enterText(fields.last, 'test_pass');
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      when(mockUserService.getUser(testUser)).thenAnswer((_) {
        testUser.setUserId(1);
        return Future.value(testUser);
      });

      await tester.tap(buttons.first);
      await tester.pumpAndSettle();

      final findSnackBar = find.text('Successful Login.', skipOffstage: false);
      expect(findSnackBar, findsOneWidget);
    });

    testWidgets('signup should fail if the user exists',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Student('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');

      await tester.pumpWidget(InternshipApp(mockUserService));

      var fields = find.byType(TextField);
      await tester.enterText(fields.first, 'test_user');
      await tester.enterText(fields.last, 'test_pass');
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      when(mockUserService.addUser(testUser))
          .thenAnswer((_) => throw UserAlreadyExistsException());

      await tester.tap(buttons.last);

      await tester.pumpAndSettle();

      final findSnackBar =
          find.text('The username already exists.', skipOffstage: false);
      expect(findSnackBar, findsOneWidget);
    });

    testWidgets('signup should be successful if the user does not exist',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Student('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');

      await tester.pumpWidget(InternshipApp(mockUserService));

      var fields = find.byType(TextField);
      await tester.enterText(fields.first, 'test_user');
      await tester.enterText(fields.last, 'test_pass');
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      when(mockUserService.addUser(testUser)).thenAnswer((_) async => () {
            testUser.setUserId(1);
            return;
          });

      await tester.tap(buttons.last);

      await tester.pumpAndSettle();

      final findSnackBar = find.text('Successful Signup.', skipOffstage: false);
      expect(findSnackBar, findsOneWidget);
    });
  });
}
