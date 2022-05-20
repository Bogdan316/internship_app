import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internship_app_fis/models/internship.dart';
import 'package:internship_app_fis/models/user_profile.dart';
import 'package:internship_app_fis/pages/login_page.dart';
import 'package:internship_app_fis/services/internship_service.dart';
import 'package:internship_app_fis/services/user_profile_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysql1/mysql1.dart';

import 'package:internship_app_fis/base_widgets/custom_elevated_button.dart';
import 'package:internship_app_fis/exceptions/user_already_exists.dart';
import 'package:internship_app_fis/main.dart';
import 'package:internship_app_fis/models/user.dart';
import 'package:internship_app_fis/services/user_service.dart';
import 'package:internship_app_fis/pages/create_user_profile_page.dart';
import 'package:internship_app_fis/pages/internships_main_page.dart';

import 'login_page_widget_test.mocks.dart';

@GenerateMocks([
  InternshipService,
  UserProfileService,
  UserService,
  DefaultCacheManager,
  MySqlConnection
], customMocks: [
  MockSpec<NavigatorObserver>(returnNullOnMissingStub: true),
])
void main() {
  late MockInternshipService mockInternshipService;
  late MockUserProfileService mockUserProfileService;
  late MockNavigatorObserver mockObserver;
  late MockUserService mockUserService;
  late MockDefaultCacheManager mockDefaultCacheManager;
  late CompanyProfile testCompanyProfile;
  late StudentProfile testStudentProfile;

  setUp(() {
    mockUserProfileService = MockUserProfileService();
    mockInternshipService = MockInternshipService();
    mockObserver = MockNavigatorObserver();
    mockUserService = MockUserService();
    mockDefaultCacheManager = MockDefaultCacheManager();
    testCompanyProfile = CompanyProfile(
      id: 1,
      userId: 1,
      fullname: 'test',
      about: 'test',
      email: 'test',
      imageLink: 'test',
    );
    testStudentProfile = StudentProfile(
      id: 1,
      userId: 1,
      fullname: 'test',
      about: 'test',
      email: 'test',
      imageLink: 'test',
      cvLink: 'teset',
      repo: 'test',
    );
  });

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
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(mockUserService, mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              InternshipsMainPage.namedRoute: (ctx) => InternshipsMainPage(
                  args, mockInternshipService, mockUserProfileService),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
        ),
      );

      // switch to Company tab
      var tabs = find.byType(Tab);
      await tester.tap(tabs.last);
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      await tester.tap(buttons.first);
      await tester.pumpAndSettle();

      final findSnackBar =
          find.text('The username and password fields are mandatory.');
      expect(findSnackBar, findsOneWidget);
    });

    testWidgets('login should fail if the user does not exist',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Company('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(mockUserService, mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              InternshipsMainPage.namedRoute: (ctx) => InternshipsMainPage(
                  args, mockInternshipService, mockUserProfileService),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
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
      // used for testing page navigation
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(mockUserService, mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              InternshipsMainPage.namedRoute: (ctx) => InternshipsMainPage(
                  args, mockInternshipService, mockUserProfileService),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
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

      when(mockInternshipService.getAllInternships())
          .thenAnswer((_) => Future.value(<Internship>[]));
      when(mockUserProfileService.getAllCompanyProfiles())
          .thenAnswer((_) => Future.value(<CompanyProfile>[]));
      when(mockUserProfileService.getUserProfileById(testUser))
          .thenAnswer((_) => Future.value(testCompanyProfile));

      await tester.tap(buttons.first);
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(InternshipsMainPage), findsOneWidget);
    });

    testWidgets('signup should fail if the user exists',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Company('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(mockUserService, mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              InternshipsMainPage.namedRoute: (ctx) => InternshipsMainPage(
                  args, mockInternshipService, mockUserProfileService),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
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
      when(mockDefaultCacheManager.emptyCache())
          .thenAnswer((_) => Future.value());
      when(mockUserService.addUser(testUser))
          .thenAnswer((_) => throw UserAlreadyExistsException());

      await tester.tap(buttons.last);

      await tester.pumpAndSettle();

      final findSnackBar =
          find.text('The username already exists.', skipOffstage: false);
      expect(findSnackBar, findsOneWidget);
    });

    testWidgets('signup should fail if the password is too short',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(mockUserService, mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              InternshipsMainPage.namedRoute: (ctx) => InternshipsMainPage(
                  args, mockInternshipService, mockUserProfileService),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
        ),
      );

      // switch to Company tab
      var tabs = find.byType(Tab);
      await tester.tap(tabs.last);
      await tester.pumpAndSettle();

      var fields = find.byType(TextField);
      await tester.enterText(fields.first, 'test_user');
      await tester.enterText(fields.last, 'test');
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);

      await tester.tap(buttons.last);

      await tester.pumpAndSettle();

      final findSnackBar =
          find.text('The password is too short.', skipOffstage: false);
      expect(findSnackBar, findsOneWidget);
    });

    testWidgets('signup should be successful if the user does not exist',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Company('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');
      // used for testing page navigation
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(mockUserService, mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              CreateUserProfilePage.namedRoute: (ctx) =>
                  CreateUserProfilePage(args, mockUserProfileService),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
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
      when(mockDefaultCacheManager.emptyCache())
          .thenAnswer((_) => Future.value());
      when(mockUserService.addUser(testUser)).thenAnswer((_) async => () {
            testUser.setUserId(1);
            return;
          });

      await tester.tap(buttons.last);
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(CreateUserProfilePage), findsOneWidget);
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
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(mockUserService, mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              InternshipsMainPage.namedRoute: (ctx) => InternshipsMainPage(
                  args, mockInternshipService, mockUserProfileService),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
        ),
      );

      var buttons = find.byType(CustomElevatedButton);
      await tester.tap(buttons.first);
      await tester.pumpAndSettle();

      final findSnackBar =
          find.text('The username and password fields are mandatory.');
      expect(findSnackBar, findsOneWidget);
    });

    testWidgets('login should fail if the user does not exist',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Student('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(mockUserService, mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              InternshipsMainPage.namedRoute: (ctx) => InternshipsMainPage(
                  args, mockInternshipService, mockUserProfileService),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
        ),
      );

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
      // used for testing page navigation
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(mockUserService, mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              InternshipsMainPage.namedRoute: (ctx) => InternshipsMainPage(
                  args, mockInternshipService, mockUserProfileService),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
        ),
      );

      var fields = find.byType(TextField);
      await tester.enterText(fields.first, 'test_user');
      await tester.enterText(fields.last, 'test_pass');
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      when(mockUserService.getUser(testUser)).thenAnswer((_) {
        testUser.setUserId(1);
        return Future.value(testUser);
      });

      when(mockInternshipService
              .getStudentNotAppliedInternship(testUser as Student))
          .thenAnswer((_) => Future.value(<Internship>[]));
      when(mockInternshipService.getAllInternships())
          .thenAnswer((_) => Future.value(<Internship>[]));
      when(mockUserProfileService.getAllCompanyProfiles())
          .thenAnswer((_) => Future.value(<CompanyProfile>[]));
      when(mockUserProfileService.getUserProfileById(testUser))
          .thenAnswer((_) => Future.value(testStudentProfile));

      await tester.tap(buttons.first);
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(InternshipsMainPage), findsOneWidget);
    });

    testWidgets('signup should fail if the user exists',
        (WidgetTester tester) async {
      // user with the encrypted value of the 'test_pass' password
      final User testUser =
          Student('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(mockUserService, mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              InternshipsMainPage.namedRoute: (ctx) => InternshipsMainPage(
                  args, mockInternshipService, mockUserProfileService),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
        ),
      );

      var fields = find.byType(TextField);
      await tester.enterText(fields.first, 'test_user');
      await tester.enterText(fields.last, 'test_pass');
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      when(mockDefaultCacheManager.emptyCache())
          .thenAnswer((_) => Future.value());
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
      // used for testing page navigation
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(mockUserService, mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              CreateUserProfilePage.namedRoute: (ctx) =>
                  CreateUserProfilePage(args, mockUserProfileService),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
        ),
      );

      var fields = find.byType(TextField);
      await tester.enterText(fields.first, 'test_user');
      await tester.enterText(fields.last, 'test_pass');
      await tester.pumpAndSettle();

      var buttons = find.byType(CustomElevatedButton);
      when(mockDefaultCacheManager.emptyCache())
          .thenAnswer((_) => Future.value());
      when(mockUserService.addUser(testUser)).thenAnswer((_) async => () {
            testUser.setUserId(1);
            return;
          });

      await tester.tap(buttons.last);
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(CreateUserProfilePage), findsOneWidget);
    });
  });
}
