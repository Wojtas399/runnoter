import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/workout_status_mapper.dart';
import 'package:runnoter/domain/entity/workout_status.dart';

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
      final firebase.WorkoutStatusDto statusDto = firebase.WorkoutStatusDoneDto(
        coveredDistanceInKm: 10.0,
        avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        comment: 'comment',
      );
      WorkoutStatusDone expectedStatus = WorkoutStatusDone(
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
    'aborted status dto model should be mapped to domain aborted status model',
    () {
      final firebase.WorkoutStatusDto statusDto =
          firebase.WorkoutStatusAbortedDto(
        coveredDistanceInKm: 10.0,
        avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        comment: 'comment',
      );
      final WorkoutStatusAborted expectedStatus = WorkoutStatusAborted(
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
    'undone status dto model should be mapped to domain undone status model',
    () {
      const firebase.WorkoutStatusDto statusDto =
          firebase.WorkoutStatusUndoneDto();
      const WorkoutStatusUndone expectedStatus = WorkoutStatusUndone();

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
      final WorkoutStatusDone status = WorkoutStatusDone(
        coveredDistanceInKm: 10.0,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      final firebase.WorkoutStatusDto expectedDto =
          firebase.WorkoutStatusDoneDto(
        coveredDistanceInKm: 10.0,
        avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 50),
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
    'aborted status should be mapped to aborted status dto',
    () {
      final WorkoutStatusAborted status = WorkoutStatusAborted(
        coveredDistanceInKm: 10.0,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      final firebase.WorkoutStatusDto expectedDto =
          firebase.WorkoutStatusAbortedDto(
        coveredDistanceInKm: 10.0,
        avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 50),
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
    'undone status should be mapped to undone status dto',
    () {
      const WorkoutStatusUndone status = WorkoutStatusUndone();
      const firebase.WorkoutStatusDto expectedDto =
          firebase.WorkoutStatusUndoneDto();

      final dto = mapWorkoutStatusToFirebase(status);

      expect(dto, expectedDto);
    },
  );
}
