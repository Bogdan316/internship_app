import 'package:mysql1/mysql1.dart';

import '../environment/environment.dart';

class BaseDao {
  // Class used for connecting to the main db

  static final settings = ConnectionSettings(
    // The ip, password, user and schema needed for connecting to the database
    // are taken from the environment at compile time
    host: Environment.dbHost,
    port: 3306,
    user: Environment.dbUser,
    password: Environment.dbPasswd,
    db: Environment.dbSchema,
  );

  Future<MySqlConnection> get initDb async {
    // Returns connection object for the main db
    var conn = await MySqlConnection.connect(settings);
    return conn;
  }
}
