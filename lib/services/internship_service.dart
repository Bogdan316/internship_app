import 'package:mysql1/mysql1.dart';

import '../dao/base_dao.dart';
import '../models/internship.dart';
import '../models/user.dart';

class InternshipService {
  final BaseDao _dao;

  InternshipService(this._dao);

  Future<void> addInternship(Internship internship) async {
    final MySqlConnection dbConn = await _dao.initDb;
    final Results results;

    try {
      assert(internship.getId == null);
      results = await dbConn.query(
          "INSERT INTO Internship VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);",
          internship.toMap().values.toList());
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }

    internship.setId = results.insertId!;
  }

  Future<List<Internship>> getAllCompanyInternships(Company company) async {
    final MySqlConnection dbConn = await _dao.initDb;
    final Results results;

    try {
      results = await dbConn.query(
          'SELECT * FROM Internship where companyId = ? and isOngoing=1;',
          [company.getUserId]);
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }

    return results.map((e) => Internship.fromMap(e)).toList();
  }

  Future<void> deleteInternship(Internship internship) async {
    final MySqlConnection dbConn = await _dao.initDb;

    try {
      await dbConn
          .query('DELETE FROM Internship where id = ?;', [internship.getId]);
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }
  }
}
