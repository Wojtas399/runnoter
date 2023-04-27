import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_workout_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/date_service.dart';
import '../../domain/model/state_repository.dart';
import '../../domain/model/workout.dart';
import '../../domain/model/workout_stage.dart';
import '../../domain/model/workout_status.dart';
import '../../domain/repository/workout_repository.dart';
import '../mapper/workout_mapper.dart';
import '../mapper/workout_stage_mapper.dart';
import '../mapper/workout_status_mapper.dart';

class WorkoutRepositoryImpl extends StateRepository<Workout>
    implements WorkoutRepository {
  final FirebaseWorkoutService _firebaseWorkoutService;
  final DateService _dateService;

  WorkoutRepositoryImpl({
    required FirebaseWorkoutService firebaseWorkoutService,
    required DateService dateService,
    List<Workout>? initialState,
  })  : _firebaseWorkoutService = firebaseWorkoutService,
        _dateService = dateService,
        super(initialData: initialState);

  @override
  Stream<List<Workout>?> getWorkoutsByUserIdAndDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return dataStream$
        .map(
          (List<Workout>? workouts) =>
              _findWorkoutsMatchingToUserIdAndDateRange(
            workouts,
            userId,
            startDate,
            endDate,
          ),
        )
        .doOnListen(
          () => _loadWorkoutsByUserIdAndDateRangeFromRemoteDb(
            userId,
            startDate,
            endDate,
          ),
        );
  }

  @override
  Stream<Workout?> getWorkoutByUserIdAndDate({
    required String userId,
    required DateTime date,
  }) {
    return dataStream$
        .map(
          (workouts) => _findWorkoutMatchingToUserIdAndDate(
            workouts,
            userId,
            date,
          ),
        )
        .doOnListen(
          () => _loadWorkoutByUserIdAndDate(userId, date),
        );
  }

  @override
  Future<void> addWorkout({
    required String userId,
    required String workoutName,
    required DateTime date,
    required WorkoutStatus status,
    required List<WorkoutStage> stages,
  }) async {
    final WorkoutDto? workoutDto = await _firebaseWorkoutService.addWorkout(
      userId: userId,
      workoutName: workoutName,
      date: date,
      status: mapWorkoutStatusToFirebase(status),
      stages: stages.map(mapWorkoutStageToFirebase).toList(),
    );
    if (workoutDto != null) {
      final Workout addedWorkout = mapWorkoutFromFirebase(workoutDto);
      addEntity(addedWorkout);
    }
  }

  @override
  Future<void> deleteWorkout({
    required String userId,
    required String workoutId,
  }) async {
    await _firebaseWorkoutService.deleteWorkout(
      userId: userId,
      workoutId: workoutId,
    );
    removeEntity(workoutId);
  }

  List<Workout>? _findWorkoutsMatchingToUserIdAndDateRange(
    List<Workout>? workouts,
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) =>
      workouts
          ?.where(
            (Workout workout) =>
                workout.userId == userId &&
                _dateService.isDateFromRange(
                  date: workout.date,
                  startDate: startDate,
                  endDate: endDate,
                ),
          )
          .toList();

  Workout? _findWorkoutMatchingToUserIdAndDate(
    List<Workout>? workouts,
    String userId,
    DateTime date,
  ) =>
      <Workout?>[...?workouts].firstWhere(
        (Workout? workout) =>
            workout != null &&
            workout.userId == userId &&
            _dateService.areDatesTheSame(workout.date, date),
        orElse: () => null,
      );

  Future<void> _loadWorkoutsByUserIdAndDateRangeFromRemoteDb(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final List<WorkoutDto>? workoutDtos =
        await _firebaseWorkoutService.loadWorkoutsByUserIdAndDateRange(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
    if (workoutDtos == null) {
      return;
    }
    final List<Workout> workouts = workoutDtos
        .map(
          (WorkoutDto workoutDto) => mapWorkoutFromFirebase(workoutDto),
        )
        .toList();
    addEntities(workouts);
  }

  Future<void> _loadWorkoutByUserIdAndDate(
    String userId,
    DateTime date,
  ) async {
    final WorkoutDto? workoutDto =
        await _firebaseWorkoutService.loadWorkoutByUserIdAndDate(
      userId: userId,
      date: date,
    );
    if (workoutDto == null) {
      return;
    }
    final Workout workout = mapWorkoutFromFirebase(workoutDto);
    addEntity(workout);
  }
}
