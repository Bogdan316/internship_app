class Environment {
  // Class used for retrieving compile time variables
  // use flutter run --dart-define to define these variables
  static const dbHost = String.fromEnvironment('DB_HOST');
  static const dbUser = String.fromEnvironment('DB_USER');
  static const dbPasswd = String.fromEnvironment('DB_PASSWD');
  static const dbSchema = String.fromEnvironment('DB_SCHEMA');
}
