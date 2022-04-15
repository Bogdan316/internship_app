import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'package:internship_app_fis/exceptions/user_already_exists.dart';
import 'package:internship_app_fis/services/user_service.dart';
import 'package:internship_app_fis/models/user.dart';

class LoginTab extends StatefulWidget {
  // Login page that handles the user sign up, password encryption and username
  // and password storage based on the user role: Student/Company
  final String _userRole;

  const LoginTab(this._userRole, {Key? key}) : super(key: key);

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
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
      if (widget._userRole == 'Student') {
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
    var mediaQuery = MediaQuery.of(context);
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: mediaQuery.size.height * 0.35,
              margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // Sign up form
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 30,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          height: 40,
                          child: TextField(
                            style: const TextStyle(fontSize: 15),
                            controller: _usernameCtr,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.password_outlined,
                        size: 30,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          height: 40,
                          child: TextField(
                            style: const TextStyle(fontSize: 15),
                            controller: _passwordCtr,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            obscureText: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 35),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _submitUser,
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(24, 54, 147, 1),
                minimumSize: const Size(100, 35),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: _submitUser,
              child: const Text(
                'Signup',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
