enum Tag {
  webDevelopment,
  cloud,
  operatingSystems,
  gameDevelopment,
}

class TagUtil {
  static String convertTagValueToString(Tag tagValue) {
    // Reformats the value of the Tag enum into correctly formatted text

    var tagString = tagValue.toString().split('.')[1];
    tagString = tagString.splitMapJoin(RegExp(r'[A-Z][a-z]*'),
        onMatch: (m) => ' ${m[0]}',
        onNonMatch: (n) =>
            n.isNotEmpty ? n[0].toUpperCase() + n.substring(1) : '');

    return tagString;
  }
}

class Internship {
  // Class holding the Internship model that corresponds to the table with
  // the same from the db

  int? _id;
  int? _companyId;
  String? _title;
  String? _description;
  String? _requirements;
  DateTime? _fromDate;
  DateTime? _toDate;
  int? _participantsNum;
  Tag? _tag;
  bool? _isOngoing;

  Internship({
    id,
    required int? companyId,
    required String? title,
    required String? description,
    required String? requirements,
    required DateTime? fromDate,
    required DateTime? toDate,
    required int? participantsNum,
    required Tag? tag,
    required bool? isOngoing,
  })  : _id = id,
        _companyId = companyId,
        _title = title,
        _description = description,
        _requirements = requirements,
        _fromDate = fromDate!.toUtc(),
        _toDate = toDate!.toUtc(),
        _participantsNum = participantsNum,
        _tag = tag,
        _isOngoing = isOngoing;

  Internship.fromMap(dynamic obj) {
    _id = obj['id'] as int;
    _companyId = obj['companyId'] as int;
    _title = obj['title'] as String;
    _description = obj['description'] as String;
    _requirements = obj['requirements'] as String;
    _fromDate = (obj['fromDate'] as DateTime).toUtc();
    _toDate = (obj['toDate'] as DateTime).toUtc();
    _participantsNum = obj['participantsNum'] as int;
    _tag = Tag.values[obj['tag'] as int];
    _isOngoing = obj['isOngoing'] as int == 1 ? true : false;
  }

  int? get getId => _id;
  bool? get getIsOngoing => _isOngoing;
  Tag? get getTag => _tag;
  int? get getParticipantsNum => _participantsNum;
  DateTime? get getToDate => _toDate;
  DateTime? get getFromDate => _fromDate;
  String? get getDescription => _description;
  String? get getRequirements => _requirements;
  String? get getTitle => _title;
  int? get getCompanyId => _companyId;

  set setId(int? id) {
    _id = id;
  }

  Map<String, dynamic> toMap() {
    var internshipMap = <String, dynamic>{};
    internshipMap['id'] = _id;
    internshipMap['companyId'] = _companyId;
    internshipMap['title'] = _title;
    internshipMap['description'] = _description;
    internshipMap['requirements'] = _requirements;
    internshipMap['fromDate'] = _fromDate;
    internshipMap['toDate'] = _toDate;
    internshipMap['participantsNum'] = _participantsNum;
    internshipMap['tag'] = _tag!.index;
    internshipMap['isOngoing'] = _isOngoing;
    return internshipMap;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Internship &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _companyId == other._companyId &&
          _title == other._title &&
          _description == other._description &&
          _requirements == other._requirements &&
          _fromDate == other._fromDate &&
          _toDate == other._toDate &&
          _participantsNum == other._participantsNum &&
          _tag == other._tag &&
          _isOngoing == other._isOngoing;

  @override
  int get hashCode =>
      _id.hashCode ^
      _companyId.hashCode ^
      _title.hashCode ^
      _description.hashCode ^
      _requirements.hashCode ^
      _fromDate.hashCode ^
      _toDate.hashCode ^
      _participantsNum.hashCode ^
      _tag.hashCode ^
      _isOngoing.hashCode;

  @override
  String toString() {
    return 'Internship{_id: $_id, _companyId: $_companyId, _title: $_title, '
        '_description: $_description, _requirements: $_requirements, '
        '_fromDate: $_fromDate, _toDate: $_toDate, '
        '_participantsNum: $_participantsNum, _tag: $_tag, '
        '_isOngoing: $_isOngoing}';
  }
}
