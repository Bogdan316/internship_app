import 'package:mysql1/mysql1.dart';

import '../dao/base_dao.dart';
import '../models/user_profile.dart';
import '../exceptions/user_already_exists.dart';
import '../models/user.dart';


class UserProfileService{
  final BaseDao _dao;

  UserProfileService(this._dao);

  Future<UserProfile?> getUserProfileById(User user,UserProfile profile) async {
    // Returns Future with the entry from the table for username and password
    // if the user exists, if not then null

    final MySqlConnection dbConn = await _dao.initDb;
    final Results result;

    try {
      result = await dbConn.query(
          "SELECT * FROM ${profile.runtimeType} WHERE id = ?",
          [user.getUserId]);
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }

    if (result.isEmpty) {
      return null;
    } else {
      if (profile.runtimeType == CompanyProfile) {
        return CompanyProfile.fromMap(result.first);
      } else {
        return StudentProfile.fromMap(result.first);
      }
    }
  }

  Future<bool> usernameExists(User user) async {
    // Returns true if the user with user.username exists in the table

    final MySqlConnection dbConn = await _dao.initDb;
    final Results result;

    try {
      result = await dbConn.query(
          "SELECT * FROM ${user.runtimeType} WHERE username = ?",
          [user.getUsername]);
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }

    return result.isNotEmpty;
  }

  Future<void> addUserProfile(UserProfile profile) async {
    // Adds a new user to the database, if a user with the same username already
    // exists throws an exception

      final MySqlConnection dbConn = await _dao.initDb;
      final Results result;

      try {
        print(profile.toMap().values.toList());
        result = await dbConn.query(
            "INSERT INTO ${profile.runtimeType} VALUES (?, ?, ?, ?, ?, ?)",
            profile.toMap().values.toList());
      } on MySqlException {
        rethrow;
      } finally {
        dbConn.close();
      }

      // Get the auto_increment id and set it
      profile.setProfileId(result.insertId!);
  }
}






