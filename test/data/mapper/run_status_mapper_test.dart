import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/run_status_mapper.dart';
import 'package:runnoter/domain/entity/run_status.dart';

void main() {
  test(
    'map run status from firebase, '
    'pending status dto model should be mapped to domain pending status model',
    () {
      const firebase.RunStatusDto statusDto = firebase.RunStatusPendingDto();
      const RunStatusPending expectedStatus = RunStatusPending();

      final RunStatus status = mapRunStatusFromFirebase(statusDto);

      expect(status, expectedStatus);
    },
  );

  test(
    'map run status from firebase, '
    'done status dto model should be mapped to domain done status model',
    () {
      final firebase.RunStatusDto statusDto = firebase.RunStatusDoneDto(
        coveredDistanceInKm: 10.0,
        avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        comment: 'comment',
      );
      RunStatusDone expectedStatus = RunStatusDone(
        coveredDistanceInKm: 10.0,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      final RunStatus status = mapRunStatusFromFirebase(statusDto);

      expect(status, expectedStatus);
    },
  );

  test(
    'map run status from firebase, '
    'aborted status dto model should be mapped to domain aborted status model',
    () {
      final firebase.RunStatusDto statusDto = firebase.RunStatusAbortedDto(
        coveredDistanceInKm: 10.0,
        avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        comment: 'comment',
      );
      final RunStatusAborted expectedStatus = RunStatusAborted(
        coveredDistanceInKm: 10.0,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      final RunStatus status = mapRunStatusFromFirebase(statusDto);

      expect(status, expectedStatus);
    },
  );

  test(
    'map run status from firebase, '
    'undone status dto model should be mapped to domain undone status model',
    () {
      const firebase.RunStatusDto statusDto = firebase.RunStatusUndoneDto();
      const RunStatusUndone expectedStatus = RunStatusUndone();

      final RunStatus status = mapRunStatusFromFirebase(statusDto);

      expect(status, expectedStatus);
    },
  );

  test(
    'map run status to firebase, '
    'pending status should be mapped to pending status dto',
    () {
      const RunStatusPending status = RunStatusPending();
      const firebase.RunStatusDto expectedDto = firebase.RunStatusPendingDto();

      final dto = mapRunStatusToFirebase(status);

      expect(dto, expectedDto);
    },
  );

  test(
    'map run status to firebase, '
    'done status should be mapped to done status dto',
    () {
      final RunStatusDone status = RunStatusDone(
        coveredDistanceInKm: 10.0,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      final firebase.RunStatusDto expectedDto = firebase.RunStatusDoneDto(
        coveredDistanceInKm: 10.0,
        avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        comment: 'comment',
      );

      final dto = mapRunStatusToFirebase(status);

      expect(dto, expectedDto);
    },
  );

  test(
    'map run status to firebase, '
    'aborted status should be mapped to aborted status dto',
    () {
      final RunStatusAborted status = RunStatusAborted(
        coveredDistanceInKm: 10.0,
        avgPace: const Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );
      final firebase.RunStatusDto expectedDto = firebase.RunStatusAbortedDto(
        coveredDistanceInKm: 10.0,
        avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        comment: 'comment',
      );

      final dto = mapRunStatusToFirebase(status);

      expect(dto, expectedDto);
    },
  );

  test(
    'map run status to firebase, '
    'undone status should be mapped to undone status dto',
    () {
      const RunStatusUndone status = RunStatusUndone();
      const firebase.RunStatusDto expectedDto = firebase.RunStatusUndoneDto();

      final dto = mapRunStatusToFirebase(status);

      expect(dto, expectedDto);
    },
  );
}