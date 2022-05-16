//import './user_profile.dart';

abstract class UserProfile {
  // Class holding the user model that corresponds to the tables from the
  // main db

  int? _id;
  int? _userId;
  String? _imageLink;
  String? _fullname;
  String? _email;
  String? _cvLink;
  String? _repo;
  String? _about;

  UserProfile({
    required int? id,
    required int? userId,
    required String? imageLink,
    required String? fullname,
    required String? email,
    required String? cvLink,
    required String? repo,
    required String? about,}): _id=id,
        _userId=userId,
        _imageLink=imageLink,
        _fullname = fullname,
        _email =email,
        _cvLink=cvLink,
        _repo =repo,
        _about = about;

  int? get getId => _id;

  int? get getUserId => _userId;

  String? get getImageLink => _imageLink;

  String? get getFullName => _fullname;

  String? get getEmail => _email;

  String? get getCvLink => _cvLink;

  String? get getRepo => _repo;

  String? get getAbout => _about;

  UserProfile.fromMap(dynamic obj) {
    _id = obj['id'] as int;
    _userId = obj['userId'] as int;
    _imageLink = obj['imageLink'] as String;
    _fullname = obj['fullname'] as String;
    _email = obj['email'] as String;
    _cvLink = obj['cvLink'] as String;
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
    userMap['imageLink'] = _imageLink;
    userMap['fullname'] = _fullname;
    userMap['email'] = _email;
    userMap['cvLink'] = _cvLink;
    userMap['repo'] = _repo;
    userMap['about'] = _about;
    return userMap;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserProfile &&
              runtimeType == other.runtimeType &&
              _id == other._id &&
              _imageLink == other._imageLink &&
              _fullname == other._fullname &&
              _email == other._email &&
              _cvLink == other._cvLink &&
              _repo == other._repo &&
              _about == other._about;

  @override
  int get hashCode =>
      _id.hashCode ^
      _imageLink.hashCode ^
      _fullname.hashCode ^
      _email.hashCode ^
      _cvLink.hashCode ^
      _repo.hashCode ^
      _about.hashCode;

  @override
  String toString() {
    return 'Profile{_id: $_id, _userId: $_userId, _imageLink: $_imageLink, _fullname: $_fullname, _email: $_email, _cvLink: $_cvLink,  _repo: $_repo, _about: $_about}';
  }
}

class CompanyProfile extends UserProfile{
  // Company model for the Company table

  CompanyProfile(
      {int? id, int? userId, String? imageLink, String? fullname, String? email, String? about})
      : super(id:id, userId:userId, imageLink:imageLink, fullname:fullname, email:email, cvLink:'', repo:'', about:about);
  CompanyProfile.fromMap(dynamic obj) : super.fromMap(obj);
}

class StudentProfile extends UserProfile{
  // Company model for the Company table

  StudentProfile(
      {int? id,
        int? userId,
        String? imageLink,
        String? fullname,
        String? email,
        String? cvLink,
        String? repo,
        String? about})
      : super(id:id, userId:userId, imageLink:imageLink, fullname:fullname, cvLink:cvLink, email:email, repo:repo, about:about);
  StudentProfile.fromMap(dynamic obj) : super.fromMap(obj);
}
