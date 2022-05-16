import 'package:mysql1/mysql1.dart';

import '../dao/base_dao.dart';
import '../models/user_profile.dart';
import '../models/user.dart';


class UserProfileService{
  final BaseDao _dao;

  UserProfileService(this._dao);

  Future<UserProfile?> getUserProfileById(User user,UserProfile profile) async {

    final MySqlConnection dbConn = await _dao.initDb;
    final Results result;

    try {
      result = await dbConn.query(
          "SELECT * FROM ${profile.runtimeType} WHERE id = ?",
          [user.getUserId]);
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }

    if (result.isEmpty) {
      return null;
    } else {
      if (profile.runtimeType == CompanyProfile) {
        return CompanyProfile.fromMap(result.first);
      } else {
        return StudentProfile.fromMap(result.first);
      }
    }
  }

  Future<void> addUserProfile(UserProfile profile) async {

    final MySqlConnection dbConn = await _dao.initDb;
    final Results result;

    try {
      result = await dbConn.query(
          "INSERT INTO ${profile.runtimeType} VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
          profile.toMap().values.toList());
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }

    profile.setProfileId(result.insertId!);
  }
}






