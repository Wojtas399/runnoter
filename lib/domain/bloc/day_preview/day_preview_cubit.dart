import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/date_service.dart';
import '../../../dependency_injection.dart';
import '../../entity/race.dart';
import '../../entity/workout.dart';
import '../../repository/race_repository.dart';
import '../../repository/workout_repository.dart';
import '../../service/auth_service.dart';

class DayPreviewCubit extends Cubit<DayPreviewState> {
  final DateTime date;
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final DateService _dateService;
  StreamSubscription? _listener;

  DayPreviewCubit({
    required this.date,
    required RaceRepository raceRepository,
    required DateService dateService,
    DayPreviewState state = const DayPreviewState(),
  })  : _authService = getIt<AuthService>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = raceRepository,
        _dateService = dateService,
        super(state);

  @override
  Future<void> close() {
    _listener?.cancel();
    _listener = null;
    return super.close();
  }

  bool get isPastDate => date.isBefore(_dateService.getToday());

  bool get areThereActivities =>
      (state.workouts != null && state.workouts!.isNotEmpty) ||
      (state.races != null && state.races!.isNotEmpty);

  void initialize() {
    _listener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => Rx.combineLatest2(
            _workoutRepository.getWorkoutsByDate(
              date: date,
              userId: loggedUserId,
            ),
            _raceRepository.getRacesByDate(
              date: date,
              userId: loggedUserId,
            ),
            (
              List<Workout>? workouts,
              List<Race>? races,
            ) =>
                (workouts, races),
          ),
        )
        .listen(
          ((List<Workout>?, List<Race>?) params) => emit(
            DayPreviewState(
              workouts: params.$1,
              races: params.$2,
            ),
          ),
        );
  }
}

class DayPreviewState extends Equatable {
  final List<Workout>? workouts;
  final List<Race>? races;

  const DayPreviewState({
    this.workouts,
    this.races,
  });

  @override
  List<Object?> get props => [
        workouts,
        races,
      ];
}
