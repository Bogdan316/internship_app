import 'package:internship_app_fis/models/internship.dart';
import 'package:mysql1/mysql1.dart';

import '../dao/base_dao.dart';
import '../models/user_profile.dart';
import '../models/user.dart';

class UserProfileService {
  final BaseDao _dao;

  UserProfileService(this._dao);

  Future<UserProfile?> getUserProfileById(User user) async {
    // Returns Future with the entry from the table for username and password
    // if the user exists, if not then null

    final MySqlConnection dbConn = await _dao.initDb;
    final Results result;

    try {
      result = await dbConn.query(
          "SELECT * FROM ${user.runtimeType}Profile WHERE id = ?;",
          [user.getUserId]);
      print(result.first);
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }

    if (result.isEmpty) {
      return null;
    } else {
      if (user.runtimeType == Company) {
        return CompanyProfile.fromMap(result.first);
      } else {
        return StudentProfile.fromMap(result.first);
      }
    }
  }

  Future<void> addUserProfile(UserProfile profile) async {
    // Adds a new user to the database, if a user with the same username already
    // exists throws an exception

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

    // Get the auto_increment id and set it
    profile.setProfileId(result.insertId!);
  }

  Future<List<CompanyProfile>> getAllCompanyProfiles() async {
    final MySqlConnection dbConn = await _dao.initDb;
    final Results result;

    try {
      result = await dbConn.query("SELECT * FROM CompanyProfile;");
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }

    return result.map((e) => CompanyProfile.fromMap(e)).toList();
  }

  Future<List<StudentProfile>> getAcceptedParticipantsList(
      Internship internship) async {
    final MySqlConnection dbConn = await _dao.initDb;
    final Results result;

    try {
      result = await dbConn.query(
          "select studentProfile.id, userId, imageLink, fullname, email, cvLink, repo, about from studentProfile join acceptedParticipants on studentProfile.id = acceptedParticipants.profileId where internshipId = ?;",
          [internship.getId]);
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }
    if (result.isNotEmpty) {
      return result.map((e) => StudentProfile.fromMap(e)).toList();
    } else {
      return <StudentProfile>[];
    }
  }

  Future<List<StudentProfile>> getStudentProfilesByInternshipId(
      Internship internship) async {
    final MySqlConnection dbConn = await _dao.initDb;
    final Results result;

    try {
      result = await dbConn.query(
          "select id, userId, imageLink, fullname, email, cvLink, repo, about from StudentProfile where userId in (select studentId from InternshipApplication where internshipId = ?);",
          [internship.getId]);
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }

    return result.map((e) => StudentProfile.fromMap(e)).toList();
  }

  Future<void> addAcceptedParticipantsList(
      Internship internship, List<UserProfile> userProfiles) async {
    final MySqlConnection dbConn = await _dao.initDb;
    final Results result;

    final queryPlaceholder =
        userProfiles.map((e) => '(NULL, ?, ?, ?)').join(', ');
    final insertData = userProfiles
        .map((profile) => [profile.getUserId, profile.getId, internship.getId])
        .expand((ids) => ids)
        .toList();
    try {
      await dbConn.query(
          "DELETE FROM acceptedParticipants WHERE internshipId = ?;",
          [internship.getId]);
      result = await dbConn.query(
          "INSERT INTO acceptedParticipants VALUES $queryPlaceholder;",
          insertData);
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    final MySqlConnection dbConn = await _dao.initDb;

    try {
      await dbConn.query(
          "UPDATE ${profile.runtimeType} SET `userId` = ?, `imageLink` = ?, "
          "`fullname` = ?, `email` = ?, `cvLink` = ?, `repo` = ?, "
          "`about` = ? WHERE `id` = ?;",
          [...profile.toMap().values.toList().sublist(1), profile.getId]);
    } on MySqlException {
      rethrow;
    } finally {
      dbConn.close();
    }
  }
}
