import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:internship_app_fis/base_widgets/custom_elevated_button.dart';
import 'package:internship_app_fis/base_widgets/main_drawer.dart';
import 'package:internship_app_fis/main.dart';
import 'package:internship_app_fis/models/internship.dart';
import 'package:internship_app_fis/models/user.dart';
import 'package:internship_app_fis/pages/add_new_internship_page.dart';
import 'package:internship_app_fis/pages/internships_main_page.dart';
import 'package:internship_app_fis/services/auth_service.dart';
import 'package:internship_app_fis/services/internship_service.dart';
import 'package:internship_app_fis/services/user_service.dart';

import 'add_new_internship_page_widget_test.mocks.dart';

@GenerateMocks([
  UserService,
  InternshipService,
  AuthService
], customMocks: [
  MockSpec<Results>(unsupportedMembers: {#fold}),
  MockSpec<NavigatorObserver>(returnNullOnMissingStub: true),
])
void main() {
  late MockInternshipService mockInternshipService;
  late MockNavigatorObserver mockObserver;
  late MockUserService mockUserService;
  late User testUser;
  late Map<String, dynamic> pageArgs;

  setUp(() {
    pageArgs = {'user': Company('test', 'test')};
    mockInternshipService = MockInternshipService();
    mockObserver = MockNavigatorObserver();
    mockUserService = MockUserService();
    // user with the encrypted value of the 'test_pass' password
    testUser = Company('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');
  });

  group('Add New Internship Page:', () {
    testWidgets(
        'pressing the add internship link from the drawer should redirect to this page',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InternshipApp(mockUserService),
          navigatorObservers: [mockObserver],
        ),
      );

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

      verify(mockObserver.didPush(any, any));
      expect(find.byType(InternshipsMainPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsOneWidget);
      expect(find.byType(DrawerListTile), findsWidgets);
      await tester.tap(find.text('Add New Internship').first);
      await tester.pumpAndSettle();
      expect(find.byType(AddNewInternshipPage), findsOneWidget);
    });

    testWidgets(
        'pressing the submit button when all fields are empty should show error messages',
        (WidgetTester tester) async {
      final key = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: key,
          home: TextButton(
            onPressed: () => key.currentState?.push(
              MaterialPageRoute<void>(
                settings: RouteSettings(arguments: Company('test', 'test')),
                builder: (_) =>
                    AddNewInternshipPage(pageArgs, mockInternshipService),
              ),
            ),
            child: const SizedBox(),
          ),
          navigatorObservers: [mockObserver],
        ),
      );
      await tester.tap(find.byType(TextButton));
      verify(mockObserver.didPush(any, any));
      await tester.pumpAndSettle();
      var submitButton = find.byType(CustomElevatedButton);
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(
          find.text("The number of participants can't be 0",
              findRichText: true),
          findsOneWidget);
      expect(find.text('This field is mandatory'), findsNWidgets(6));
    });

    testWidgets(
        'pressing the To Date field should show a DatePicker, selecting a date should fill the TextFormField',
        (WidgetTester tester) async {
      final key = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: key,
          home: TextButton(
            onPressed: () => key.currentState?.push(
              MaterialPageRoute<void>(
                settings: RouteSettings(arguments: pageArgs),
                builder: (_) =>
                    AddNewInternshipPage(pageArgs, mockInternshipService),
              ),
            ),
            child: const SizedBox(),
          ),
          navigatorObservers: [mockObserver],
        ),
      );
      await tester.tap(find.byType(TextButton));
      verify(mockObserver.didPush(any, any));
      await tester.pumpAndSettle();

      var fromDateField = find.widgetWithText(CustomFormField, 'From Date');
      expect(fromDateField, findsOneWidget);
      await tester.ensureVisible(fromDateField);
      await tester.tap(fromDateField);
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      await tester.tap(find.text(DateTime.now().day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      var formattedDate =
          DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
      expect(find.widgetWithText(TextFormField, formattedDate), findsOneWidget);
    });

    testWidgets(
        'pressing the To Date field should show a DatePicker, selecting a date should fill the TextFormField',
        (WidgetTester tester) async {
      final key = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: key,
          home: TextButton(
            onPressed: () => key.currentState?.push(
              MaterialPageRoute<void>(
                settings: RouteSettings(arguments: pageArgs),
                builder: (_) =>
                    AddNewInternshipPage(pageArgs, mockInternshipService),
              ),
            ),
            child: const SizedBox(),
          ),
          navigatorObservers: [mockObserver],
        ),
      );
      await tester.tap(find.byType(TextButton));
      verify(mockObserver.didPush(any, any));
      await tester.pumpAndSettle();

      var toDateField = find.widgetWithText(CustomFormField, 'To Date');
      expect(toDateField, findsOneWidget);

      await tester.ensureVisible(toDateField);
      await tester.tap(toDateField);
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      await tester.tap(find.text(DateTime.now().day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      var formattedDate =
          DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
      expect(find.widgetWithText(TextFormField, formattedDate), findsOneWidget);
    });

    testWidgets(
        'picking a To Date that is not after the From Date should show an error',
        (WidgetTester tester) async {
      final key = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: key,
          home: TextButton(
            onPressed: () => key.currentState?.push(
              MaterialPageRoute<void>(
                settings: RouteSettings(arguments: pageArgs),
                builder: (_) =>
                    AddNewInternshipPage(pageArgs, mockInternshipService),
              ),
            ),
            child: const SizedBox(),
          ),
          navigatorObservers: [mockObserver],
        ),
      );
      await tester.tap(find.byType(TextButton));
      verify(mockObserver.didPush(any, any));
      await tester.pumpAndSettle();

      var fromDateField = find.widgetWithText(CustomFormField, 'From Date');
      expect(fromDateField, findsOneWidget);
      await tester.ensureVisible(fromDateField);
      await tester.tap(fromDateField);
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      final nextMonthIcon = find.byWidgetPredicate((Widget w) =>
          w is IconButton && (w.tooltip?.startsWith('Next month') ?? false));
      await tester.tap(nextMonthIcon);
      await tester.pumpAndSettle();
      await tester.tap(find.text('1').first);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      var toDateField = find.widgetWithText(CustomFormField, 'To Date');
      expect(toDateField, findsOneWidget);

      await tester.ensureVisible(toDateField);
      await tester.tap(toDateField);
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      await tester.tap(find.text(DateTime.now().day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      var submitButton = find.byType(CustomElevatedButton);
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(find.text('The To Date needs to be after the From Date'),
          findsOneWidget);
    });
    testWidgets(
        'tapping the submit button when all fields are filled should insert a new Internship',
        (WidgetTester tester) async {
      final key = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: key,
          home: TextButton(
            onPressed: () => key.currentState?.push(
              MaterialPageRoute<void>(
                settings: RouteSettings(arguments: pageArgs),
                builder: (_) =>
                    AddNewInternshipPage(pageArgs, mockInternshipService),
              ),
            ),
            child: const SizedBox(),
          ),
          navigatorObservers: [mockObserver],
        ),
      );

      await tester.tap(find.byType(TextButton));
      verify(mockObserver.didPush(any, any));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      // title field
      await tester.enterText(textFields.at(0), 'test');
      // description field
      await tester.enterText(textFields.at(1), 'test');
      // requirements field
      await tester.enterText(textFields.at(2), 'test');
      // from date field
      await tester.ensureVisible(textFields.at(3));
      await tester.tap(textFields.at(3));
      await tester.pumpAndSettle();

      await tester.tap(find.text(DateTime.now().day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      // to date field
      await tester.ensureVisible(textFields.at(4));
      await tester.tap(textFields.at(4));
      await tester.pumpAndSettle();

      await tester.tap(find.text(DateTime.now().day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      final slider = find.byType(Slider);
      // should drag the slider to 15
      await tester.drag(slider, const Offset(5.0, 0));
      await tester.pumpAndSettle();

      final dropDown = find.byType(DropdownButtonFormField<Tag>);
      await tester.tap(dropDown);
      await tester.pumpAndSettle();
      await tester.tap(
          find
              .widgetWithText(DropdownMenuItem<Tag>,
                  TagUtil.convertTagValueToString(Tag.values[0]))
              .last,
          warnIfMissed: false);
      await tester.pumpAndSettle();

      final now = DateFormat('dd/MM/yyyy').format(DateTime.now().toUtc());
      final expectedInternship = Internship(
        companyId: null,
        title: 'test',
        description: 'test',
        requirements: 'test',
        fromDate: DateFormat('dd/MM/yyyy').parseUtc(now),
        toDate: DateFormat('dd/MM/yyyy').parseUtc(now),
        participantsNum: 15,
        tag: Tag.webDevelopment,
        isOngoing: true,
      );

      when(mockInternshipService.addInternship(any))
          .thenAnswer((_) => Future.value());

      var submitButton = find.byType(CustomElevatedButton);
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      verify(mockInternshipService.addInternship(expectedInternship));
    });
  });
}
