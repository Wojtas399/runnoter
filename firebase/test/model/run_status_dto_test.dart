import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'from json, '
    'pending status',
    () {
      final Map<String, dynamic> json = {
        'name': 'pending',
      };
      const RunStatusPendingDto expectedDto = RunStatusPendingDto();

      final RunStatusDto dto = RunStatusDto.fromJson(json);

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
        'comment': 'comment',
      };
      final RunStatusDoneDto expectedDto = RunStatusDoneDto(
        coveredDistanceInKm: 8.5,
        avgPaceDto: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      final RunStatusDto dto = RunStatusDto.fromJson(json);

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
        'comment': 'comment',
      };
      final RunStatusAbortedDto expectedDto = RunStatusAbortedDto(
        coveredDistanceInKm: 8.5,
        avgPaceDto: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      final RunStatusDto dto = RunStatusDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'from json, '
    'undone status',
    () {
      final Map<String, dynamic> json = {
        'name': 'undone',
      };
      const RunStatusUndoneDto expectedDto = RunStatusUndoneDto();

      final RunStatusDto dto = RunStatusDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'pending status',
    () {
      const RunStatusPendingDto dto = RunStatusPendingDto();
      final Map<String, dynamic> expectedJson = {
        'name': 'pending',
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'done status',
    () {
      const PaceDto avgPace = PaceDto(minutes: 5, seconds: 30);
      final RunStatusDoneDto dto = RunStatusDoneDto(
        coveredDistanceInKm: 8.5,
        avgPaceDto: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'done',
        'coveredDistanceInKilometers': 8.5,
        'avgPace': avgPace.toJson(),
        'avgHeartRate': 145,
        'moodRate': MoodRate.mr8.number,
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
      final RunStatusAbortedDto dto = RunStatusAbortedDto(
        coveredDistanceInKm: 8.5,
        avgPaceDto: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'aborted',
        'coveredDistanceInKilometers': 8.5,
        'avgPace': avgPace.toJson(),
        'avgHeartRate': 145,
        'moodRate': MoodRate.mr8.number,
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
      const RunStatusUndoneDto dto = RunStatusUndoneDto();
      final Map<String, dynamic> expectedJson = {
        'name': 'undone',
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
