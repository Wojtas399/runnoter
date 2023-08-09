import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/run_status.dart';
import 'package:runnoter/domain/bloc/run_status_creator/run_status_creator_bloc.dart';

void main() {
  late RunStatusCreatorState state;

  setUp(() {
    state = const RunStatusCreatorState(
      status: BlocStatusInitial(),
    );
  });

  test(
    'can submit, '
    'run status type is null, '
    'should be false',
    () {
      state = state.copyWith(
        runStatusType: null,
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
    'run status type is set as pending, '
    'should be true',
    () {
      state = state.copyWith(
        runStatusType: RunStatusType.pending,
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'run status type is set as undone, '
    'should be true',
    () {
      state = state.copyWith(
        runStatusType: RunStatusType.undone,
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
        runStatusType: RunStatusType.done,
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
        runStatusType: RunStatusType.done,
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
        runStatusType: RunStatusType.done,
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
        runStatusType: RunStatusType.done,
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
        runStatusType: RunStatusType.done,
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
        runStatusType: RunStatusType.done,
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
        runStatusType: RunStatusType.done,
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
        runStatusType: RunStatusType.done,
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
        runStatusType: RunStatusType.done,
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
    'run status type does not match to original run status, '
    'should be true',
    () {
      state = state.copyWith(
        originalRunStatus: const RunStatusPending(),
        runStatusType: RunStatusType.done,
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
    'original run status contains run stats, '
    'all params are the same as params set in original run status, '
    'should be false',
    () {
      state = state.copyWith(
        originalRunStatus: const RunStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        runStatusType: RunStatusType.done,
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
    'original run status contains run stats, '
    'covered distance is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        originalRunStatus: const RunStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        runStatusType: RunStatusType.done,
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
    'original run status contains run stats, '
    'duration is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        originalRunStatus: const RunStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        runStatusType: RunStatusType.done,
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
    'original run status contains run stats, '
    'average pace is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        originalRunStatus: const RunStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        runStatusType: RunStatusType.done,
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
    'original run status contains run stats, '
    'average heart rate is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        originalRunStatus: const RunStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        runStatusType: RunStatusType.done,
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
    'original run status contains run stats, '
    'mood rate is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        originalRunStatus: const RunStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        runStatusType: RunStatusType.done,
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
    'original run status contains run stats, '
    'comment is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        originalRunStatus: const RunStatusDone(
          coveredDistanceInKm: 10,
          duration: Duration(seconds: 10),
          avgPace: Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        runStatusType: RunStatusType.done,
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
    'copy with original run status',
    () {
      const RunStatus expectedOriginalRunStatus = RunStatusDone(
        coveredDistanceInKm: 10,
        avgPace: Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      state = state.copyWith(originalRunStatus: expectedOriginalRunStatus);
      final state2 = state.copyWith();

      expect(state.originalRunStatus, expectedOriginalRunStatus);
      expect(state2.originalRunStatus, expectedOriginalRunStatus);
    },
  );

  test(
    'copy with run status type',
    () {
      const RunStatusType expectedRunStatusType = RunStatusType.pending;

      state = state.copyWith(runStatusType: expectedRunStatusType);
      final state2 = state.copyWith();

      expect(state.runStatusType, expectedRunStatusType);
      expect(state2.runStatusType, expectedRunStatusType);
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
