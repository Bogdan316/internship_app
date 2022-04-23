import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:internship_app_fis/base_widgets/theme_color.dart';
import 'package:internship_app_fis/dao/base_dao.dart';
import 'package:internship_app_fis/pages/login_page.dart';
import 'package:internship_app_fis/services/user_service.dart';

final internshipApp = InternshipApp(UserService(BaseDao()));

void main() => runApp(internshipApp);

class InternshipApp extends StatelessWidget {
  final UserService userService;
  const InternshipApp(this.userService, {Key? key}) : super(key: key);

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
      home: LoginPage(userService),
    );
  }
}
