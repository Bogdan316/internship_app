import 'package:flutter/material.dart';

import '../models/user.dart';
import '../base_widgets/main_drawer.dart';

class InternshipsMainPage extends StatelessWidget {
  static const String namedRoute = '/internships-main-page';

  const InternshipsMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final crtUser = args['user'] as User;
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: themeData.primaryColor,
        title: const Text('Internship App'),
      ),
      drawer: const MainDrawer(),
      body: Text(
        crtUser.toString(),
      ),
    );
  }
}
