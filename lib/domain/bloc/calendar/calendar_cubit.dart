import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../entity/race.dart';
import '../../entity/workout.dart';
import '../../repository/race_repository.dart';
import '../../repository/workout_repository.dart';
import '../../service/auth_service.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  StreamSubscription? _listener;

  CalendarCubit({
    required RaceRepository raceRepository,
    CalendarState state = const CalendarState(),
  })  : _authService = getIt<AuthService>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = raceRepository,
        super(state);

  @override
  Future<void> close() {
    _disposeListener();
    return super.close();
  }

  void monthChanged({
    required DateTime firstDisplayingDate,
    required DateTime lastDisplayingDate,
  }) {
    _disposeListener();
    _setWorkoutsAndRacesListener(
      firstDisplayingDate,
      lastDisplayingDate,
    );
  }

  void _setWorkoutsAndRacesListener(
    DateTime startDate,
    DateTime endDate,
  ) {
    _listener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String loggedUserId) => Rx.combineLatest2(
            _workoutRepository.getWorkoutsByDateRange(
              startDate: startDate,
              endDate: endDate,
              userId: loggedUserId,
            ),
            _raceRepository.getRacesByDateRange(
              userId: loggedUserId,
              startDate: startDate,
              endDate: endDate,
            ),
            (
              List<Workout>? workouts,
              List<Race>? races,
            ) =>
                (workouts, races),
          ),
        )
        .listen(
          ((List<Workout>?, List<Race>?) params) => emit(CalendarState(
            workouts: params.$1,
            races: params.$2,
          )),
        );
  }

  void _disposeListener() {
    _listener?.cancel();
    _listener = null;
  }
}

class CalendarState extends Equatable {
  final List<Workout>? workouts;
  final List<Race>? races;

  const CalendarState({
    this.workouts,
    this.races,
  });

  @override
  List<Object?> get props => [
        workouts,
        races,
      ];
}
