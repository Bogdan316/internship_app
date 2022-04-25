import 'package:flutter/material.dart';

import '../models/user.dart';

class CreateUserProfilePage extends StatelessWidget {
  static const String namedRoute = '/create-user-profile';

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
