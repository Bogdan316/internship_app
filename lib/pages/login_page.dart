import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'package:internship_app_fis/exceptions/user_already_exists.dart';
import 'package:internship_app_fis/services/user_service.dart';
import 'package:internship_app_fis/models/user.dart';

class LoginPage extends StatefulWidget {
  // Login page that handles the user sign up, password encryption and username
  // and password storage based on the user role: Student/Company

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _dropDownValue = 'Student';
  final _usernameCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  SnackBar _snackBarBuilder(String message) {
    // Builds a snack bar that pops up from the bottom of the displaying
    // the message given as the argument

    return SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // empty function, the argument is mandatory but we do not need any
          // action when pressing the button
        },
      ),
    );
  }

  void _submitUser() async {
    // Reads the input from the two controllers and checks that it is not empty
    // and that a user with the same username does not exist, if the conditions
    // are met then the password is encrypted and the user is stored into the
    // database

    if (_usernameCtr.text.isEmpty || _passwordCtr.text.isEmpty) {
      // Check if the input fields are empty
      final snackBar =
          _snackBarBuilder('The username and password fields are mandatory.');
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }

    // Password encryption
    var encPass = utf8.encode(_passwordCtr.text);
    var passHashValue = sha1.convert(encPass).toString();

    try {
      // Create a new user based on the role selected in the dropdown
      if (_dropDownValue == 'Student') {
        await UserService.addUser(Student(_usernameCtr.text, passHashValue));
      } else {
        await UserService.addUser(Company(_usernameCtr.text, passHashValue));
      }

      final snackBar = _snackBarBuilder('Success.');
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on UserAlreadyExistsException catch (e) {
      final snackBar = _snackBarBuilder(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // Clear the text fields after if adding the user ended with success
    setState(() {
      _usernameCtr.clear();
      _passwordCtr.clear();
    });
  }

  @override
  void dispose() {
    // Destroys the controllers when the Login page is destroyed
    super.dispose();
    _usernameCtr.dispose();
    _passwordCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internship App'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          // Sign up form
          children: [
            TextField(
              controller: _usernameCtr,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordCtr,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            // Dropdown with the roles that a user can select
            DropdownButton(
              value: _dropDownValue,
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              items: <String>['Student', 'Company']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _dropDownValue = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: _submitUser,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
