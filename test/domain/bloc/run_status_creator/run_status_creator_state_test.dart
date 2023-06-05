import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/run_status_creator/run_status_creator_bloc.dart';
import 'package:runnoter/domain/entity/run_status.dart';

void main() {
  late RunStatusCreatorState state;

  setUp(() {
    state = const RunStatusCreatorState(
      status: BlocStatusInitial(),
    );
  });

  test(
    'is form valid, '
    'workout status type is null, '
    'should be false',
    () {
      state = state.copyWith(
        coveredDistanceInKm: 10,
        moodRate: MoodRate.mr8,
        averagePaceMinutes: 5,
        averagePaceSeconds: 30,
        averageHeartRate: 150,
      );

      expect(state.isFormValid, false);
    },
  );

  test(
    'is form valid, '
    'workout status type is set as pending, '
    'should be true',
    () {
      state = state.copyWith(
        runStatusType: RunStatusType.pending,
      );

      expect(state.isFormValid, true);
    },
  );

  test(
    'is form valid, '
    'workout status type is set as undone, '
    'should be true',
    () {
      state = state.copyWith(
        runStatusType: RunStatusType.undone,
      );

      expect(state.isFormValid, true);
    },
  );

  test(
    'is form valid, '
    'covered distance in km is null, '
    'should be false',
    () {
      state = state.copyWith(
        runStatusType: RunStatusType.done,
        moodRate: MoodRate.mr8,
        averagePaceMinutes: 5,
        averagePaceSeconds: 30,
        averageHeartRate: 150,
      );

      expect(state.isFormValid, false);
    },
  );

  test(
    'is form valid, '
    'mood rate is null, '
    'should be true',
    () {
      state = state.copyWith(
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
        averagePaceMinutes: 5,
        averagePaceSeconds: 30,
        averageHeartRate: 150,
      );

      expect(state.isFormValid, false);
    },
  );

  test(
    'is form valid, '
    'average pace minutes is null, '
    'should be true',
    () {
      state = state.copyWith(
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
        moodRate: MoodRate.mr8,
        averagePaceSeconds: 30,
        averageHeartRate: 150,
      );

      expect(state.isFormValid, false);
    },
  );

  test(
    'is form valid, '
    'average pace seconds is null, '
    'should be false',
    () {
      state = state.copyWith(
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
        moodRate: MoodRate.mr8,
        averagePaceMinutes: 5,
        averageHeartRate: 150,
      );

      expect(state.isFormValid, false);
    },
  );

  test(
    'is form valid, '
    'average heart rate is null, '
    'should be false',
    () {
      state = state.copyWith(
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
        moodRate: MoodRate.mr8,
        averagePaceMinutes: 5,
        averagePaceSeconds: 30,
      );

      expect(state.isFormValid, false);
    },
  );

  test(
    'is form valid, '
    'all required params arent null, '
    'should be true',
    () {
      state = state.copyWith(
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
        moodRate: MoodRate.mr8,
        averagePaceMinutes: 5,
        averagePaceSeconds: 30,
        averageHeartRate: 150,
      );

      expect(state.isFormValid, true);
    },
  );

  test(
    'are data same as original, '
    'run status type does not match to workout status, '
    'should be false',
    () {
      state = state.copyWith(
        runStatus: const RunStatusPending(),
        runStatusType: RunStatusType.done,
      );

      expect(state.areDataSameAsOriginal, false);
    },
  );

  test(
    'are data same as original, '
    'run status is set as pending, '
    'should be false',
    () {
      state = state.copyWith(
        runStatus: const RunStatusPending(),
      );

      expect(state.areDataSameAsOriginal, false);
    },
  );

  test(
    'are data same as original, '
    'run status is set as undone, '
    'should be false',
    () {
      state = state.copyWith(
        runStatus: const RunStatusUndone(),
      );

      expect(state.areDataSameAsOriginal, false);
    },
  );

  test(
    'are data same as original, '
    'run status contains run stats, '
    'all params are the same as params set in run status, '
    'should be true',
    () {
      state = state.copyWith(
        runStatus: RunStatusDone(
          coveredDistanceInKm: 10,
          avgPace: const Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        runStatusType: RunStatusType.done,
        coveredDistanceInKm: 10,
        averagePaceMinutes: 6,
        averagePaceSeconds: 10,
        averageHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      expect(state.areDataSameAsOriginal, true);
    },
  );

  test(
    'are data same as original, '
    'run status contains run stats, '
    'covered distance is different than original value, '
    'should be false',
    () {
      state = state.copyWith(
        runStatus: RunStatusDone(
          coveredDistanceInKm: 10,
          avgPace: const Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        coveredDistanceInKm: 12,
        averagePaceMinutes: 6,
        averagePaceSeconds: 10,
        averageHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      expect(state.areDataSameAsOriginal, false);
    },
  );

  test(
    'are data same as original, '
    'run status contains run stats, '
    'minutes of average pace are different than original value, '
    'should be false',
    () {
      state = state.copyWith(
        runStatus: RunStatusDone(
          coveredDistanceInKm: 10,
          avgPace: const Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        coveredDistanceInKm: 10,
        averagePaceMinutes: 5,
        averagePaceSeconds: 10,
        averageHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      expect(state.areDataSameAsOriginal, false);
    },
  );

  test(
    'are data same as original, '
    'run status contains run stats, '
    'seconds of average pace are different than original value, '
    'should be false',
    () {
      state = state.copyWith(
        runStatus: RunStatusDone(
          coveredDistanceInKm: 10,
          avgPace: const Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        coveredDistanceInKm: 10,
        averagePaceMinutes: 6,
        averagePaceSeconds: 5,
        averageHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      expect(state.areDataSameAsOriginal, false);
    },
  );

  test(
    'are data same as original, '
    'run status contains run stats, '
    'average heart rate is different than original value, '
    'should be false',
    () {
      state = state.copyWith(
        runStatus: RunStatusDone(
          coveredDistanceInKm: 10,
          avgPace: const Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        coveredDistanceInKm: 10,
        averagePaceMinutes: 6,
        averagePaceSeconds: 10,
        averageHeartRate: 145,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      expect(state.areDataSameAsOriginal, false);
    },
  );

  test(
    'are data same as original, '
    'run status contains run stats, '
    'mood rate is different than original value, '
    'should be false',
    () {
      state = state.copyWith(
        runStatus: RunStatusDone(
          coveredDistanceInKm: 10,
          avgPace: const Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        coveredDistanceInKm: 10,
        averagePaceMinutes: 6,
        averagePaceSeconds: 10,
        averageHeartRate: 150,
        moodRate: MoodRate.mr5,
        comment: 'comment',
      );

      expect(state.areDataSameAsOriginal, false);
    },
  );

  test(
    'are data same as original, '
    'run status contains run stats, '
    'comment is different than original value, '
    'should be false',
    () {
      state = state.copyWith(
        runStatus: RunStatusDone(
          coveredDistanceInKm: 10,
          avgPace: const Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        coveredDistanceInKm: 10,
        averagePaceMinutes: 6,
        averagePaceSeconds: 10,
        averageHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'new comment',
      );

      expect(state.areDataSameAsOriginal, false);
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
    'copy with workout id',
    () {
      const String expectedWorkoutId = 'w1';

      state = state.copyWith(workoutId: expectedWorkoutId);
      final state2 = state.copyWith();

      expect(state.workoutId, expectedWorkoutId);
      expect(state2.workoutId, expectedWorkoutId);
    },
  );

  test(
    'copy with run status',
    () {
      final RunStatus expectedRunStatus = RunStatusDone(
        coveredDistanceInKm: 10,
        avgPace: const Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      state = state.copyWith(runStatus: expectedRunStatus);
      final state2 = state.copyWith();

      expect(state.runStatus, expectedRunStatus);
      expect(state2.runStatus, expectedRunStatus);
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
    'copy with average pace minutes',
    () {
      const int expectedAveragePaceMinutes = 6;

      state = state.copyWith(averagePaceMinutes: expectedAveragePaceMinutes);
      final state2 = state.copyWith();

      expect(state.averagePaceMinutes, expectedAveragePaceMinutes);
      expect(state2.averagePaceMinutes, expectedAveragePaceMinutes);
    },
  );

  test(
    'copy with average pace seconds',
    () {
      const int expectedAveragePaceSeconds = 10;

      state = state.copyWith(averagePaceSeconds: expectedAveragePaceSeconds);
      final state2 = state.copyWith();

      expect(state.averagePaceSeconds, expectedAveragePaceSeconds);
      expect(state2.averagePaceSeconds, expectedAveragePaceSeconds);
    },
  );

  test(
    'copy with average heart rate',
    () {
      const int expectedAverageHeartRate = 150;

      state = state.copyWith(averageHeartRate: expectedAverageHeartRate);
      final state2 = state.copyWith();

      expect(state.averageHeartRate, expectedAverageHeartRate);
      expect(state2.averageHeartRate, expectedAverageHeartRate);
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