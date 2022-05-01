class Environment {
  // Class used for retrieving compile time variables
  // use flutter run --dart-define to define these variables
  static const dbHost = '192.168.56.1';//String.fromEnvironment('DB_HOST');
  static const dbUser = 'root';//String.fromEnvironment('DB_USER');//root
  static const dbPasswd = 'FocaMagica5';//String.fromEnvironment('DB_PASSWD');
  static const dbSchema = 'internshipappdb';//String.fromEnvironment('DB_SCHEMA');
}
