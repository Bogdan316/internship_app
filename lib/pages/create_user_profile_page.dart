import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_profile_service.dart';
import './profile_page.dart';
import './edit_profile_page.dart';
//import 'package:flutter/services.dart';
//import './testare/user_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
//import '../models/user_profile.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await SystemChrome.setPreferredOrientations([
  //DeviceOrientation.portraitUp,
  //DeviceOrientation.portraitDown,
  //]);

  //await UserPreferences.init();
  await Firebase.initializeApp();

  //runApp(MyApp());
}
/*
class MyApp extends StatelessWidget {
  static final String title = 'User Profile';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue.shade300,
        dividerColor: Colors.black,
      ),
      title: title,
      home: /*Edit*/ProfilePage(),
    );
  }
}*/

class CreateUserProfilePage extends StatelessWidget {
  static const String namedRoute = '/create-user-user_profile';//'/create-user-profile';
  final UserProfileService _userProfileService;

  const CreateUserProfilePage(this._userProfileService,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final crtUser = ModalRoute.of(context)!.settings.arguments as User?;
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: themeData.primaryColor,
        title: const Text('Create Profile'),
      ),
      body: EditProfilePage(crtUser,_userProfileService),
          //Text(
        //crtUser.toString(),
          //),
      );
    //);
  }
}

//import 'package:flutter/material.dart';

//import '../models/user_profile.dart';

/*
class CreateUserProfilePage extends StatelessWidget {
  static const String namedRoute = '/testare/main_profile.dart';//'/create-user-profile';

  const CreateUserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final crtUser = ModalRoute.of(context)!.settings.arguments as User;
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: themeData.primaryColor,
        title: const Text('Create Profile'),
      ),
      body: Text(
        crtUser.toString(),
      ),
    );
  }
}
*/