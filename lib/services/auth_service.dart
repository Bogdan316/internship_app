import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../services/user_service.dart';
import '../base_widgets/custom_snack_bar.dart';
import '../exceptions/user_already_exists.dart';
import '../models/user.dart';

class AuthService {
  final TextEditingController _usernameCtr;
  final TextEditingController _passwordCtr;
  final String _userRole;
  final BuildContext _context;
  final UserService _userService;

  static const _minPasswdLength = 5;

  const AuthService(
      {required context,
      required passwordController,
      required usernameController,
      required userRole,
      required userService})
      : _context = context,
        _passwordCtr = passwordController,
        _usernameCtr = usernameController,
        _userRole = userRole,
        _userService = userService;

  String _encryptPassword(String passwd) {
    // Encrypts and returns the password

    var encPass = utf8.encode(passwd);
    var passHashValue = sha1.convert(encPass).toString();
    return passHashValue;
  }

  User? _formInputValidation() {
    // Reads the input from the two controllers, if it is not empty returns
    // a new user with the username and the encrypted password

    if (_usernameCtr.text.isEmpty || _passwordCtr.text.isEmpty) {
      // Check if the input fields are empty
      final snackBar =
          MessageSnackBar('The username and password fields are mandatory.');
      ScaffoldMessenger.of(_context).showSnackBar(snackBar);

      return null;
    }

    // Return a user object based on the user role
    if (_userRole == 'Student') {
      return Student(_usernameCtr.text, _encryptPassword(_passwordCtr.text));
    } else {
      return Company(_usernameCtr.text, _encryptPassword(_passwordCtr.text));
    }
  }

  Future<User?> signupUser() async {
    // Gets the validated form input, if it is not empty then
    // checks that a user with the same username does not exist, if true then
    // adds the new user into the database and returns it

    var user = _formInputValidation();

    if (user == null) {
      return null;
    }

    if (_passwordCtr.text.length < _minPasswdLength) {
      final snackBar = MessageSnackBar('The password is too short.');
      ScaffoldMessenger.of(_context).showSnackBar(snackBar);

      return null;
    }

    try {
      await _userService.addUser(user);
      return user;
    } on UserAlreadyExistsException catch (e) {
      final snackBar = MessageSnackBar(e.toString());
      ScaffoldMessenger.of(_context).showSnackBar(snackBar);

      return null;
    }
  }

  Future<User?> loginUser() async {
    // Gets the validated form input, if it is not empty then
    // checks that a user with the same username and password exists in the database,
    // if true then logs in the user and returns it

    var user = _formInputValidation();

    if (user == null) {
      return null;
    }

    var userEntry = await _userService.getUser(user);

    if (userEntry == null) {
      final snackBar = MessageSnackBar('Wrong username or password.');
      ScaffoldMessenger.of(_context).showSnackBar(snackBar);

      return null;
    } else {
      return userEntry;
    }
  }
}
