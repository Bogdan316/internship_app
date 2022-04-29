import 'package:internship_app_fis/dao/base_dao.dart';
import 'package:internship_app_fis/models/internship.dart';
import 'package:mysql1/mysql1.dart';

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
//
// void main() async {
//   var service = InternshipService(BaseDao());
//   var inter = Internship(
//       companyId: 5,
//       title: 'asd',
//       description: 'qwe',
//       fromDate: DateTime.now().toUtc(),
//       toDate: DateTime.now().toUtc(),
//       participantsNum: 10,
//       tag: Tag.cloud,
//       isOngoing: false);
//   print(inter.toMap().values.toList());
//   service.addInternship(inter);
// }
