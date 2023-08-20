import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../dependency_injection.dart';
import '../additional_model/activities.dart';
import '../entity/race.dart';
import '../entity/workout.dart';
import '../repository/race_repository.dart';
import '../repository/workout_repository.dart';

class ClientCalendarCubit extends Cubit<Activities> {
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final String _clientId;
  StreamSubscription<(List<Workout>?, List<Race>?)>? _activitiesListener;

  ClientCalendarCubit({
    required String clientId,
    Activities activities = const Activities(),
  })  : _clientId = clientId,
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        super(activities);

  @override
  Future<void> close() {
    _disposeActivitiesListener();
    return super.close();
  }

  void dateRangeChanged({
    required final DateTime startDate,
    required final DateTime endDate,
  }) {
    _disposeActivitiesListener();
    _setWorkoutsAndRacesListener(startDate, endDate);
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
      ((List<Workout>?, List<Race>?) params) => emit(
        Activities(workouts: params.$1, races: params.$2),
      ),
    );
  }

  void _disposeActivitiesListener() {
    _activitiesListener?.cancel();
    _activitiesListener = null;
  }
}
