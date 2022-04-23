class User {
  // Class holding the user model that corresponds to the tables from the
  // main db

  int? _id;
  String? _username;
  String? _password;

  User(this._username, this._password);

  String? get getUsername => _username;
  String? get getPassword => _password;
  int? get getUserId => _id;

  User.fromMap(dynamic obj) {
    _id = obj['id'] as int;
    _username = obj['username'] as String;
    _password = obj['password'] as String;
  }

  void setUserId(int id) {
    _id = id;
  }

  @override
  String toString() {
    return runtimeType.toString() +
        ': ' +
        _id.toString() +
        ' ' +
        _username! +
        ' ' +
        _password!;
  }

  Map<String, dynamic> toMap() {
    var userMap = <String, dynamic>{};
    userMap['id'] = _id;
    userMap['username'] = _username;
    userMap['password'] = _password;
    return userMap;
  }

  @override
  bool operator ==(Object other) {
    return other is User &&
        other._password == _password &&
        other._password == _password &&
        other._id == _id;
  }

  @override
  int get hashCode => _username.hashCode ^ _password.hashCode ^ _id.hashCode;
}

class Company extends User {
  // Company model for the Company table

  Company(String username, String password) : super(username, password);
  Company.fromMap(dynamic obj) : super.fromMap(obj);
}

class Student extends User {
  // Student model for the Student table

  Student(String username, String password) : super(username, password);
  Student.fromMap(dynamic obj) : super.fromMap(obj);
}
