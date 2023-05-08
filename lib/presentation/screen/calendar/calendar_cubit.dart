import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/model/workout.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';

class CalendarCubit extends Cubit<List<Workout>?> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  StreamSubscription<List<Workout>?>? _workoutsListener;

  CalendarCubit({
    required AuthService authService,
    required WorkoutRepository workoutRepository,
  })  : _authService = authService,
        _workoutRepository = workoutRepository,
        super(null);

  @override
  Future<void> close() {
    _disposeWorkoutsListener();
    return super.close();
  }

  void monthChanged({
    required DateTime firstDisplayingDate,
    required DateTime lastDisplayingDate,
  }) {
    _disposeWorkoutsListener();
    _setWorkoutsListener(firstDisplayingDate, lastDisplayingDate);
  }

  void _setWorkoutsListener(DateTime startDate, DateTime endDate) {
    _workoutsListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String loggedUserId) => _workoutRepository.getWorkoutsByDateRange(
            startDate: startDate,
            endDate: endDate,
            userId: loggedUserId,
          ),
        )
        .listen(
          (List<Workout>? workouts) => emit(workouts),
        );
  }

  void _disposeWorkoutsListener() {
    _workoutsListener?.cancel();
    _workoutsListener = null;
  }
}
