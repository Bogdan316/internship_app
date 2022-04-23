import 'package:internship_app_fis/models/user.dart';
import 'package:test/test.dart';

void main() {
  var userMap = {
    'id': 1,
    'username': 'test_user',
    'password': 'test_pass',
  };

  group('User Model - Company:', () {
    test('user should be created from map', () {
      var user = Company.fromMap(userMap);

      expect(
          user.getUserId == userMap['id'] &&
              user.getUsername == userMap['username'] &&
              user.getPassword == userMap['password'],
          true);
    });

    test('user should be converted to map', () {
      var user = Company('test_user', 'test_pass');
      user.setUserId(1);
      var mapFromUser = user.toMap();

      expect(
          user.getUserId == mapFromUser['id'] &&
              user.getUsername == mapFromUser['username'] &&
              user.getPassword == mapFromUser['password'],
          true);
    });

    test('user should have toString method', () {
      var user = Company('test_user', 'test_pass');
      user.setUserId(1);

      expect(user.toString(), 'Company: 1 test_user test_pass');
    });

    test('user should have hasCode getter', () {
      var user = Company('test_user', 'test_pass');
      user.setUserId(1);

      expect(
          user.hashCode,
          user.getUserId.hashCode ^
              user.getUsername.hashCode ^
              user.getPassword.hashCode);
    });
  });

  group('User Model - Student:', () {
    test('user should be created from map', () {
      var user = Student.fromMap(userMap);

      expect(
          user.getUserId == userMap['id'] &&
              user.getUsername == userMap['username'] &&
              user.getPassword == userMap['password'],
          true);
    });

    test('user should be converted to map', () {
      var user = Student('test_user', 'test_pass');
      user.setUserId(1);
      var mapFromUser = user.toMap();

      expect(
          user.getUserId == mapFromUser['id'] &&
              user.getUsername == mapFromUser['username'] &&
              user.getPassword == mapFromUser['password'],
          true);
    });

    test('user should have toString method', () {
      var user = Student('test_user', 'test_pass');
      user.setUserId(1);

      expect(user.toString(), 'Student: 1 test_user test_pass');
    });

    test('user should have hasCode getter', () {
      var user = Company('test_user', 'test_pass');
      user.setUserId(1);

      expect(
          user.hashCode,
          user.getUserId.hashCode ^
              user.getUsername.hashCode ^
              user.getPassword.hashCode);
    });
  });
}
