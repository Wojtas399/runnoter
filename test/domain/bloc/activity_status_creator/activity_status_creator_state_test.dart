import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/activity_status.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/activity_status_creator/activity_status_creator_bloc.dart';

void main() {
  late ActivityStatusCreatorState state;

  setUp(() {
    state = const ActivityStatusCreatorState(
      status: BlocStatusInitial(),
    );
  });

  test(
    'can submit, '
    'activity status type is null, '
    'should be false',
    () {
      state = state.copyWith(
        activityStatusType: null,
        coveredDistanceInKm: 10,
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 30),
        avgHeartRate: 150,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'activity status type is set as pending, '
    'should be true',
    () {
      state = state.copyWith(
        activityStatusType: ActivityStatusType.pending,
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'activity status type is set as undone, '
    'should be true',
    () {
      state = state.copyWith(
        activityStatusType: ActivityStatusType.undone,
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'covered distance in km is null, '
    'should be false',
    () {
      state = state.copyWith(
        activityStatusType: ActivityStatusType.done,
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 30),
        avgHeartRate: 150,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'covered distance in km is 0, '
    'should be false',
    () {
      state = state.copyWith(
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 0,
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 30),
        avgHeartRate: 150,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'duration is 0, '
    'should be false',
    () {
      state = state.copyWith(
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10.0,
        duration: const Duration(),
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 30),
        avgHeartRate: 150,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'mood rate is null, '
    'should be false',
    () {
      state = state.copyWith(
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        avgPace: const Pace(minutes: 5, seconds: 30),
        avgHeartRate: 150,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'average pace is null, '
    'should be false',
    () {
      state = state.copyWith(
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        moodRate: MoodRate.mr8,
        avgHeartRate: 150,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'average pace minutes and seconds is 0, '
    'should be false',
    () {
      state = state.copyWith(
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 0, seconds: 0),
        avgHeartRate: 150,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'average heart rate is null, '
    'should be false',
    () {
      state = state.copyWith(
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 30),
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'average heart rate is 0, '
    'should be false',
    () {
      state = state.copyWith(
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 30),
        avgHeartRate: 0,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'all required params are valid, '
    'should be true',
    () {
      state = state.copyWith(
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        moodRate: MoodRate.mr8,
        avgPace: const Pace(minutes: 5, seconds: 30),
        avgHeartRate: 150,
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'activity status type does not match to original activity status, '
    'should be true',
    () {
      state = state.copyWith(
        originalActivityStatus: const ActivityStatusPending(),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 10),
        avgPace: const Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'original activity status contains activity stats, '
    'all params are the same as params set in original activity status, '
    'should be false',
    () {
      state = state.copyWith(
        originalActivityStatus: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 10),
        avgPace: const Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'original activity status contains activity stats, '
    'covered distance is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        originalActivityStatus: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 12,
        duration: const Duration(seconds: 10),
        avgPace: const Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'original activity status contains activity stats, '
    'duration is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        originalActivityStatus: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 12,
        duration: const Duration(seconds: 15),
        avgPace: const Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'original activity status contains activity stats, '
    'average pace is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        originalActivityStatus: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 10),
        avgPace: const Pace(minutes: 5, seconds: 10),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'original activity status contains activity stats, '
    'average heart rate is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        originalActivityStatus: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 10),
        avgPace: const Pace(minutes: 6, seconds: 10),
        avgHeartRate: 145,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'original activity status contains activity stats, '
    'mood rate is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        originalActivityStatus: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 10),
        avgPace: const Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        moodRate: MoodRate.mr5,
        comment: 'comment',
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'original activity status contains activity stats, '
    'comment is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        originalActivityStatus: const ActivityStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        activityStatusType: ActivityStatusType.done,
        coveredDistanceInKm: 10,
        duration: const Duration(seconds: 10),
        avgPace: const Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'new comment',
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with original activity status',
    () {
      const ActivityStatus expectedOriginalActivityStatus = ActivityStatusDone(
        coveredDistanceInKm: 10,
        avgPace: Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      state = state.copyWith(
          originalActivityStatus: expectedOriginalActivityStatus);
      final state2 = state.copyWith();

      expect(state.originalActivityStatus, expectedOriginalActivityStatus);
      expect(state2.originalActivityStatus, expectedOriginalActivityStatus);
    },
  );

  test(
    'copy with activity status type',
    () {
      const ActivityStatusType expectedActivityStatusType =
          ActivityStatusType.pending;

      state = state.copyWith(activityStatusType: expectedActivityStatusType);
      final state2 = state.copyWith();

      expect(state.activityStatusType, expectedActivityStatusType);
      expect(state2.activityStatusType, expectedActivityStatusType);
    },
  );

  test(
    'copy with covered distance in km',
    () {
      const double expectedCoveredDistanceInKm = 10.0;

      state = state.copyWith(coveredDistanceInKm: expectedCoveredDistanceInKm);
      final state2 = state.copyWith();

      expect(state.coveredDistanceInKm, expectedCoveredDistanceInKm);
      expect(state2.coveredDistanceInKm, expectedCoveredDistanceInKm);
    },
  );

  test(
    'copy with duration',
    () {
      const Duration expectedDuration = Duration(seconds: 10);

      state = state.copyWith(duration: expectedDuration);
      final state2 = state.copyWith();

      expect(state.duration, expectedDuration);
      expect(state2.duration, expectedDuration);
    },
  );

  test(
    'copy with mood rate',
    () {
      const MoodRate expectedMoodRate = MoodRate.mr8;

      state = state.copyWith(moodRate: expectedMoodRate);
      final state2 = state.copyWith();

      expect(state.moodRate, expectedMoodRate);
      expect(state2.moodRate, expectedMoodRate);
    },
  );

  test(
    'copy with average pace',
    () {
      const Pace expectedAvgPace = Pace(minutes: 5, seconds: 45);

      state = state.copyWith(avgPace: expectedAvgPace);
      final state2 = state.copyWith();

      expect(state.avgPace, expectedAvgPace);
      expect(state2.avgPace, expectedAvgPace);
    },
  );

  test(
    'copy with average heart rate',
    () {
      const int expectedAverageHeartRate = 150;

      state = state.copyWith(avgHeartRate: expectedAverageHeartRate);
      final state2 = state.copyWith();

      expect(state.avgHeartRate, expectedAverageHeartRate);
      expect(state2.avgHeartRate, expectedAverageHeartRate);
    },
  );

  test(
    'copy with comment',
    () {
      const String expectedComment = 'comment';

      state = state.copyWith(comment: expectedComment);
      final state2 = state.copyWith();

      expect(state.comment, expectedComment);
      expect(state2.comment, expectedComment);
    },
  );
}
