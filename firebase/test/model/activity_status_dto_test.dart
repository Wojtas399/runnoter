import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'from json, '
    'pending status',
    () {
      final Map<String, dynamic> json = {'name': 'pending'};
      const ActivityStatusPendingDto expectedDto = ActivityStatusPendingDto();

      final ActivityStatusDto dto = ActivityStatusDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'from json, '
    'done status',
    () {
      const PaceDto avgPace = PaceDto(minutes: 5, seconds: 30);
      final Map<String, dynamic> json = {
        'name': 'done',
        'coveredDistanceInKilometers': 8.5,
        'avgPace': avgPace.toJson(),
        'avgHeartRate': 145,
        'moodRate': MoodRate.mr8.number,
        'duration': '0:45:30',
        'comment': 'comment',
      };
      final ActivityStatusDoneDto expectedDto = ActivityStatusDoneDto(
        coveredDistanceInKm: 8.5,
        avgPaceDto: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        duration: const Duration(hours: 0, minutes: 45, seconds: 30),
        comment: 'comment',
      );

      final ActivityStatusDto dto = ActivityStatusDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'from json, '
    'aborted status',
    () {
      const PaceDto avgPace = PaceDto(minutes: 5, seconds: 30);
      final Map<String, dynamic> json = {
        'name': 'aborted',
        'coveredDistanceInKilometers': 8.5,
        'avgPace': avgPace.toJson(),
        'avgHeartRate': 145,
        'moodRate': MoodRate.mr8.number,
        'duration': '0:45:30',
        'comment': 'comment',
      };
      final ActivityStatusAbortedDto expectedDto = ActivityStatusAbortedDto(
        coveredDistanceInKm: 8.5,
        avgPaceDto: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        duration: const Duration(hours: 0, minutes: 45, seconds: 30),
        comment: 'comment',
      );

      final ActivityStatusDto dto = ActivityStatusDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'from json, '
    'undone status',
    () {
      final Map<String, dynamic> json = {'name': 'undone'};
      const ActivityStatusUndoneDto expectedDto = ActivityStatusUndoneDto();

      final ActivityStatusDto dto = ActivityStatusDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'pending status',
    () {
      const ActivityStatusPendingDto dto = ActivityStatusPendingDto();
      final Map<String, dynamic> expectedJson = {'name': 'pending'};

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'done status',
    () {
      const PaceDto avgPace = PaceDto(minutes: 5, seconds: 30);
      final ActivityStatusDoneDto dto = ActivityStatusDoneDto(
        coveredDistanceInKm: 8.5,
        avgPaceDto: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        duration: const Duration(hours: 0, minutes: 45, seconds: 30),
        comment: 'comment',
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'done',
        'coveredDistanceInKilometers': 8.5,
        'avgPace': avgPace.toJson(),
        'avgHeartRate': 145,
        'moodRate': MoodRate.mr8.number,
        'duration': '0:45:30',
        'comment': 'comment',
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'aborted status',
    () {
      const PaceDto avgPace = PaceDto(minutes: 5, seconds: 30);
      final ActivityStatusAbortedDto dto = ActivityStatusAbortedDto(
        coveredDistanceInKm: 8.5,
        avgPaceDto: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        duration: const Duration(hours: 0, minutes: 45, seconds: 30),
        comment: 'comment',
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'aborted',
        'coveredDistanceInKilometers': 8.5,
        'avgPace': avgPace.toJson(),
        'avgHeartRate': 145,
        'moodRate': MoodRate.mr8.number,
        'duration': '0:45:30',
        'comment': 'comment',
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'undone status',
    () {
      const ActivityStatusUndoneDto dto = ActivityStatusUndoneDto();
      final Map<String, dynamic> expectedJson = {'name': 'undone'};

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
