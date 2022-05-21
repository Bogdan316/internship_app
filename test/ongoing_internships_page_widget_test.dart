import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internship_app_fis/base_widgets/custom_elevated_button.dart';
import 'package:internship_app_fis/base_widgets/main_drawer.dart';
import 'package:internship_app_fis/models/internship.dart';
import 'package:internship_app_fis/models/user.dart';
import 'package:internship_app_fis/models/user_profile.dart';
import 'package:internship_app_fis/pages/add_new_internship_page.dart';
import 'package:internship_app_fis/pages/internships_main_page.dart';
import 'package:internship_app_fis/pages/login_page.dart';
import 'package:internship_app_fis/pages/ongoing_internships_page.dart';
import 'package:internship_app_fis/services/auth_service.dart';
import 'package:internship_app_fis/services/internship_service.dart';
import 'package:internship_app_fis/services/user_profile_service.dart';
import 'package:internship_app_fis/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysql1/mysql1.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'ongoing_internships_page_widget_test.mocks.dart';

@GenerateMocks([
  DefaultCacheManager,
  UserService,
  InternshipService,
  AuthService,
  UserProfileService,
  Stream,
  StreamSubscription
], customMocks: [
  MockSpec<Results>(unsupportedMembers: {#fold}),
  MockSpec<NavigatorObserver>(returnNullOnMissingStub: true),
])
void main() {
  late MockInternshipService mockInternshipService;
  late MockUserProfileService mockUserProfileService;
  late MockNavigatorObserver mockObserver;
  late MockUserService mockUserService;
  late MockDefaultCacheManager mockDefaultCacheManager;
  late User testUser;
  late Internship testInternship;
  late CompanyProfile testProfile;
  final now = DateFormat('dd/MM/yyyy').format(DateTime.now().toUtc());

  setUp(() {
    mockUserProfileService = MockUserProfileService();
    mockInternshipService = MockInternshipService();
    mockObserver = MockNavigatorObserver();
    mockUserService = MockUserService();
    mockDefaultCacheManager = MockDefaultCacheManager();
    // user with the encrypted value of the 'test_pass' password
    testUser = Company('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');
    testProfile = CompanyProfile(
      id: 1,
      userId: 1,
      fullname: 'test',
      about: 'test',
      email: 'test',
      imageLink: 'test',
    );
    testInternship = Internship(
      id: 1,
      companyId: 1,
      title: 'test',
      description: 'test',
      requirements: 'test',
      fromDate: DateFormat('dd/MM/yyyy').parseUtc(now),
      toDate: DateFormat('dd/MM/yyyy').parseUtc(now),
      participantsNum: 15,
      tag: Tag.webDevelopment,
      isOngoing: true,
    );
  });

  group('Ongoing Internships Page:', () {
    testWidgets(
        'pressing the ongoing internships link from the drawer should redirect to this page',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        // create a copy of the app with new routes so the internship service
        // can be mocked
        MaterialApp(
          home: LoginPage(mockUserService, mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              OngoingInternshipsPage.namedRoute: (ctx) =>
                  OngoingInternshipsPage(
                      args, mockInternshipService, mockDefaultCacheManager),
              InternshipsMainPage.namedRoute: (ctx) => InternshipsMainPage(
                    args,
                    mockInternshipService,
                    mockUserProfileService,
                    mockDefaultCacheManager,
                  ),
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
          .thenAnswer((_) => Future.value(testProfile));

      await tester.tap(buttons.first);
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(InternshipsMainPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsOneWidget);
      expect(find.byType(DrawerListTile), findsWidgets);

      // return a list with a single internship when getAllCompanyInternships
      // is called in initState
      when(mockInternshipService.getAllCompanyInternships(testUser as Company))
          .thenAnswer((_) => Future.value(
              List<Internship>.generate(1, (index) => testInternship)));
      when(mockInternshipService.getAllCompanyInternships(testUser as Company))
          .thenAnswer((_) => Future.value(<Internship>[]));

      await tester.tap(find.text('Ongoing Internships').first);
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
      verify(
          mockInternshipService.getAllCompanyInternships(testUser as Company));
      expect(find.byType(OngoingInternshipsPage), findsOneWidget);
    });

    testWidgets(
        'when there are no ongoing internships a placeholder image should be shown',
        (WidgetTester tester) async {
      // the method needs to be mocked before initState is called
      when(mockInternshipService.getAllCompanyInternships(testUser as Company))
          .thenAnswer((_) => Future.value(<Internship>[]));

      await tester.pumpWidget(
        // create a copy of the app with new routes so the internship service
        // can be mocked
        MaterialApp(
          home: OngoingInternshipsPage(
              {'user': testUser, 'profile': testProfile},
              mockInternshipService,
              mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              OngoingInternshipsPage.namedRoute: (ctx) =>
                  OngoingInternshipsPage(
                      args, mockInternshipService, mockDefaultCacheManager),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('No ongoing internships to show'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets(
        'when pressing the delete button the internship should be removed',
        (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        // the method needs to be mocked before initState is called
        when(mockInternshipService
                .getAllCompanyInternships(testUser as Company))
            .thenAnswer((_) => Future.value(
                <Internship>[testInternship, testInternship, testInternship]));

        await tester.pumpWidget(
          // create a copy of the app with new routes so the internship service
          // can be mocked
          MaterialApp(
            home: OngoingInternshipsPage(
                {'user': testUser, 'profile': testProfile},
                mockInternshipService,
                mockDefaultCacheManager),
            navigatorObservers: [mockObserver],
          ),
        );
        await tester.pumpAndSettle();

        var internships = find.byType(ListTile);
        expect(internships, findsNWidgets(3));

        var deleteButton = find.byIcon(Icons.delete_outline);
        when(mockInternshipService.deleteInternship(testInternship))
            .thenAnswer((_) => Future.value());
        await tester.tap(deleteButton.first);
        await tester.pumpAndSettle();

        internships = find.byType(ListTile);
        expect(internships, findsNWidgets(2));
      });
    });

    testWidgets(
        'the database should be queried again after an internship was edited',
        (WidgetTester tester) async {
      // the method needs to be mocked before initState is called
      when(mockInternshipService.getAllCompanyInternships(testUser as Company))
          .thenAnswer((_) => Future.value(
              <Internship>[testInternship, testInternship, testInternship]));

      await tester.pumpWidget(
        // create a copy of the app with new routes so the internship service
        // can be mocked
        MaterialApp(
          home: OngoingInternshipsPage(
              {'user': testUser, 'profile': testProfile},
              mockInternshipService,
              mockDefaultCacheManager),
          navigatorObservers: [mockObserver],
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>;

            var routes = <String, WidgetBuilder>{
              OngoingInternshipsPage.namedRoute: (ctx) =>
                  OngoingInternshipsPage(
                      args, mockInternshipService, mockDefaultCacheManager),
              AddNewInternshipPage.namedRoute: (ctx) =>
                  AddNewInternshipPage(args, MockInternshipService()),
            };

            return MaterialPageRoute(
              builder: (context) {
                return routes[settings.name]!(context);
              },
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      var editButton = find.byIcon(Icons.edit_outlined).first;
      await tester.tap(editButton);

      verify(mockObserver.didPush(any, any));
      final MockStream<FileResponse> stream = MockStream();
      when(mockDefaultCacheManager.getImageFile('test',
              key: null,
              headers: null,
              withProgress: true,
              maxHeight: null,
              maxWidth: null))
          .thenAnswer((realInvocation) => stream);
      when(stream.listen(
        any,
        onError: anyNamed('onError'),
        onDone: anyNamed('onDone'),
        cancelOnError: anyNamed('cancelOnError'),
      )).thenAnswer((realInvocation) => MockStreamSubscription());

      await tester.pumpAndSettle();
      expect(find.byType(AddNewInternshipPage), findsOneWidget);

      final backButton = find.byIcon(Icons.arrow_back);
      tester.tap(backButton);
      verify(
          mockInternshipService.getAllCompanyInternships(testUser as Company));
    });
  });
}
