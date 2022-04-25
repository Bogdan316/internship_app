import 'dart:async';
import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysql1/mysql1.dart';
import 'package:test/test.dart';

import 'package:internship_app_fis/dao/base_dao.dart';
import 'package:internship_app_fis/exceptions/user_already_exists.dart';
import 'package:internship_app_fis/models/user.dart';
import 'package:internship_app_fis/services/user_service.dart';

import 'user_service_unit_test.mocks.dart';

@GenerateMocks([
  BaseDao,
  Future,
  MySqlConnection
], customMocks: [
  MockSpec<Results>(unsupportedMembers: {#fold})
])
void main() {
  group('UserService - live database:', () {
    User newUser = Company('test_user', 'test_user');
    BaseDao dao = BaseDao();
    UserService service = UserService(dao);

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
      expect(user, newUser);
    });

    test('user should already exist and not be added', () async {
      var caughtException = false;
      try {
        await service.addUser(newUser);
      } on UserAlreadyExistsException catch (e) {
        expect(e.toString(), 'The username already exists.');
        caughtException = true;
      }

      expect(caughtException, true);
    });

    test('user should be deleted', () async {
      await service.deleteUser(newUser);
      expect(await service.usernameExists(newUser), false);
    });
  });

  group('UserService - MySql exceptions:', () {
    User newUser = Company('test_user', 'test_user');
    var mockDao = MockBaseDao();
    var userService = UserService(mockDao);
    var mockMySqlConnection = MockMySqlConnection();

    test('getUser should throw MySqlException', () {
      when(mockDao.initDb).thenAnswer((_) => Future.value(mockMySqlConnection));

      when(mockMySqlConnection.query(
          "SELECT * FROM ${newUser.runtimeType} WHERE username = ? AND password = ?",
          [
            newUser.getUsername,
            newUser.getPassword
          ])).thenAnswer((_) => throw const SocketException('Test exception'));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());

      expect(userService.getUser(newUser), throwsA(isA<SocketException>()));
    });

    test('usernameExists should throw MySqlException', () {
      when(mockDao.initDb).thenAnswer((_) => Future.value(mockMySqlConnection));

      when(mockMySqlConnection.query(
              "SELECT * FROM ${newUser.runtimeType} WHERE username = ?",
              [newUser.getUsername]))
          .thenAnswer((_) => throw const SocketException('Test exception'));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());

      expect(
          userService.usernameExists(newUser), throwsA(isA<SocketException>()));
    });

    test('addUser should throw MySqlException', () {
      var mockResult = MockResults();

      when(mockMySqlConnection.query(
          "SELECT * FROM ${newUser.runtimeType} WHERE username = ?",
          [newUser.getUsername])).thenAnswer((_) => Future.value(mockResult));

      when(mockResult.isNotEmpty).thenAnswer((_) => false);

      when(mockDao.initDb).thenAnswer((_) => Future.value(mockMySqlConnection));

      when(mockMySqlConnection.query(
              "INSERT INTO ${newUser.runtimeType} VALUES (NULL, ?, ?)",
              [newUser.getUsername, newUser.getPassword]))
          .thenAnswer((_) => throw const SocketException('Test exception'));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());

      expect(userService.addUser(newUser), throwsA(isA<SocketException>()));
    });

    test('deleteUser should throw MySqlException', () {
      when(mockDao.initDb).thenAnswer((_) => Future.value(mockMySqlConnection));

      when(mockMySqlConnection.query(
              "DELETE FROM ${newUser.runtimeType} WHERE id = ?",
              [newUser.getUserId]))
          .thenAnswer((_) => throw const SocketException('Test exception'));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());

      expect(userService.deleteUser(newUser), throwsA(isA<SocketException>()));
    });
  });
}
