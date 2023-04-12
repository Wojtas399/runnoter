import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/workout_status_mapper.dart';
import 'package:runnoter/domain/model/workout_status.dart';

void main() {
  test(
    'map workout status from firebase, '
    'pending status dto model should be mapped to domain pending status model',
    () {
      const firebase.WorkoutStatusDto statusDto =
          firebase.WorkoutStatusPendingDto();
      const WorkoutStatusPending expectedStatus = WorkoutStatusPending();

      final WorkoutStatus status = mapWorkoutStatusFromFirebase(statusDto);

      expect(status, expectedStatus);
    },
  );

  test(
    'map workout status from firebase, '
    'done status dto model should be mapped to domain done status model',
    () {
      const firebase.WorkoutStatusDto statusDto = firebase.WorkoutStatusDoneDto(
        coveredDistanceInKm: 10.0,
        avgPace: firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        comment: 'comment',
      );
      const WorkoutStatusDone expectedStatus = WorkoutStatusDone(
        coveredDistanceInKm: 10.0,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      final WorkoutStatus status = mapWorkoutStatusFromFirebase(statusDto);

      expect(status, expectedStatus);
    },
  );

  test(
    'map workout status from firebase, '
    'failed status dto model should be mapped to domain failed status model',
    () {
      const firebase.WorkoutStatusDto statusDto =
          firebase.WorkoutStatusFailedDto(
        coveredDistanceInKm: 10.0,
        avgPace: firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        comment: 'comment',
      );
      const WorkoutStatusFailed expectedStatus = WorkoutStatusFailed(
        coveredDistanceInKm: 10.0,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      final WorkoutStatus status = mapWorkoutStatusFromFirebase(statusDto);

      expect(status, expectedStatus);
    },
  );
}
