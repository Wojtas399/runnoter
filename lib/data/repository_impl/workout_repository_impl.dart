import '../../domain/model/state_repository.dart';
import '../../domain/model/workout.dart';
import '../../domain/model/workout_stage.dart';
import '../../domain/model/workout_status.dart';
import '../../domain/repository/workout_repository.dart';

class WorkoutRepositoryImpl extends StateRepository<Workout>
    implements WorkoutRepository {
  @override
  Stream<List<Workout>?> getWorkoutsFromWeek({
    required String userId,
    required DateTime dateFromWeek,
  }) {
    return Stream.value(
      [
        Workout(
          id: 'w1',
          date: DateTime(2023, 4, 4),
          status: const WorkoutStatusDone(
            coveredDistanceInKm: 10,
            avgPace: Pace(minutes: 6, seconds: 31),
            avgHeartRate: 147,
            moodRate: MoodRate.mr8,
            comment: 'Good workout',
          ),
          name: 'Rytmy',
          stages: const [
            WorkoutStageOWB(
              distanceInKm: 7,
              maxHeartRate: 150,
            ),
            WorkoutStageRhythm(
              amountOfSeries: 10,
              rhythmDistanceInKilometers: 0.1,
              marchDistanceInKilometers: 0,
              jogDistanceInKilometers: 0.2,
            ),
          ],
          additionalWorkout: AdditionalWorkout.strengthening,
        ),
        Workout(
          id: 'w2',
          date: DateTime(2023, 4, 6),
          status: const WorkoutStatusPending(),
          name: 'BC2',
          stages: const [
            WorkoutStageOWB(
              distanceInKm: 2,
              maxHeartRate: 150,
            ),
            WorkoutStageBC2(
              distanceInKm: 6,
              maxHeartRate: 165,
            ),
            WorkoutStageOWB(
              distanceInKm: 1,
              maxHeartRate: 150,
            ),
          ],
        ),
      ],
    );
  }
}
