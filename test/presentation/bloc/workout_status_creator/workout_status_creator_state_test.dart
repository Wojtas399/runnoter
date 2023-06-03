import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/entity/workout_status.dart';
import 'package:runnoter/presentation/screen/workout_status_creator/bloc/workout_status_creator_bloc.dart';

void main() {
  late WorkoutStatusCreatorState state;

  setUp(() {
    state = const WorkoutStatusCreatorState(
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
        workoutStatusType: WorkoutStatusType.pending,
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
        workoutStatusType: WorkoutStatusType.undone,
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
        workoutStatusType: WorkoutStatusType.done,
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
        workoutStatusType: WorkoutStatusType.done,
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
        workoutStatusType: WorkoutStatusType.done,
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
        workoutStatusType: WorkoutStatusType.done,
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
        workoutStatusType: WorkoutStatusType.done,
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
        workoutStatusType: WorkoutStatusType.done,
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
    'workout status type does not match to workout status, '
    'should be false',
    () {
      state = state.copyWith(
        workoutStatus: const WorkoutStatusPending(),
        workoutStatusType: WorkoutStatusType.done,
      );

      expect(state.areDataSameAsOriginal, false);
    },
  );

  test(
    'are data same as original, '
    'workout status is set as pending, '
    'should be false',
    () {
      state = state.copyWith(
        workoutStatus: const WorkoutStatusPending(),
      );

      expect(state.areDataSameAsOriginal, false);
    },
  );

  test(
    'are data same as original, '
    'workout status is set as undone, '
    'should be false',
    () {
      state = state.copyWith(
        workoutStatus: const WorkoutStatusUndone(),
      );

      expect(state.areDataSameAsOriginal, false);
    },
  );

  test(
    'are data same as original, '
    'workout status contains workout stats, '
    'all params are the same as params set in workout status, '
    'should be true',
    () {
      state = state.copyWith(
        workoutStatus: WorkoutStatusDone(
          coveredDistanceInKm: 10,
          avgPace: const Pace(minutes: 6, seconds: 10),
          avgHeartRate: 150,
          moodRate: MoodRate.mr8,
          comment: 'comment',
        ),
        workoutStatusType: WorkoutStatusType.done,
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
    'workout status contains workout stats, '
    'covered distance is different than original value, '
    'should be false',
    () {
      state = state.copyWith(
        workoutStatus: WorkoutStatusDone(
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
    'workout status contains workout stats, '
    'minutes of average pace are different than original value, '
    'should be false',
    () {
      state = state.copyWith(
        workoutStatus: WorkoutStatusDone(
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
    'workout status contains workout stats, '
    'seconds of average pace are different than original value, '
    'should be false',
    () {
      state = state.copyWith(
        workoutStatus: WorkoutStatusDone(
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
    'workout status contains workout stats, '
    'average heart rate is different than original value, '
    'should be false',
    () {
      state = state.copyWith(
        workoutStatus: WorkoutStatusDone(
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
    'workout status contains workout stats, '
    'mood rate is different than original value, '
    'should be false',
    () {
      state = state.copyWith(
        workoutStatus: WorkoutStatusDone(
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
    'workout status contains workout stats, '
    'comment is different than original value, '
    'should be false',
    () {
      state = state.copyWith(
        workoutStatus: WorkoutStatusDone(
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
    'copy with workout status',
    () {
      final WorkoutStatus expectedWorkoutStatus = WorkoutStatusDone(
        coveredDistanceInKm: 10,
        avgPace: const Pace(minutes: 6, seconds: 10),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'comment',
      );

      state = state.copyWith(workoutStatus: expectedWorkoutStatus);
      final state2 = state.copyWith();

      expect(state.workoutStatus, expectedWorkoutStatus);
      expect(state2.workoutStatus, expectedWorkoutStatus);
    },
  );

  test(
    'copy with workout status type',
    () {
      const WorkoutStatusType expectedWorkoutStatusType =
          WorkoutStatusType.pending;

      state = state.copyWith(workoutStatusType: expectedWorkoutStatusType);
      final state2 = state.copyWith();

      expect(state.workoutStatusType, expectedWorkoutStatusType);
      expect(state2.workoutStatusType, expectedWorkoutStatusType);
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
