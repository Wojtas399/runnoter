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
  Stream<List<Workout>?> getWorkoutsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) {
    return dataStream$
        .map(
          (List<Workout>? workouts) =>
              _findWorkoutsByDateRange(workouts, userId, startDate, endDate),
        )
        .doOnListen(
          () =>
              _loadWorkoutsByDateRangeFromRemoteDb(startDate, endDate, userId),
        );
  }

  @override
  Stream<Workout?> getWorkoutById({
    required String workoutId,
    required String userId,
  }) {
    return dataStream$
        .map(
      (List<Workout>? workouts) =>
          _findWorkoutById(workouts, workoutId, userId),
    )
        .doOnListen(
      () {
        if (doesEntityNotExistInState(workoutId)) {
          _loadWorkoutByIdFromRemoteDb(workoutId, userId);
        }
      },
    );
  }

  @override
  Stream<Workout?> getWorkoutByDate({
    required DateTime date,
    required String userId,
  }) {
    return dataStream$
        .map(
          (List<Workout>? workouts) =>
              _findWorkoutByDate(workouts, date, userId),
        )
        .doOnListen(
          () => _loadWorkoutByDateFromRemoteDb(date, userId),
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
  Future<void> updateWorkout({
    required String workoutId,
    required String userId,
    String? workoutName,
    WorkoutStatus? status,
    List<WorkoutStage>? stages,
  }) async {
    final WorkoutDto? updatedWorkoutDto =
        await _firebaseWorkoutService.updateWorkout(
      workoutId: workoutId,
      userId: userId,
      workoutName: workoutName,
      status: status != null ? mapWorkoutStatusToFirebase(status) : null,
      stages: [...?stages].map(mapWorkoutStageToFirebase).toList(),
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

  List<Workout>? _findWorkoutsByDateRange(
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

  Workout? _findWorkoutById(
    List<Workout>? workouts,
    String workoutId,
    String userId,
  ) =>
      <Workout?>[...?workouts].firstWhere(
        (Workout? workout) =>
            workout?.id == workoutId && workout?.userId == userId,
        orElse: () => null,
      );

  Workout? _findWorkoutByDate(
    List<Workout>? workouts,
    DateTime date,
    String userId,
  ) =>
      <Workout?>[...?workouts].firstWhere(
        (Workout? workout) =>
            workout != null &&
            workout.userId == userId &&
            _dateService.areDatesTheSame(workout.date, date),
        orElse: () => null,
      );

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

  Future<void> _loadWorkoutByIdFromRemoteDb(
    String workoutId,
    String userId,
  ) async {
    final WorkoutDto? workoutDto =
        await _firebaseWorkoutService.loadWorkoutById(
      workoutId: workoutId,
      userId: userId,
    );
    if (workoutDto == null) {
      return;
    }
    final Workout workout = mapWorkoutFromFirebase(workoutDto);
    addEntity(workout);
  }

  Future<void> _loadWorkoutByDateFromRemoteDb(
    DateTime date,
    String userId,
  ) async {
    final WorkoutDto? workoutDto =
        await _firebaseWorkoutService.loadWorkoutByDate(
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
