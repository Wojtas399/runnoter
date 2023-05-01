import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/workout_status.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_status_creator/bloc/workout_status_creator_bloc.dart';

void main() {
  late WorkoutStatusCreatorState state;

  setUp(() {
    state = const WorkoutStatusCreatorState(
      status: BlocStatusInitial(),
    );
  });

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
    'copy with average pace',
    () {
      const Pace expectedAveragePace = Pace(minutes: 6, seconds: 30);

      state = state.copyWith(averagePace: expectedAveragePace);
      final state2 = state.copyWith();

      expect(state.averagePace, expectedAveragePace);
      expect(state2.averagePace, expectedAveragePace);
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
