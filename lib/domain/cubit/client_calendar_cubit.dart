import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../dependency_injection.dart';
import '../entity/race.dart';
import '../entity/workout.dart';
import '../repository/race_repository.dart';
import '../repository/workout_repository.dart';

class ClientCalendarCubit extends Cubit<ClientCalendarState> {
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final String _clientId;
  StreamSubscription<(List<Workout>?, List<Race>?)>? _activitiesListener;

  ClientCalendarCubit({
    required String clientId,
    ClientCalendarState state = const ClientCalendarState(),
  })  : _clientId = clientId,
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        super(state);

  @override
  Future<void> close() {
    _disposeActivitiesListener();
    return super.close();
  }

  void dateRangeChanged({
    required final DateTime startDay,
    required final DateTime endDay,
  }) {
    _disposeActivitiesListener();
    _setWorkoutsAndRacesListener(startDay, endDay);
  }

  void _setWorkoutsAndRacesListener(DateTime startDate, DateTime endDate) {
    _activitiesListener ??= Rx.combineLatest2(
      _workoutRepository.getWorkoutsByDateRange(
        startDate: startDate,
        endDate: endDate,
        userId: _clientId,
      ),
      _raceRepository.getRacesByDateRange(
        userId: _clientId,
        startDate: startDate,
        endDate: endDate,
      ),
      (List<Workout>? workouts, List<Race>? races) => (workouts, races),
    ).listen(
      ((List<Workout>?, List<Race>?) params) => emit(ClientCalendarState(
        workouts: params.$1,
        races: params.$2,
      )),
    );
  }

  void _disposeActivitiesListener() {
    _activitiesListener?.cancel();
    _activitiesListener = null;
  }
}

class ClientCalendarState extends Equatable {
  final List<Workout>? workouts;
  final List<Race>? races;

  const ClientCalendarState({this.workouts, this.races});

  @override
  List<Object?> get props => [workouts, races];
}
