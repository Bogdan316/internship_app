import 'dart:io';

import 'package:internship_app_fis/dao/base_dao.dart';
import 'package:internship_app_fis/models/internship.dart';
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

  setUp(() {
    mockBaseDao = MockBaseDao();
    service = InternshipService(mockBaseDao);
    mockMySqlConnection = MockMySqlConnection();
    mockResults = MockResults();
    now = DateTime.now();
    testInter = Internship(
        companyId: 1,
        title: 'test',
        description: 'test',
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
              "INSERT INTO Internship VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);",
              testInter.toMap().values.toList()))
          .thenAnswer((_) => Future.value(mockResults));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());
      when(mockResults.insertId).thenReturn(1);

      await service.addInternship(testInter);
      expect(testInter.getId, 1);

      testInter.setId = null;
      verify(mockMySqlConnection.query(
          "INSERT INTO Internship VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);",
          testInter.toMap().values.toList()));
    });
    test('addInternship should throw MySqlException', () {
      when(mockBaseDao.initDb)
          .thenAnswer((_) => Future.value(mockMySqlConnection));
      when(mockMySqlConnection.query(
              "INSERT INTO Internship VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);",
              testInter.toMap().values.toList()))
          .thenAnswer((_) => throw const SocketException('Test exception'));

      when(mockMySqlConnection.close()).thenAnswer((_) => MockFuture());

      expect(service.addInternship(testInter), throwsA(isA<SocketException>()));
    });
  });
}
