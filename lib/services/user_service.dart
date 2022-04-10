import 'package:internship_app_fis/dao/base_dao.dart';
import 'package:internship_app_fis/models/user.dart';
import 'package:internship_app_fis/exceptions/user_already_exists.dart';

class UserService {
  // Class used for communicating with the Company and Student table from
  // the main db

  static Future<User?> getUser(User user) async {
    // Returns Future with the entry from the table for username and password
    // if the user exists, if not then null

    var dbConn = await BaseDao.initDb;
    var result = await dbConn.query(
        "SELECT * FROM ${user.runtimeType} WHERE username = ? AND password = ?",
        [user.getUsername, user.getPassword]);
    dbConn.close();

    if (result.isEmpty) {
      return null;
    } else {
      return User.fromMap(result.first);
    }
  }

  static Future<bool> userExists(User user) async {
    // Returns true if the user with user.username exists in the table

    var dbConn = await BaseDao.initDb;
    var result = await dbConn.query(
        "SELECT * FROM ${user.runtimeType} WHERE username = ?",
        [user.getUsername]);
    dbConn.close();

    return result.isNotEmpty;
  }

  static Future<void> addUser(User user) async {
    // Adds a new user to the database, if a user with the same username already
    // exists throws an exception

    if (await userExists(user)) {
      throw UserAlreadyExistsException();
    } else {
      var dbConn = await BaseDao.initDb;
      await dbConn.query("INSERT INTO ${user.runtimeType} VALUES (NULL, ?, ?)",
          [user.getUsername, user.getPassword]);
      dbConn.close();
    }
  }
}
