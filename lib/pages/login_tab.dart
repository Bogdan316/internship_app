import 'package:flutter/material.dart';

import 'package:internship_app_fis/base_widgets/custom_elevated_button.dart';
import 'package:internship_app_fis/base_widgets/user_input_row.dart';
import 'package:internship_app_fis/services/auth_service.dart';
import 'package:internship_app_fis/services/user_service.dart';

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
  late TextEditingController _usernameCtr;
  late TextEditingController _passwordCtr;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _usernameCtr = TextEditingController();
    _passwordCtr = TextEditingController();
    _authService = AuthService(
        context: context,
        passwordController: _passwordCtr,
        usernameController: _usernameCtr,
        userRole: widget._userRole,
        userService: widget._userService);
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
                      // Username input row
                      UserInputRow(
                        icon: const Icon(
                          Icons.person_outline,
                          size: 30,
                        ),
                        labelText: 'Username',
                        color: themeData.primaryColorDark,
                        controller: _usernameCtr,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Password input row
                      UserInputRow(
                        icon: const Icon(
                          Icons.password_outlined,
                          size: 30,
                        ),
                        labelText: 'Password',
                        controller: _passwordCtr,
                        color: themeData.primaryColorDark,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomElevatedButton(
                            onPressed: () {
                              _authService.loginUser();

                              // clear the text fields after pressing the button
                              setState(() {
                                _usernameCtr.clear();
                                _passwordCtr.clear();
                              });
                            },
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
                onPressed: () {
                  _authService.signupUser();

                  // clear the text fields after pressing the button
                  setState(() {
                    _usernameCtr.clear();
                    _passwordCtr.clear();
                  });
                },
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
