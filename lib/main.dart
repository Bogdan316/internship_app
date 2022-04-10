import 'package:flutter/material.dart';

import 'package:internship_app_fis/pages/login_page.dart';

void main() {
  runApp(const InternshipApp());
}

class InternshipApp extends StatelessWidget {
  const InternshipApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internship App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
