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
      const WorkoutStatusPendingDto expectedDto = WorkoutStatusPendingDto();

      final WorkoutStatusDto dto = WorkoutStatusDto.fromJson(json);

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
      final WorkoutStatusDoneDto expectedDto = WorkoutStatusDoneDto(
        coveredDistanceInKm: 8.5,
        avgPaceDto: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      final WorkoutStatusDto dto = WorkoutStatusDto.fromJson(json);

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
      final WorkoutStatusAbortedDto expectedDto = WorkoutStatusAbortedDto(
        coveredDistanceInKm: 8.5,
        avgPaceDto: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      final WorkoutStatusDto dto = WorkoutStatusDto.fromJson(json);

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
      const WorkoutStatusUndoneDto expectedDto = WorkoutStatusUndoneDto();

      final WorkoutStatusDto dto = WorkoutStatusDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'pending status',
    () {
      const WorkoutStatusPendingDto dto = WorkoutStatusPendingDto();
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
      final WorkoutStatusDoneDto dto = WorkoutStatusDoneDto(
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
      final WorkoutStatusAbortedDto dto = WorkoutStatusAbortedDto(
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
      const WorkoutStatusUndoneDto dto = WorkoutStatusUndoneDto();
      final Map<String, dynamic> expectedJson = {
        'name': 'undone',
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
