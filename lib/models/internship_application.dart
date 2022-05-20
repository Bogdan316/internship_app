class InternshipApplication {
  int? _id;
  int? _studentId;
  int? _internshipId;

  InternshipApplication({
    int? id,
    required int? studentId,
    required int? internshipId,
  })
      : _id=id,
        _studentId = studentId,
        _internshipId = internshipId;

  @override
  String toString() {
    return 'InternshipApplication{_id: $_id, _studentId: $_studentId, _internshipId: $_internshipId}';
  }

  Map<String, dynamic> toMap() {
    var internshipApplicationMap = <String, dynamic>{};
    internshipApplicationMap['id'] = _id;
    internshipApplicationMap['studentId'] = _studentId;
    internshipApplicationMap['internshipId'] = _internshipId;

    return internshipApplicationMap;
  }

  InternshipApplication.fromMap(dynamic obj) {
    _id = obj['id'] as int;
    _studentId = obj['studentId'] as int?;
    _internshipId = obj['internshipId'] as int?;
  }

  int? get getId => _id;

  int? get getInternshipId => _internshipId;

  int? get getStudentId => _studentId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InternshipApplication &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _studentId == other._studentId &&
          _internshipId == other._internshipId;

  @override
  int get hashCode =>
      _id.hashCode ^ _studentId.hashCode ^ _internshipId.hashCode;

  set setId(int? value) {
    _id = value;
  }

  set setInternshipId(int? value) {
    _internshipId = value;
  }

  set setStudentId(int? value) {
    _studentId = value;
  }
}