import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'c1';
  const String userId = 'u1';
  const String name = 'name1';
  final DateTime date = DateTime(2023, 5, 10);
  const String dateStr = '2023-05-10';
  const String place = 'New York';
  const double distance = 42;
  const Duration expectedDuration = Duration(
    hours: 2,
    minutes: 45,
    seconds: 30,
  );
  const String expectedDurationStr = '2:45:30';
  final RunStatusDto statusDto = RunStatusDoneDto(
    coveredDistanceInKm: 42,
    avgPaceDto: const PaceDto(
      minutes: 4,
      seconds: 30,
    ),
    avgHeartRate: 145,
    moodRate: MoodRate.mr7,
    duration: const Duration(hours: 2, minutes: 40, seconds: 20),
    comment: null,
  );

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'name': name,
        'date': dateStr,
        'place': place,
        'distance': distance,
        'expectedDuration': expectedDurationStr,
        'status': statusDto.toJson(),
      };
      final RaceDto expectedDto = RaceDto(
        id: id,
        userId: userId,
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
        statusDto: statusDto,
      );

      final RaceDto dto = RaceDto.fromJson(
        raceId: id,
        userId: userId,
        json: json,
      );

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final RaceDto dto = RaceDto(
        id: id,
        userId: userId,
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
        statusDto: statusDto,
      );
      final Map<String, dynamic> expectedJson = {
        'name': name,
        'date': dateStr,
        'place': place,
        'distance': distance,
        'expectedDuration': expectedDurationStr,
        'status': statusDto.toJson(),
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'name is null, '
    'should not include name in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'date': dateStr,
        'place': place,
        'distance': distance,
        'expectedDuration': expectedDurationStr,
        'status': statusDto.toJson(),
      };

      final Map<String, dynamic> json = createRaceJsonToUpdate(
        date: date,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
        statusDto: statusDto,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'date is null, '
    'should not include date in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'name': name,
        'place': place,
        'distance': distance,
        'expectedDuration': expectedDurationStr,
        'status': statusDto.toJson(),
      };

      final Map<String, dynamic> json = createRaceJsonToUpdate(
        name: name,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
        statusDto: statusDto,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'place is null, '
    'should not include place in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'name': name,
        'date': dateStr,
        'distance': distance,
        'expectedDuration': expectedDurationStr,
        'status': statusDto.toJson(),
      };

      final Map<String, dynamic> json = createRaceJsonToUpdate(
        name: name,
        date: date,
        distance: distance,
        expectedDuration: expectedDuration,
        statusDto: statusDto,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'distance is null, '
    'should not include distance in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'name': name,
        'date': dateStr,
        'place': place,
        'expectedDuration': expectedDurationStr,
        'status': statusDto.toJson(),
      };

      final Map<String, dynamic> json = createRaceJsonToUpdate(
        name: name,
        date: date,
        place: place,
        expectedDuration: expectedDuration,
        statusDto: statusDto,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'expected duration is null, '
    'should not include expected duration in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'name': name,
        'date': dateStr,
        'place': place,
        'distance': distance,
        'status': statusDto.toJson(),
      };

      final Map<String, dynamic> json = createRaceJsonToUpdate(
        name: name,
        date: date,
        place: place,
        distance: distance,
        statusDto: statusDto,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'set duration as null, '
    'should set expected duration as null',
    () {
      final Map<String, dynamic> expectedJson = {
        'name': name,
        'date': dateStr,
        'place': place,
        'distance': distance,
        'expectedDuration': null,
        'status': statusDto.toJson(),
      };

      final Map<String, dynamic> json = createRaceJsonToUpdate(
        name: name,
        date: date,
        place: place,
        distance: distance,
        setDurationAsNull: true,
        statusDto: statusDto,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'status is null, '
    'should not include status in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'name': name,
        'date': dateStr,
        'place': place,
        'distance': distance,
        'expectedDuration': expectedDurationStr,
      };

      final Map<String, dynamic> json = createRaceJsonToUpdate(
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
      );

      expect(json, expectedJson);
    },
  );
}
