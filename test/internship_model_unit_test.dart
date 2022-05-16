import 'package:internship_app_fis/models/internship.dart';
import 'package:test/test.dart';

void main() {
  late DateTime now;
  late Internship testInter;
  late Map<String, Object> mapInter;

  setUp(() {
    now = DateTime.now();
    testInter = Internship(
        id: 1,
        companyId: 1,
        title: 'test',
        description: 'test',
        requirements: 'test',
        fromDate: now,
        toDate: now,
        participantsNum: 10,
        tag: Tag.values[3],
        isOngoing: true);
    mapInter = {
      'id': 1,
      'companyId': 1,
      'title': 'test',
      'description': 'test',
      'requirements': 'test',
      'fromDate': now,
      'toDate': now,
      'participantsNum': 10,
      'tag': 3,
      'isOngoing': 1
    };
  });

  group('Internship Model:', () {
    test('Tag value should be correctly converted to string', () {
      expect(TagUtil.convertTagValueToString(Tag.gameDevelopment),
          'Game Development');
    });
    test('internship should be created from map', () {
      expect(Internship.fromMap(mapInter), testInter);
    });
    test('user should be converted to map', () {
      var testMap = {
        'id': 1,
        'companyId': 1,
        'title': 'test',
        'description': 'test',
        'requirements': 'test',
        'fromDate': now.toUtc(),
        'toDate': now.toUtc(),
        'participantsNum': 10,
        'tag': 3,
        'isOngoing': true
      };
      expect(testInter.toMap(), testMap);
    });
    test('getters and setters should give the correct values', () {
      testInter.setId = 2;
      expect(
          testInter.getId == 2 &&
              testInter.getCompanyId == mapInter['companyId'] &&
              testInter.getTitle == mapInter['title'] &&
              testInter.getDescription == mapInter['description'] &&
              testInter.getRequirements == mapInter['requirements'] &&
              testInter.getFromDate ==
                  (mapInter['fromDate'] as DateTime).toUtc() &&
              testInter.getToDate == (mapInter['toDate'] as DateTime).toUtc() &&
              testInter.getParticipantsNum == mapInter['participantsNum'] &&
              testInter.getTag!.index == mapInter['tag'] &&
              testInter.getIsOngoing == true,
          true);
      testInter.setId = 1;
    });
    test('internship should have toString method', () {
      expect(testInter.toString(),
          'Internship{_id: 1, _companyId: 1, _title: test, _description: test, _requirements: test, _fromDate: ${now.toUtc()}, _toDate: ${now.toUtc()}, _participantsNum: 10, _tag: Tag.gameDevelopment, _isOngoing: true}');
    });
    test('internship should have hasCode getter', () {
      expect(
        testInter.hashCode,
        testInter.getId.hashCode ^
            testInter.getCompanyId.hashCode ^
            testInter.getTitle.hashCode ^
            testInter.getDescription.hashCode ^
            testInter.getRequirements.hashCode ^
            testInter.getFromDate.hashCode ^
            testInter.getToDate.hashCode ^
            testInter.getParticipantsNum.hashCode ^
            testInter.getTag.hashCode ^
            testInter.getIsOngoing.hashCode,
      );
    });
  });
}
