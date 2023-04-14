import 'package:firebase/firebase.dart';
import 'package:firebase/model/workout_status_dto.dart';
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
      const WorkoutStatusDoneDto expectedDto = WorkoutStatusDoneDto(
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
    'failed status',
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
      const WorkoutStatusFailedDto expectedDto = WorkoutStatusFailedDto(
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
    'done status',
    () {
      const PaceDto avgPace = PaceDto(minutes: 5, seconds: 30);
      const WorkoutStatusDoneDto dto = WorkoutStatusDoneDto(
        coveredDistanceInKilometers: 8.5,
        avgPace: avgPace,
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
    'failed status',
    () {
      const PaceDto avgPace = PaceDto(minutes: 5, seconds: 30);
      const WorkoutStatusFailedDto dto = WorkoutStatusFailedDto(
        coveredDistanceInKilometers: 8.5,
        avgPace: avgPace,
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'failed',
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
