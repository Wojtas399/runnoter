import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/date_service.dart';
import '../../dependency_injection.dart';
import '../additional_model/activities.dart';
import '../entity/race.dart';
import '../entity/workout.dart';
import '../repository/race_repository.dart';
import '../repository/workout_repository.dart';

class DayPreviewCubit extends Cubit<Activities> {
  final String _userId;
  final DateTime date;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final DateService _dateService;
  StreamSubscription? _listener;

  DayPreviewCubit({
    required String userId,
    required this.date,
    Activities activities = const Activities(),
  })  : _userId = userId,
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        _dateService = getIt<DateService>(),
        super(activities);

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
    _listener ??= Rx.combineLatest2(
      _workoutRepository.getWorkoutsByDate(date: date, userId: _userId),
      _raceRepository.getRacesByDate(date: date, userId: _userId),
      (List<Workout>? workouts, List<Race>? races) => (workouts, races),
    ).listen(
      ((List<Workout>?, List<Race>?) activities) => emit(
        Activities(workouts: activities.$1, races: activities.$2),
      ),
    );
  }
}
