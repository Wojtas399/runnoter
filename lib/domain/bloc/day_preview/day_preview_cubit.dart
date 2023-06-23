import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../entity/competition.dart';
import '../../entity/workout.dart';
import '../../repository/competition_repository.dart';
import '../../repository/workout_repository.dart';
import '../../service/auth_service.dart';

class DayPreviewCubit extends Cubit<DayPreviewState> {
  final DateTime date;
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  final CompetitionRepository _competitionRepository;
  StreamSubscription? _listener;

  DayPreviewCubit({
    required this.date,
    required AuthService authService,
    required WorkoutRepository workoutRepository,
    required CompetitionRepository competitionRepository,
  })  : _authService = authService,
        _workoutRepository = workoutRepository,
        _competitionRepository = competitionRepository,
        super(const DayPreviewState());

  @override
  Future<void> close() {
    _listener?.cancel();
    _listener = null;
    return super.close();
  }

  void initialize() {
    _listener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => Rx.combineLatest2(
            _workoutRepository.getWorkoutsByDate(
              date: date,
              userId: loggedUserId,
            ),
            _competitionRepository.getCompetitionsByDate(
              date: date,
              userId: loggedUserId,
            ),
            (
              List<Workout>? workouts,
              List<Competition>? competitions,
            ) =>
                (workouts, competitions),
          ),
        )
        .listen(
          ((List<Workout>?, List<Competition>?) params) => emit(
            DayPreviewState(
              workouts: params.$1,
              competitions: params.$2,
            ),
          ),
        );
  }
}

class DayPreviewState extends Equatable {
  final List<Workout>? workouts;
  final List<Competition>? competitions;

  const DayPreviewState({
    this.workouts,
    this.competitions,
  });

  @override
  List<Object?> get props => [
        workouts,
        competitions,
      ];
}
