import 'package:internship_app_fis/dao/base_dao.dart';
import 'package:internship_app_fis/models/user.dart';
import 'package:internship_app_fis/exceptions/user_already_exists.dart';
import 'package:mysql1/mysql1.dart';

class UserService {
  // Class used for communicating with the Company and Student table from
  // the main db

  static Future<User?> getUser(User user) async {
    // Returns Future with the entry from the table for username and password
    // if the user exists, if not then null

    final MySqlConnection dbConn = await BaseDao.initDb;
    final Results result;

    try {
      result = await dbConn.query(
          "SELECT * FROM ${user.runtimeType} WHERE username = ? AND password = ?",
          [user.getUsername, user.getPassword]);
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }

    if (result.isEmpty) {
      return null;
    } else {
      return User.fromMap(result.first);
    }
  }

  static Future<bool> usernameExists(User user) async {
    // Returns true if the user with user.username exists in the table

    final MySqlConnection dbConn = await BaseDao.initDb;
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

  static Future<void> addUser(User user) async {
    // Adds a new user to the database, if a user with the same username already
    // exists throws an exception

    if (await usernameExists(user)) {
      throw UserAlreadyExistsException();
    } else {
      final MySqlConnection dbConn = await BaseDao.initDb;
      final Results result;

      try {
        result = await dbConn.query(
            "INSERT INTO ${user.runtimeType} VALUES (NULL, ?, ?)",
            [user.getUsername, user.getPassword]);
      } on MySqlException {
        rethrow;
      } finally {
        dbConn.close();
      }

      // Get the auto_increment id and set it
      user.setUserId(result.insertId!);
    }
  }

  static Future<void> deleteUser(User user) async {
    // Deletes the user with the matching id

    final MySqlConnection dbConn = await BaseDao.initDb;

    try {
      await dbConn.query(
          "DELETE FROM ${user.runtimeType} WHERE id = ?", [user.getUserId]);
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }
  }
}
