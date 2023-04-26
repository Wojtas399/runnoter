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
    'completed status',
    () {
      const PaceDto avgPace = PaceDto(minutes: 5, seconds: 30);
      final Map<String, dynamic> json = {
        'name': 'completed',
        'coveredDistanceInKilometers': 8.5,
        'avgPace': avgPace.toJson(),
        'avgHeartRate': 145,
        'moodRate': MoodRate.mr8.number,
        'comment': 'comment',
      };
      const WorkoutStatusCompletedDto expectedDto = WorkoutStatusCompletedDto(
        coveredDistanceInKilometers: 8.5,
        avgPace: avgPace,
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
    'uncompleted status',
    () {
      const PaceDto avgPace = PaceDto(minutes: 5, seconds: 30);
      final Map<String, dynamic> json = {
        'name': 'failed',
        'coveredDistanceInKilometers': 8.5,
        'avgPace': avgPace.toJson(),
        'avgHeartRate': 145,
        'moodRate': MoodRate.mr8.number,
        'comment': 'comment',
      };
      const WorkoutStatusUncompletedDto expectedDto =
          WorkoutStatusUncompletedDto(
        coveredDistanceInKilometers: 8.5,
        avgPace: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

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
    'completed status',
    () {
      const PaceDto avgPace = PaceDto(minutes: 5, seconds: 30);
      const WorkoutStatusCompletedDto dto = WorkoutStatusCompletedDto(
        coveredDistanceInKilometers: 8.5,
        avgPace: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'completed',
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
    'uncompleted status',
    () {
      const PaceDto avgPace = PaceDto(minutes: 5, seconds: 30);
      const WorkoutStatusUncompletedDto dto = WorkoutStatusUncompletedDto(
        coveredDistanceInKilometers: 8.5,
        avgPace: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'uncompleted',
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
}
