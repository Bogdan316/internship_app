import 'package:test/test.dart';

import 'package:internship_app_fis/dao/base_dao.dart';
import 'package:internship_app_fis/exceptions/user_already_exists.dart';
import 'package:internship_app_fis/models/user.dart';
import 'package:internship_app_fis/services/user_service.dart';

void main() {
  User newUser = Company('test_user', 'test_user');
  BaseDao dao = BaseDao();
  UserService service = UserService(dao);

  group('UserService', () {
    test('user should not exist', () async {
      expect(await service.usernameExists(newUser), false);
    });

    test('user should not exist and return value should be null', () async {
      var user = await service.getUser(newUser);
      expect(user == null, true);
    });

    test('new user should be added', () async {
      await service.addUser(newUser);
      expect(newUser.getUserId != null, true);
    });

    test('user should exist', () async {
      expect(await service.usernameExists(newUser), true);
    });

    test('user should exist and return value should not be null', () async {
      var user = await service.getUser(newUser);
      expect(
          user?.getUsername == newUser.getUsername &&
              user?.getPassword == newUser.getPassword,
          true);
    });

    test('user should already exist and not be added', () async {
      expect(() async => await service.addUser(newUser),
          throwsA(const TypeMatcher<UserAlreadyExistsException>()));
    });

    test('user should be deleted', () async {
      await service.deleteUser(newUser);
      expect(await service.usernameExists(newUser), false);
    });
  });
}
