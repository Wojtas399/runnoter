import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../entity/competition.dart';
import '../../entity/workout.dart';
import '../../repository/competition_repository.dart';
import '../../repository/workout_repository.dart';
import '../../service/auth_service.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  final CompetitionRepository _competitionRepository;
  StreamSubscription? _listener;

  CalendarCubit({
    required AuthService authService,
    required WorkoutRepository workoutRepository,
    required CompetitionRepository competitionRepository,
    CalendarState state = const CalendarState(),
  })  : _authService = authService,
        _workoutRepository = workoutRepository,
        _competitionRepository = competitionRepository,
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
    _setWorkoutsAndCompetitionsListener(
      firstDisplayingDate,
      lastDisplayingDate,
    );
  }

  void _setWorkoutsAndCompetitionsListener(
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
            _competitionRepository.getCompetitionsByDateRange(
              userId: loggedUserId,
              startDate: startDate,
              endDate: endDate,
            ),
            (
              List<Workout>? workouts,
              List<Competition>? competitions,
            ) =>
                (workouts, competitions),
          ),
        )
        .listen(
          ((List<Workout>?, List<Competition>?) params) => emit(CalendarState(
            workouts: params.$1,
            competitions: params.$2,
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
  final List<Competition>? competitions;

  const CalendarState({
    this.workouts,
    this.competitions,
  });

  @override
  List<Object?> get props => [
        workouts,
        competitions,
      ];
}
