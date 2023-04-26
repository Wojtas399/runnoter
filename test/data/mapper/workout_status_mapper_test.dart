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
    'completed status dto model should be mapped to domain completed status model',
    () {
      const firebase.WorkoutStatusDto statusDto =
          firebase.WorkoutStatusCompletedDto(
        coveredDistanceInKilometers: 10.0,
        avgPace: firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        comment: 'comment',
      );
      WorkoutStatusCompleted expectedStatus = WorkoutStatusCompleted(
        coveredDistanceInKm: 10.0,
        avgPace: const Pace(minutes: 5, seconds: 50),
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
    'uncompleted status dto model should be mapped to domain uncompleted status model',
    () {
      const firebase.WorkoutStatusDto statusDto =
          firebase.WorkoutStatusUncompletedDto(
        coveredDistanceInKilometers: 10.0,
        avgPace: firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        comment: 'comment',
      );
      final WorkoutStatusUncompleted expectedStatus = WorkoutStatusUncompleted(
        coveredDistanceInKm: 10.0,
        avgPace: const Pace(minutes: 5, seconds: 50),
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
    'completed status should be mapped to completed status dto',
    () {
      final WorkoutStatusCompleted status = WorkoutStatusCompleted(
        coveredDistanceInKm: 10.0,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      const firebase.WorkoutStatusDto expectedDto =
          firebase.WorkoutStatusCompletedDto(
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
    'uncompleted status should be mapped to uncompleted status dto',
    () {
      final WorkoutStatusUncompleted status = WorkoutStatusUncompleted(
        coveredDistanceInKm: 10.0,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      const firebase.WorkoutStatusDto expectedDto =
          firebase.WorkoutStatusUncompletedDto(
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
