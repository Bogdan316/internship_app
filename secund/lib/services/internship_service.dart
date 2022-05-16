import 'package:mysql1/mysql1.dart';

import '../dao/base_dao.dart';
import '../models/internship.dart';

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
}
