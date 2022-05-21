import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internship_app_fis/models/internship.dart';
import 'package:internship_app_fis/models/user.dart';
import 'package:internship_app_fis/models/user_profile.dart';
import 'package:internship_app_fis/pages/internships_main_page.dart';
import 'package:internship_app_fis/services/auth_service.dart';
import 'package:internship_app_fis/services/internship_service.dart';
import 'package:internship_app_fis/services/user_profile_service.dart';
import 'package:internship_app_fis/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysql1/mysql1.dart';

import 'internships_main_page_widget_test.mocks.dart';

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
  late User testCompanyUser;
  late Internship testInternship;
  late CompanyProfile testCompanyProfile;
  final now = DateFormat('dd/MM/yyyy').format(DateTime.now().toUtc());

  setUp(() {
    mockUserProfileService = MockUserProfileService();
    mockInternshipService = MockInternshipService();
    mockObserver = MockNavigatorObserver();
    mockUserService = MockUserService();
    mockDefaultCacheManager = MockDefaultCacheManager();
    // user with the encrypted value of the 'test_pass' password
    testCompanyUser =
        Company('test_user', 'c94d65f02a652d11c2e5c2e1ccf38dce5a076e1e');
    testCompanyProfile = CompanyProfile(
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

  group('Internships Main Page: ', () {
    testWidgets('should have a search button that redirects to a search page',
        (WidgetTester tester) async {
      when(mockInternshipService.getAllInternships())
          .thenAnswer((_) => Future.value(<Internship>[]));
      when(mockUserProfileService.getAllCompanyProfiles())
          .thenAnswer((_) => Future.value(<CompanyProfile>[]));
      await tester.pumpWidget(
        MaterialApp(
          home: InternshipsMainPage(
              {'user': testCompanyUser, 'profile': testCompanyProfile},
              mockInternshipService,
              mockUserProfileService,
              DefaultCacheManager()),
          navigatorObservers: [mockObserver],
        ),
      );
      await tester.pumpAndSettle();

      final searchButton = find.byIcon(Icons.search);
      expect(searchButton, findsOneWidget);

      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
    });
    testWidgets(
        'should redirect to a search page that has all the Tags as suggestions',
        (WidgetTester tester) async {
      when(mockInternshipService.getAllInternships())
          .thenAnswer((_) => Future.value(<Internship>[]));
      when(mockUserProfileService.getAllCompanyProfiles())
          .thenAnswer((_) => Future.value(<CompanyProfile>[]));
      await tester.pumpWidget(
        MaterialApp(
          home: InternshipsMainPage(
              {'user': testCompanyUser, 'profile': testCompanyProfile},
              mockInternshipService,
              mockUserProfileService,
              DefaultCacheManager()),
          navigatorObservers: [mockObserver],
        ),
      );
      await tester.pumpAndSettle();

      final searchButton = find.byIcon(Icons.search);
      expect(searchButton, findsOneWidget);

      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(Tag.values.length));
    });
  });
  testWidgets('when searching for a tag the list should be filtered',
      (WidgetTester tester) async {
    when(mockInternshipService.getAllInternships())
        .thenAnswer((_) => Future.value(<Internship>[]));
    when(mockUserProfileService.getAllCompanyProfiles())
        .thenAnswer((_) => Future.value(<CompanyProfile>[]));
    await tester.pumpWidget(
      MaterialApp(
        home: InternshipsMainPage(
            {'user': testCompanyUser, 'profile': testCompanyProfile},
            mockInternshipService,
            mockUserProfileService,
            DefaultCacheManager()),
        navigatorObservers: [mockObserver],
      ),
    );
    await tester.pumpAndSettle();

    final searchButton = find.byIcon(Icons.search);
    expect(searchButton, findsOneWidget);

    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    final textField = find.byType(TextField);
    await tester.enterText(
        textField, TagUtil.convertTagValueToString(Tag.gameDevelopment));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text(TagUtil.convertTagValueToString(Tag.gameDevelopment)),
        findsNWidgets(2));
  });
}
