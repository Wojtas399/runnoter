import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/activity_status.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/cubit/activity_status_creator/activity_status_creator_cubit.dart';

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
    'copy with status, '
    'should set complete status if new status is null',
    () {
      const BlocStatus expected = BlocStatusLoading();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with original activity status, '
    'should copy current value if new value is null',
    () {
      const ActivityStatus expected = ActivityStatusDone(
        coveredDistanceInKm: 10,
        avgPace: Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      state = state.copyWith(originalActivityStatus: expected);
      final state2 = state.copyWith();

      expect(state.originalActivityStatus, expected);
      expect(state2.originalActivityStatus, expected);
    },
  );

  test(
    'copy with activity status type, '
    'should copy current value if new value is null',
    () {
      const ActivityStatusType expected = ActivityStatusType.pending;

      state = state.copyWith(activityStatusType: expected);
      final state2 = state.copyWith();

      expect(state.activityStatusType, expected);
      expect(state2.activityStatusType, expected);
    },
  );

  test(
    'copy with covered distance in km, '
    'should copy current value if new value is null',
    () {
      const double expected = 10.0;

      state = state.copyWith(coveredDistanceInKm: expected);
      final state2 = state.copyWith();

      expect(state.coveredDistanceInKm, expected);
      expect(state2.coveredDistanceInKm, expected);
    },
  );

  test(
    'copy with duration, '
    'should copy current value if new value is null',
    () {
      const Duration expected = Duration(seconds: 10);

      state = state.copyWith(duration: expected);
      final state2 = state.copyWith();

      expect(state.duration, expected);
      expect(state2.duration, expected);
    },
  );

  test(
    'copy with mood rate, '
    'should copy current value if new value is null',
    () {
      const MoodRate expected = MoodRate.mr8;

      state = state.copyWith(moodRate: expected);
      final state2 = state.copyWith();

      expect(state.moodRate, expected);
      expect(state2.moodRate, expected);
    },
  );

  test(
    'copy with average pace, '
    'should copy current value if new value is null',
    () {
      const Pace expected = Pace(minutes: 5, seconds: 45);

      state = state.copyWith(avgPace: expected);
      final state2 = state.copyWith();

      expect(state.avgPace, expected);
      expect(state2.avgPace, expected);
    },
  );

  test(
    'copy with average heart rate, '
    'should copy current value if new value is null',
    () {
      const int expected = 150;

      state = state.copyWith(avgHeartRate: expected);
      final state2 = state.copyWith();

      expect(state.avgHeartRate, expected);
      expect(state2.avgHeartRate, expected);
    },
  );

  test(
    'copy with comment, '
    'should copy current value if new value is null',
    () {
      const String expected = 'comment';

      state = state.copyWith(comment: expected);
      final state2 = state.copyWith();

      expect(state.comment, expected);
      expect(state2.comment, expected);
    },
  );
}
