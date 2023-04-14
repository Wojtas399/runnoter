import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_workout_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/date_service.dart';
import '../../domain/model/state_repository.dart';
import '../../domain/model/workout.dart';
import '../../domain/repository/workout_repository.dart';
import '../mapper/workout_mapper.dart';

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
      (List<Workout>? workouts) => workouts
          ?.where(
            (Workout workout) =>
                workout.userId == userId &&
                _dateService.isDateFromRange(
                  date: workout.date,
                  startDate: startDate,
                  endDate: endDate,
                ),
          )
          .toList(),
    )
        .doOnListen(
      () {
        _loadWorkoutsByUserIdAndDateRangeFromRemoteDb(
          userId,
          startDate,
          endDate,
        );
      },
    );
  }

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
}
