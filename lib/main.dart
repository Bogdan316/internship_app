import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:internship_app_fis/pages/applicant_profile_page.dart';
import 'package:internship_app_fis/pages/internship_page.dart';
import 'package:internship_app_fis/pages/internship_participants_page.dart';
import 'package:internship_app_fis/pages/profile_page.dart';
import 'package:internship_app_fis/services/internship_application_service.dart';
import 'package:internship_app_fis/services/user_profile_service.dart';
import 'package:internship_app_fis/pages/ongoing_internships_page.dart';

import '../base_widgets/theme_color.dart';
import '../dao/base_dao.dart';
import '../pages/create_user_profile_page.dart';
import '../pages/internships_main_page.dart';
import '../pages/login_page.dart';
import '../services/user_service.dart';
import '../pages/add_new_internship_page.dart';
import '../services/internship_service.dart';

final internshipApp = InternshipApp(UserService(BaseDao()));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(internshipApp);
}

class InternshipApp extends StatelessWidget {
  final UserService _userService;
  const InternshipApp(this._userService, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Internship App',
      theme: ThemeData(
        primarySwatch: createMaterialColor(
          const Color(0xFF01135d),
        ),
      ),
      home: LoginPage(_userService, DefaultCacheManager()),
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>;

        var routes = <String, WidgetBuilder>{
          OngoingInternshipsPage.namedRoute: (ctx) => OngoingInternshipsPage(
              args, InternshipService(BaseDao()), DefaultCacheManager()),
          AddNewInternshipPage.namedRoute: (ctx) =>
              AddNewInternshipPage(args, InternshipService(BaseDao())),
          InternshipsMainPage.namedRoute: (ctx) => InternshipsMainPage(
              args,
              InternshipService(BaseDao()),
              UserProfileService(BaseDao()),
              DefaultCacheManager()),
          InternshipPage.namedRoute: (ctx) =>
              InternshipPage(args, InternshipApplicationService(BaseDao())),
          CreateUserProfilePage.namedRoute: (ctx) =>
              CreateUserProfilePage(args, UserProfileService(BaseDao())),
          ProfilePage.namedRoute: (ctx) => ProfilePage(args),
          ApplicantProfilePage.namedRoute: (ctx) => ApplicantProfilePage(args,
              InternshipService(BaseDao()), UserProfileService(BaseDao())),
          InternshipParticipantsPage.namedRoute: (ctx) =>
              InternshipParticipantsPage(args, UserProfileService(BaseDao())),
        };

        return MaterialPageRoute(
          builder: (context) {
            return routes[settings.name]!(context);
          },
        );
      },
    );
  }
}
