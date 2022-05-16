import 'dart:io';

import 'package:internship_app_fis/dao/base_dao.dart';
import 'package:internship_app_fis/models/internship.dart';
import 'package:internship_app_fis/models/user.dart';
import 'package:internship_app_fis/services/internship_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mysql1/mysql1.dart';

import 'internship_service_unit_test.mocks.dart';

@GenerateMocks([
  BaseDao,
  Future,
  MySqlConnection
], customMocks: [
  MockSpec<Results>(unsupportedMembers: {#fold})
])
void main() {
  late DateTime now;
  late Internship testInter;
  late MockBaseDao mockBaseDao;
  late MockMySqlConnection mockMySqlConnection;
  late MockResults mockResults;
  late InternshipService service;
  late Company testCompany;

  setUp(() {
    mockBaseDao = MockBaseDao();
    service = InternshipService(mockBaseDao);
    mockMySqlConnection = MockMySqlConnection();
    mockResults = MockResults();
    now = DateTime.now();
    testCompany = Company('test', 'test');
    testCompany.setUserId(1);
    testInter = Internship(
        companyId: 1,
        title: 'test',
        description: 'test',
        requirements: 'test',
        fromDate: now.toUtc(),
        toDate: now.toUtc(),
        participantsNum: 10,
        tag: Tag.values[3],
        isOngoing: true);
  });

  group('Internship Service:', () {
    test('addInternship should insert internship into table', () async {
      when(mockBaseDao.initDb)
          .thenAnswer((_) => Future.value(mockMySqlConnection));
      when(mockMySqlConnection.query(
              "INSERT INTO Internship VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
              testInter.toMap().values.toList()))
          .thenAnswer((_) => Future.value(mockResults));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());
      when(mockResults.insertId).thenReturn(1);

      await service.addInternship(testInter);
      expect(testInter.getId, 1);

      testInter.setId = null;
      verify(mockMySqlConnection.query(
          "INSERT INTO Internship VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
          testInter.toMap().values.toList()));
    });

    test('addInternship should throw MySqlException', () {
      when(mockBaseDao.initDb)
          .thenAnswer((_) => Future.value(mockMySqlConnection));
      when(mockMySqlConnection.query(
              "INSERT INTO Internship VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
              testInter.toMap().values.toList()))
          .thenAnswer((_) => throw const SocketException('Test exception'));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());

      expect(service.addInternship(testInter), throwsA(isA<SocketException>()));
    });

    test(
        'getAllCompanyInternships should query the database for all internships',
        () async {
      when(mockBaseDao.initDb)
          .thenAnswer((_) => Future.value(mockMySqlConnection));
      when(mockMySqlConnection.query(
              "SELECT * FROM Internship where companyId = ? and isOngoing=1;",
              [testCompany.getUserId]))
          .thenAnswer((_) => Future.value(mockResults));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());

      when(mockResults.map(any)).thenReturn(<Internship>[]);

      await service.getAllCompanyInternships(testCompany);

      verify(mockMySqlConnection.query(
          "SELECT * FROM Internship where companyId = ? and isOngoing=1;",
          [testCompany.getUserId]));
      verify(mockResults.map(any));
    });

    test('getAllCompanyInternships should throw MySqlException', () {
      when(mockBaseDao.initDb)
          .thenAnswer((_) => Future.value(mockMySqlConnection));
      when(mockMySqlConnection.query(
              "SELECT * FROM Internship where companyId = ? and isOngoing=1;",
              [testCompany.getUserId]))
          .thenAnswer((_) => throw const SocketException('Test exception'));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());

      expect(service.getAllCompanyInternships(testCompany),
          throwsA(isA<SocketException>()));
    });

    test('deleteInternship should query the database', () async {
      when(mockBaseDao.initDb)
          .thenAnswer((_) => Future.value(mockMySqlConnection));
      when(mockMySqlConnection
              .query("DELETE FROM Internship where id = ?;", [testInter.getId]))
          .thenAnswer((_) => Future.value(mockResults));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());
      await service.deleteInternship(testInter);
      verify(mockMySqlConnection
          .query("DELETE FROM Internship where id = ?;", [testInter.getId]));
    });

    test('deleteInternship should throw MySqlException', () {
      when(mockBaseDao.initDb)
          .thenAnswer((_) => Future.value(mockMySqlConnection));
      when(mockMySqlConnection
              .query("DELETE FROM Internship where id = ?;", [testInter.getId]))
          .thenAnswer((_) => throw const SocketException('Test exception'));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());

      expect(
          service.deleteInternship(testInter), throwsA(isA<SocketException>()));
    });

    test('updateInternship should query the database', () async {
      when(mockBaseDao.initDb)
          .thenAnswer((_) => Future.value(mockMySqlConnection));
      var queryValues = testInter.toMap().values.toList().sublist(1);
      queryValues.add(testInter.getId);
      when(mockMySqlConnection.query(
              'UPDATE Internship SET `companyId` = ?, `title` = ?, '
              '`description` = ?, `requirements` = ?, `fromDate` = ?, `toDate` = ?, '
              '`participantsNum` = ?, `tag` = ?, `isOngoing` = ? WHERE `id` = ?;',
              queryValues))
          .thenAnswer((_) => Future.value(mockResults));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());
      await service.updateInternship(testInter);
      verify(mockMySqlConnection.query(
          'UPDATE Internship SET `companyId` = ?, `title` = ?, '
          '`description` = ?, `requirements` = ?, `fromDate` = ?, `toDate` = ?, '
          '`participantsNum` = ?, `tag` = ?, `isOngoing` = ? WHERE `id` = ?;',
          queryValues));
    });

    test('updateInternship should throw MySqlException', () async {
      when(mockBaseDao.initDb)
          .thenAnswer((_) => Future.value(mockMySqlConnection));
      var queryValues = testInter.toMap().values.toList().sublist(1);
      queryValues.add(testInter.getId);
      when(mockMySqlConnection.query(
              'UPDATE Internship SET `companyId` = ?, `title` = ?, '
              '`description` = ?, `requirements` = ?, `fromDate` = ?, `toDate` = ?, '
              '`participantsNum` = ?, `tag` = ?, `isOngoing` = ? WHERE `id` = ?;',
              queryValues))
          .thenAnswer((_) => throw const SocketException('Test exception'));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());

      expect(
          service.updateInternship(testInter), throwsA(isA<SocketException>()));
    });
  });
}
