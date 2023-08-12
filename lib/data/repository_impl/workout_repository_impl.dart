import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';

import '../../common/date_service.dart';
import '../../dependency_injection.dart';
import '../../domain/additional_model/run_status.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/additional_model/workout_stage.dart';
import '../../domain/entity/workout.dart';
import '../../domain/repository/workout_repository.dart';
import '../mapper/run_status_mapper.dart';
import '../mapper/workout_mapper.dart';
import '../mapper/workout_stage_mapper.dart';

class WorkoutRepositoryImpl extends StateRepository<Workout>
    implements WorkoutRepository {
  final FirebaseWorkoutService _firebaseWorkoutService;
  final DateService _dateService;

  WorkoutRepositoryImpl({
    List<Workout>? initialState,
  })  : _firebaseWorkoutService = getIt<FirebaseWorkoutService>(),
        _dateService = getIt<DateService>(),
        super(initialData: initialState);

  @override
  Stream<List<Workout>?> getWorkoutsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async* {
    await _loadWorkoutsByDateRangeFromRemoteDb(startDate, endDate, userId);
    await for (final workouts in dataStream$) {
      yield workouts
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
    }
  }

  @override
  Stream<Workout?> getWorkoutById({
    required String workoutId,
    required String userId,
  }) async* {
    await for (final workouts in dataStream$) {
      Workout? workout = workouts?.firstWhereOrNull(
        (workout) => workout.id == workoutId && workout.userId == userId,
      );
      workout ??= await _loadWorkoutByIdFromRemoteDb(workoutId, userId);
      yield workout;
    }
  }

  @override
  Stream<List<Workout>?> getWorkoutsByDate({
    required DateTime date,
    required String userId,
  }) async* {
    await _loadWorkoutsByDateFromRemoteDb(userId, date);
    await for (final workouts in dataStream$) {
      yield workouts
          ?.where(
            (workout) =>
                workout.userId == userId &&
                _dateService.areDatesTheSame(workout.date, date),
          )
          .toList();
    }
  }

  @override
  Stream<List<Workout>?> getAllWorkouts({required String userId}) async* {
    await _loadWorkoutsFromRemoteDb(userId);
    await for (final workouts in dataStream$) {
      yield workouts?.where((workout) => workout.userId == userId).toList();
    }
  }

  @override
  Future<void> addWorkout({
    required String userId,
    required String workoutName,
    required DateTime date,
    required RunStatus status,
    required List<WorkoutStage> stages,
  }) async {
    final WorkoutDto? workoutDto = await _firebaseWorkoutService.addWorkout(
      userId: userId,
      workoutName: workoutName,
      date: date,
      status: mapRunStatusToDto(status),
      stages: stages.map(mapWorkoutStageToFirebase).toList(),
    );
    if (workoutDto != null) {
      final Workout addedWorkout = mapWorkoutFromFirebase(workoutDto);
      addEntity(addedWorkout);
    }
  }

  @override
  Future<void> updateWorkout({
    required String workoutId,
    required String userId,
    DateTime? date,
    String? workoutName,
    RunStatus? status,
    List<WorkoutStage>? stages,
  }) async {
    final WorkoutDto? updatedWorkoutDto =
        await _firebaseWorkoutService.updateWorkout(
      workoutId: workoutId,
      userId: userId,
      date: date,
      workoutName: workoutName,
      status: status != null ? mapRunStatusToDto(status) : null,
      stages: stages?.map(mapWorkoutStageToFirebase).toList(),
    );
    if (updatedWorkoutDto != null) {
      final Workout updatedWorkout = mapWorkoutFromFirebase(updatedWorkoutDto);
      updateEntity(updatedWorkout);
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

  @override
  Future<void> deleteAllUserWorkouts({required String userId}) async {
    final List<String> idsOfDeletedWorkouts =
        await _firebaseWorkoutService.deleteAllUserWorkouts(userId: userId);
    removeEntities(idsOfDeletedWorkouts);
  }

  Future<void> _loadWorkoutsByDateRangeFromRemoteDb(
    DateTime startDate,
    DateTime endDate,
    String userId,
  ) async {
    final List<WorkoutDto>? workoutDtos =
        await _firebaseWorkoutService.loadWorkoutsByDateRange(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
    if (workoutDtos != null) {
      final List<Workout> workouts = workoutDtos
          .map(
            (WorkoutDto workoutDto) => mapWorkoutFromFirebase(workoutDto),
          )
          .toList();
      addOrUpdateEntities(workouts);
    }
  }

  Future<Workout?> _loadWorkoutByIdFromRemoteDb(
    String workoutId,
    String userId,
  ) async {
    final WorkoutDto? workoutDto =
        await _firebaseWorkoutService.loadWorkoutById(
      workoutId: workoutId,
      userId: userId,
    );
    if (workoutDto != null) {
      final Workout workout = mapWorkoutFromFirebase(workoutDto);
      addEntity(workout);
      return workout;
    }
    return null;
  }

  Future<void> _loadWorkoutsFromRemoteDb(String userId) async {
    final List<WorkoutDto>? workoutDtos =
        await _firebaseWorkoutService.loadAllWorkouts(userId: userId);
    if (workoutDtos != null) {
      final List<Workout> workouts =
          workoutDtos.map(mapWorkoutFromFirebase).toList();
      addOrUpdateEntities(workouts);
    }
  }

  Future<void> _loadWorkoutsByDateFromRemoteDb(
    String userId,
    DateTime date,
  ) async {
    final List<WorkoutDto>? workoutDtos = await _firebaseWorkoutService
        .loadWorkoutsByDate(date: date, userId: userId);
    if (workoutDtos != null) {
      final List<Workout> workouts =
          workoutDtos.map(mapWorkoutFromFirebase).toList();
      addOrUpdateEntities(workouts);
    }
  }
}
