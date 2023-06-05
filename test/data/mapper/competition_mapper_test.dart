import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/competition_mapper.dart';
import 'package:runnoter/domain/entity/competition.dart';
import 'package:runnoter/domain/entity/run_status.dart';

void main() {
  const String id = 'c1';
  const String userId = 'u1';
  const String name = 'nam1';
  final DateTime date = DateTime(2023, 5, 20);
  const String place = 'place123';
  const double distance = 5.0;
  final Competition competition = Competition(
    id: id,
    userId: userId,
    name: name,
    date: date,
    place: place,
    distance: distance,
    expectedTime: const Time(hour: 0, minute: 28, second: 40),
    status: RunStatusDone(
      coveredDistanceInKm: 5.0,
      avgPace: const Pace(minutes: 5, seconds: 45),
      avgHeartRate: 145,
      moodRate: MoodRate.mr7,
      comment: null,
    ),
  );
  final firebase.CompetitionDto competitionDto = firebase.CompetitionDto(
    id: id,
    userId: userId,
    name: name,
    date: date,
    place: place,
    distance: distance,
    expectedTimeDto: const firebase.TimeDto(hour: 0, minute: 28, second: 40),
    runStatusDto: firebase.RunStatusDoneDto(
      coveredDistanceInKm: 5.0,
      avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 45),
      avgHeartRate: 145,
      moodRate: firebase.MoodRate.mr7,
      comment: null,
    ),
  );

  test(
    'map competition from dto, '
    'should map competition from dto to domain model',
    () {
      final Competition domainModel = mapCompetitionFromDto(competitionDto);

      expect(domainModel, competition);
    },
  );

  test(
    'map competition to dto, '
    'should map competition from domain to dto model',
    () {
      final firebase.CompetitionDto dto = mapCompetitionToDto(competition);

      expect(dto, competitionDto);
    },
  );
}
