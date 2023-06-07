import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'c1';
  const String userId = 'u1';
  const String name = 'name1';
  final DateTime date = DateTime(2023, 5, 10);
  const String place = 'New York';
  const double distance = 42;
  const Duration expectedDuration = Duration(
    hours: 2,
    minutes: 45,
    seconds: 30,
  );
  final RunStatusDto runStatusDto = RunStatusDoneDto(
    coveredDistanceInKm: 42,
    avgPaceDto: const PaceDto(
      minutes: 4,
      seconds: 30,
    ),
    avgHeartRate: 145,
    moodRate: MoodRate.mr7,
    comment: null,
  );
  final CompetitionDto competitionDto = CompetitionDto(
    id: id,
    userId: userId,
    name: name,
    date: date,
    place: place,
    distance: distance,
    expectedDuration: expectedDuration,
    runStatusDto: runStatusDto,
  );
  final Map<String, dynamic> competitionJson = {
    'name': name,
    'date': '2023-05-10',
    'place': place,
    'distance': distance,
    'expectedDuration': '2:45:30',
    'status': runStatusDto.toJson(),
  };

  test(
    'from json, '
    'should map json to dto model',
    () {
      final CompetitionDto dto = CompetitionDto.fromJson(
        competitionId: id,
        userId: userId,
        json: competitionJson,
      );

      expect(dto, competitionDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final Map<String, dynamic> json = competitionDto.toJson();

      expect(json, competitionJson);
    },
  );
}
