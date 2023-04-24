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
        coveredDistanceInKilometers: 10.0,
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
        coveredDistanceInKilometers: 10.0,
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

  test(
    'map workout status to firebase, '
    'pending status should be mapped to pending status dto',
    () {
      const WorkoutStatusPending status = WorkoutStatusPending();
      const firebase.WorkoutStatusDto expectedDto =
          firebase.WorkoutStatusPendingDto();

      final dto = mapWorkoutStatusToFirebase(status);

      expect(dto, expectedDto);
    },
  );

  test(
    'map workout status to firebase, '
    'done status should be mapped to done status dto',
    () {
      const WorkoutStatusDone status = WorkoutStatusDone(
        coveredDistanceInKm: 10.0,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      const firebase.WorkoutStatusDto expectedDto =
          firebase.WorkoutStatusDoneDto(
        coveredDistanceInKilometers: 10.0,
        avgPace: firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        comment: 'comment',
      );

      final dto = mapWorkoutStatusToFirebase(status);

      expect(dto, expectedDto);
    },
  );

  test(
    'map workout status to firebase, '
    'failed status should be mapped to failed status dto',
    () {
      const WorkoutStatusFailed status = WorkoutStatusFailed(
        coveredDistanceInKm: 10.0,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      const firebase.WorkoutStatusDto expectedDto =
          firebase.WorkoutStatusFailedDto(
        coveredDistanceInKilometers: 10.0,
        avgPace: firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        comment: 'comment',
      );

      final dto = mapWorkoutStatusToFirebase(status);

      expect(dto, expectedDto);
    },
  );
}
