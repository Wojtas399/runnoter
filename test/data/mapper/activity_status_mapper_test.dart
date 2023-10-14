import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/additional_model/activity_status.dart';
import 'package:runnoter/data/mapper/activity_status_mapper.dart';

void main() {
  test(
    'map activity status from dto, '
    'pending status dto model should be mapped to domain pending status model',
    () {
      const firebase.ActivityStatusDto statusDto =
          firebase.ActivityStatusPendingDto();
      const ActivityStatusPending expectedStatus = ActivityStatusPending();

      final ActivityStatus status = mapActivityStatusFromDto(statusDto);

      expect(status, expectedStatus);
    },
  );

  test(
    'map activity status from dto, '
    'done status dto model should be mapped to domain done status model',
    () {
      final firebase.ActivityStatusDto statusDto =
          firebase.ActivityStatusDoneDto(
        coveredDistanceInKm: 10.0,
        avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        duration: const Duration(seconds: 3),
        comment: 'comment',
      );
      const ActivityStatusDone expectedStatus = ActivityStatusDone(
        coveredDistanceInKm: 10.0,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        duration: Duration(seconds: 3),
        comment: 'comment',
      );

      final ActivityStatus status = mapActivityStatusFromDto(statusDto);

      expect(status, expectedStatus);
    },
  );

  test(
    'map activity status from dto, '
    'aborted status dto model should be mapped to domain aborted status model',
    () {
      final firebase.ActivityStatusDto statusDto =
          firebase.ActivityStatusAbortedDto(
        coveredDistanceInKm: 10.0,
        avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        duration: const Duration(seconds: 3),
        comment: 'comment',
      );
      const ActivityStatusAborted expectedStatus = ActivityStatusAborted(
        coveredDistanceInKm: 10.0,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        duration: Duration(seconds: 3),
        comment: 'comment',
      );

      final ActivityStatus status = mapActivityStatusFromDto(statusDto);

      expect(status, expectedStatus);
    },
  );

  test(
    'map activity status from dto, '
    'undone status dto model should be mapped to domain undone status model',
    () {
      const firebase.ActivityStatusDto statusDto =
          firebase.ActivityStatusUndoneDto();
      const ActivityStatusUndone expectedStatus = ActivityStatusUndone();

      final ActivityStatus status = mapActivityStatusFromDto(statusDto);

      expect(status, expectedStatus);
    },
  );

  test(
    'map activity status to dto, '
    'pending status should be mapped to pending status dto',
    () {
      const ActivityStatusPending status = ActivityStatusPending();
      const firebase.ActivityStatusDto expectedDto =
          firebase.ActivityStatusPendingDto();

      final dto = mapActivityStatusToDto(status);

      expect(dto, expectedDto);
    },
  );

  test(
    'map activity status to dto, '
    'done status should be mapped to done status dto',
    () {
      const ActivityStatusDone status = ActivityStatusDone(
        coveredDistanceInKm: 10.0,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        duration: Duration(seconds: 3),
        comment: 'comment',
      );
      final firebase.ActivityStatusDto expectedDto =
          firebase.ActivityStatusDoneDto(
        coveredDistanceInKm: 10.0,
        avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        duration: const Duration(seconds: 3),
        comment: 'comment',
      );

      final dto = mapActivityStatusToDto(status);

      expect(dto, expectedDto);
    },
  );

  test(
    'map activity status to dto, '
    'aborted status should be mapped to aborted status dto',
    () {
      const ActivityStatusAborted status = ActivityStatusAborted(
        coveredDistanceInKm: 10.0,
        avgPace: Pace(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: MoodRate.mr8,
        duration: Duration(seconds: 3),
        comment: 'comment',
      );
      final firebase.ActivityStatusDto expectedDto =
          firebase.ActivityStatusAbortedDto(
        coveredDistanceInKm: 10.0,
        avgPaceDto: const firebase.PaceDto(minutes: 5, seconds: 50),
        avgHeartRate: 146,
        moodRate: firebase.MoodRate.mr8,
        duration: const Duration(seconds: 3),
        comment: 'comment',
      );

      final dto = mapActivityStatusToDto(status);

      expect(dto, expectedDto);
    },
  );

  test(
    'map activity status to dto, '
    'undone status should be mapped to undone status dto',
    () {
      const ActivityStatusUndone status = ActivityStatusUndone();
      const firebase.ActivityStatusDto expectedDto =
          firebase.ActivityStatusUndoneDto();

      final dto = mapActivityStatusToDto(status);

      expect(dto, expectedDto);
    },
  );
}
