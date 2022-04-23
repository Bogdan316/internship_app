import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'package:internship_app_fis/base_widgets/custom_elevated_button.dart';
import 'package:internship_app_fis/exceptions/user_already_exists.dart';
import 'package:internship_app_fis/services/user_service.dart';
import 'package:internship_app_fis/models/user.dart';
import 'package:internship_app_fis/base_widgets/custom_snack_bar.dart';

class LoginTab extends StatefulWidget {
  // Login tab that handles the user signup/login, password encryption and username
  // and password storage based on the user role: Student/Company
  final String _userRole;
  final UserService _userService;

  const LoginTab(this._userRole, this._userService, {Key? key})
      : super(key: key);

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final _usernameCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  User? _formInputValidation() {
    // Reads the input from the two controllers, if it is not empty returns
    // a new user with the username and the encrypted password

    if (_usernameCtr.text.isEmpty || _passwordCtr.text.isEmpty) {
      // Check if the input fields are empty
      final snackBar =
          MessageSnackBar('The username and password fields are mandatory.');
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return null;
    }

    // Password encryption
    var encPass = utf8.encode(_passwordCtr.text);
    var passHashValue = sha1.convert(encPass).toString();

    // Return a user object based on the user role
    if (widget._userRole == 'Student') {
      return Student(_usernameCtr.text, passHashValue);
    } else {
      return Company(_usernameCtr.text, passHashValue);
    }
  }

  void _signupUser() async {
    // Gets the validated form input, if it is not empty then
    // checks that a user with the same username does not exist, if true then
    // adds the new user into the database

    var user = _formInputValidation();

    if (user == null) {
      return;
    }

    if (_passwordCtr.text.length < 5) {
      final snackBar = MessageSnackBar('The password is too short.');
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return null;
    }

    try {
      // Create a new user based on the role selected in the constructor
      if (widget._userRole == 'Student') {
        await widget._userService.addUser(user);
      } else {
        await widget._userService.addUser(user);
      }

      final snackBar = MessageSnackBar('Successful Signup.');
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on UserAlreadyExistsException catch (e) {
      final snackBar = MessageSnackBar(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // If adding the user ended with success, clear the text fields
    setState(() {
      _usernameCtr.clear();
      _passwordCtr.clear();
    });
  }

  void _loginUser() async {
    // Gets the validated form input, if it is not empty then
    // checks that a user with the same username and password exists in the database,
    // if true then logs in the user

    var user = _formInputValidation();

    if (user == null) {
      return;
    }

    var userEntry = await widget._userService.getUser(user);

    if (userEntry == null) {
      final snackBar = MessageSnackBar('Wrong username or password.');
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = MessageSnackBar('Successful Login.');
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // clear the text fields at the end
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
    // get MediaQuery and Theme data at the begging to avoid redundant
    // calls to build
    var mediaQuery = MediaQuery.of(context);
    var themeData = Theme.of(context);

    return GestureDetector(
      // Ensure that when the user taps the screen the TextFields will unfocus
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        // Background container
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            // Holds the Login and Signup forms
            children: [
              Container(
                // Top container that holds the Login form
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                height: mediaQuery.size.height * 0.35,
                margin: EdgeInsets.fromLTRB(
                    20, mediaQuery.size.height * 0.15, 20, 25),
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Login form
                    children: [
                      Row(
                        // Username input row
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 15,
                                  color: themeData.primaryColor,
                                ),
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
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        // Password input row
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.password_outlined,
                            size: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 15,
                                  color: themeData.primaryColor,
                                ),
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
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomElevatedButton(
                            onPressed: _loginUser,
                            label: 'Login',
                            primary: themeData.primaryColorLight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              CustomElevatedButton(
                onPressed: _signupUser,
                label: 'Signup',
                primary: themeData.primaryColorDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
