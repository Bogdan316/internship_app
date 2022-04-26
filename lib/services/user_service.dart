import 'package:mysql1/mysql1.dart';

import '../dao/base_dao.dart';
import '../models/user.dart';
import '../exceptions/user_already_exists.dart';

class UserService {
  // Class used for communicating with the Company and Student table from
  // the main db

  final BaseDao _dao;

  UserService(this._dao);

  Future<User?> getUser(User user) async {
    // Returns Future with the entry from the table for username and password
    // if the user exists, if not then null

    final MySqlConnection dbConn = await _dao.initDb;
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
      if (user.runtimeType == Company) {
        return Company.fromMap(result.first);
      } else {
        return Student.fromMap(result.first);
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

  Future<void> addUser(User user) async {
    // Adds a new user to the database, if a user with the same username already
    // exists throws an exception

    if (await usernameExists(user)) {
      throw UserAlreadyExistsException();
    } else {
      final MySqlConnection dbConn = await _dao.initDb;
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

  Future<void> deleteUser(User user) async {
    // Deletes the user with the matching id

    final MySqlConnection dbConn = await _dao.initDb;

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
