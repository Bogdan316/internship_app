import 'package:internship_app_fis/models/internship_application.dart';
import 'package:mysql1/mysql1.dart';

import '../dao/base_dao.dart';
import '../models/internship.dart';
import '../models/user.dart';

class InternshipApplicationService {
  // Class used for communicating with the Internship table from
  // the main db

  final BaseDao _dao;

  InternshipApplicationService(this._dao,);

  Future<void> addInternshipApplication(InternshipApplication internship) async {
    // Adds the provided internship in the database

    final MySqlConnection dbConn = await _dao.initDb;
    final Results results;

    try {
      assert(internship.getId == null);
      results = await dbConn.query(
          "INSERT INTO InternshipApplication VALUES (?, ?, ?);",
          internship.toMap().values.toList());
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }

    internship.setId = results.insertId!;
  }

  Future<void> deleteInternshipApplication(Internship internship) async {
    // Deletes the provided internship from the database

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
