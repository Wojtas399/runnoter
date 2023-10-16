import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/race.dart';
import 'package:runnoter/data/mapper/race_mapper.dart';
import 'package:runnoter/data/model/activity.dart';

void main() {
  const String id = 'c1';
  const String userId = 'u1';
  const String name = 'nam1';
  final DateTime date = DateTime(2023, 5, 20);
  const String place = 'place123';
  const double distance = 5.0;
  const Duration expectedDuration = Duration(
    hours: 0,
    minutes: 28,
    seconds: 40,
  );
  final Race race = Race(
    id: id,
    userId: userId,
    name: name,
    date: date,
    place: place,
    distance: distance,
    expectedDuration: expectedDuration,
    status: const ActivityStatusDone(
      coveredDistanceInKm: 5.0,
      avgPace: Pace(minutes: 5, seconds: 45),
      avgHeartRate: 145,
      moodRate: MoodRate.mr7,
      comment: null,
    ),
  );
  final firebase.RaceDto raceDto = firebase.RaceDto(
    id: id,
    userId: userId,
    name: name,
    date: date,
    place: place,
    distance: distance,
    expectedDuration: expectedDuration,
    statusDto: firebase.ActivityStatusDoneDto(
      coveredDistanceInKm: 5.0,
      avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 45),
      avgHeartRate: 145,
      moodRate: firebase.MoodRate.mr7,
      comment: null,
    ),
  );

  test(
    'map race from dto, '
    'should map race from dto to domain model',
    () {
      final Race domainModel = mapRaceFromDto(raceDto);

      expect(domainModel, race);
    },
  );

  test(
    'map race to dto, '
    'should map race from domain to dto model',
    () {
      final firebase.RaceDto dto = mapRaceToDto(race);

      expect(dto, raceDto);
    },
  );
}
