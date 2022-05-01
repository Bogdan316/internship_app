import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base_widgets/theme_color.dart';
import '../dao/base_dao.dart';
import '../pages/create_user_profile_page.dart';
import '../pages/internships_main_page.dart';
import '../pages/login_page.dart';
import '../services/user_service.dart';
import '../pages/add_new_internship_page.dart';
import '../services/internship_service.dart';

final internshipApp = InternshipApp(UserService(BaseDao()));

void main() => runApp(internshipApp);

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
      home: LoginPage(_userService),
      routes: {
        CreateUserProfilePage.namedRoute: (_) => const CreateUserProfilePage(),
        InternshipsMainPage.namedRoute: (_) => const InternshipsMainPage(),
        AddNewInternshipPage.namedRoute: (_) =>
            AddNewInternshipPage(InternshipService(BaseDao())),
      },
    );
  }
}
