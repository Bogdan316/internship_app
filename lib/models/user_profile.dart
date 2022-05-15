//import './user_profile.dart';

abstract class UserProfile {
  // Class holding the user model that corresponds to the tables from the
  // main db

  int? _id;
  int? _userId;
  String? _fullname;
  String? _email;
  String? _repo;
  String? _about;

  UserProfile({
    required int? id,
    required int? userId,
    required String? fullname,
    required String? email,
    required String? repo,
    required String? about,}): _id=id,
        _userId=userId,
        _fullname = fullname,
        _email =email,
        _repo =repo,
        _about = about;

  int? get getId => _id;

  int? get getUserId => _userId;

  String? get getFullName => _fullname;

  String? get getEmail => _email;

  String? get getRepo => _repo;

  String? get getAbout => _about;

  UserProfile.fromMap(dynamic obj) {
    _id = obj['id'] as int;
    _userId = obj['userId'] as int;
    _fullname = obj['fullname'] as String;
    _email = obj['email'] as String;
    _repo = obj['repo'] as String;
    _about = obj['about'] as String;
  }

  void setProfileId(int id) {
    _id = id;
  }


  Map<String, dynamic> toMap() {
    var userMap = <String, dynamic>{};
    userMap['id'] = _id;
    userMap['userId'] = _userId;
    userMap['fullname'] = _fullname;
    userMap['email'] = _fullname;
    userMap['repo'] = _fullname;
    userMap['about'] = _fullname;
    return userMap;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserProfile &&
              runtimeType == other.runtimeType &&
              _id == other._id &&
              _fullname == other._fullname &&
              _email == other._email &&
              _repo == other._repo &&
              _about == other._about;

  @override
  int get hashCode =>
      _id.hashCode ^
      _fullname.hashCode ^
      _email.hashCode ^
      _repo.hashCode ^
      _about.hashCode;

  @override
  String toString() {
    return 'Profile{_id: $_id, _userId: $_userId, _fullname: $_fullname, _email: $_email, _repo: $_repo, _about: $_about}';
  }
}

class CompanyProfile extends UserProfile{
  // Company model for the Company table

  CompanyProfile(
      {int? id, int? userId, String? fullname, String? email, String? about})
      : super(id:id, userId:userId, fullname:fullname, email:email, repo:null, about:about);
  CompanyProfile.fromMap(dynamic obj) : super.fromMap(obj);
}

class StudentProfile extends UserProfile{
  // Company model for the Company table

  StudentProfile(
      {int? id,
        int? userId,
        String? fullname,
        String? email,
        String? repo,
        String? about})
      : super(id:id, userId:userId, fullname:fullname, email:email, repo:repo, about:about);
  StudentProfile.fromMap(dynamic obj) : super.fromMap(obj);
}
