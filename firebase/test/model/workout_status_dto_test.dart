import 'package:firebase/model/pace_dto.dart';
import 'package:firebase/model/workout_status_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'pending status, '
    'to json, '
    'should set only name key',
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
    'done status, '
    'from json',
    () {
      const double coveredDistanceInKm = 8.5;
      const PaceDto avgPace = PaceDto(
        minutes: 5,
        seconds: 30,
      );
      const int avgHeartRate = 145;
      const MoodRate moodRate = MoodRate.mr8;
      const String comment = 'comment';
      final Map<String, dynamic> json = {
        'name': 'done',
        'coveredDistanceInKm': coveredDistanceInKm,
        'avgPace': avgPace.toJson(),
        'avgHeartRate': avgHeartRate,
        'moodRate': moodRate.number,
        'comment': comment,
      };
      const WorkoutStatusDoneDto expectedDto = WorkoutStatusDoneDto(
        coveredDistanceInKm: coveredDistanceInKm,
        avgPace: avgPace,
        avgHeartRate: avgHeartRate,
        moodRate: moodRate,
        comment: comment,
      );

      final WorkoutStatusDoneDto dto = WorkoutStatusDoneDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'done status, '
    'to json',
    () {
      const double coveredDistanceInKm = 8.5;
      const PaceDto avgPace = PaceDto(
        minutes: 5,
        seconds: 30,
      );
      const int avgHeartRate = 145;
      const MoodRate moodRate = MoodRate.mr8;
      const String comment = 'comment';
      const WorkoutStatusDoneDto dto = WorkoutStatusDoneDto(
        coveredDistanceInKm: coveredDistanceInKm,
        avgPace: avgPace,
        avgHeartRate: avgHeartRate,
        moodRate: moodRate,
        comment: comment,
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'done',
        'coveredDistanceInKm': coveredDistanceInKm,
        'avgPace': avgPace.toJson(),
        'avgHeartRate': avgHeartRate,
        'moodRate': moodRate.number,
        'comment': comment,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'failed status, '
    'from json',
    () {
      const double coveredDistanceInKm = 8.5;
      const PaceDto avgPace = PaceDto(
        minutes: 5,
        seconds: 30,
      );
      const int avgHeartRate = 145;
      const MoodRate moodRate = MoodRate.mr8;
      const String comment = 'comment';
      final Map<String, dynamic> json = {
        'name': 'failed',
        'coveredDistanceInKm': coveredDistanceInKm,
        'avgPace': avgPace.toJson(),
        'avgHeartRate': avgHeartRate,
        'moodRate': moodRate.number,
        'comment': comment,
      };
      const WorkoutStatusFailedDto expectedDto = WorkoutStatusFailedDto(
        coveredDistanceInKm: coveredDistanceInKm,
        avgPace: avgPace,
        avgHeartRate: avgHeartRate,
        moodRate: moodRate,
        comment: comment,
      );

      final WorkoutStatusFailedDto dto = WorkoutStatusFailedDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'failed status, '
    'to json',
    () {
      const double coveredDistanceInKm = 8.5;
      const PaceDto avgPace = PaceDto(
        minutes: 5,
        seconds: 30,
      );
      const int avgHeartRate = 145;
      const MoodRate moodRate = MoodRate.mr8;
      const String comment = 'comment';
      const WorkoutStatusFailedDto dto = WorkoutStatusFailedDto(
        coveredDistanceInKm: coveredDistanceInKm,
        avgPace: avgPace,
        avgHeartRate: avgHeartRate,
        moodRate: moodRate,
        comment: comment,
      );
      final Map<String, dynamic> expectedJson = {
        'name': 'failed',
        'coveredDistanceInKm': coveredDistanceInKm,
        'avgPace': avgPace.toJson(),
        'avgHeartRate': avgHeartRate,
        'moodRate': moodRate.number,
        'comment': comment,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
