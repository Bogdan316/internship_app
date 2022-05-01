import './user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserPreferences{
  static late SharedPreferences _preferences;

  static const _keyUser = 'user';
  static const myUser = User(
    imagePath: 'https://www.w3schools.com/images/w3schools_green.jpg',
    name: 'Sarah Abs',
    email: 'sarah.abs@gmail.com',
    about: 'Certified Personal Trainer',
    repo: 'https://www.w3schools.com/images/w3schools_green.jpg',
    isDarkMode: false,
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    //final json = jsonEncode(user.toJson());

    //await _preferences.setString(_keyUser, json);
  }

  static User getUser(){
    //final json = _preferences.getString(_keyUser);
        return myUser;
    //return json == null ? myUser : User.fromJson(jsonDecode(json));
  }

}

//import './user.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'dart:convert';
/*
class UserPreferences{
  late SharedPreferences _preferences;

  static const _keyUser = 'user';
  static const myUser = User(
    imagePath: 'https://www.w3schools.com/images/w3schools_green.jpg',
      name: 'Sarah Abs',
      email: 'sarah.abs@gmail.com',
      about: 'Certified Personal Trainer',
      repo: 'https://www.w3schools.com/images/w3schools_green.jpg',
    isDarkMode: false,
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static User getUser(){
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }

}*/