import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/date_service.dart';
import '../../../common/workout_stage_service.dart';
import '../../../dependency_injection.dart';
import '../../entity/race.dart';
import '../../entity/workout.dart';
import '../../repository/race_repository.dart';
import '../../repository/workout_repository.dart';
import '../../service/auth_service.dart';

class CurrentWeekCubit extends Cubit<List<Day>?> {
  final DateService _dateService;
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  StreamSubscription? _listener;

  CurrentWeekCubit({
    required DateService dateService,
    required WorkoutRepository workoutRepository,
    required RaceRepository raceRepository,
    List<Day>? days,
  })  : _dateService = dateService,
        _authService = getIt<AuthService>(),
        _workoutRepository = workoutRepository,
        _raceRepository = raceRepository,
        super(days);

  int? get numberOfActivities =>
      state?.map((Day day) => day.workouts.length + day.races.length).sum;

  double? get scheduledTotalDistance =>
      state?.map(_calculateScheduledTotalDayDistance).sum;

  double? get coveredTotalDistance =>
      state?.map(_calculateCoveredTotalDayDistance).sum;

  @override
  Future<void> close() {
    _listener?.cancel();
    _listener = null;
    return super.close();
  }

  void initialize() {
    final DateTime today = _dateService.getToday();
    final DateTime firstDayOfTheWeek = _dateService.getFirstDayOfTheWeek(today);
    final DateTime lastDayOfTheWeek = _dateService.getLastDayOfTheWeek(today);
    _listener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String loggedUserId) => Rx.combineLatest2(
            _workoutRepository.getWorkoutsByDateRange(
              userId: loggedUserId,
              startDate: firstDayOfTheWeek,
              endDate: lastDayOfTheWeek,
            ),
            _raceRepository.getRacesByDateRange(
              userId: loggedUserId,
              startDate: firstDayOfTheWeek,
              endDate: lastDayOfTheWeek,
            ),
            (List<Workout>? workouts, List<Race>? races) => (workouts, races),
          ),
        )
        .listen(_manageWorkoutsAndRacesFromWeek);
  }

  void _manageWorkoutsAndRacesFromWeek((List<Workout>?, List<Race>?) params) {
    final List<Workout> workoutsFromWeek = [...?params.$1];
    final List<Race> racesFromWeek = [...?params.$2];
    final DateTime today = _dateService.getToday();
    final List<DateTime> datesFromWeek = _dateService.getDaysFromWeek(today);
    final List<Day> days = datesFromWeek
        .map(
          (DateTime date) => Day(
            date: date,
            isToday: date == today,
            workouts: workoutsFromWeek
                .where(
                  (workout) => _dateService.areDatesTheSame(workout.date, date),
                )
                .toList(),
            races: racesFromWeek
                .where((race) => _dateService.areDatesTheSame(race.date, date))
                .toList(),
          ),
        )
        .toList();
    emit(days);
  }

  double _calculateScheduledTotalDayDistance(Day day) {
    final double workoutsDistance = day.workouts
        .map(
          (workout) => workout.stages.map(calculateDistanceOfWorkoutStage).sum,
        )
        .sum;
    final double racesDistance =
        day.races.map((Race race) => race.distance).sum;
    return workoutsDistance + racesDistance;
  }

  double _calculateCoveredTotalDayDistance(Day day) {
    final double workoutsCoveredDistance =
        day.workouts.map((workout) => workout.coveredDistance).sum;
    final double racesCoveredDistance =
        day.races.map((race) => race.coveredDistance).sum;
    return workoutsCoveredDistance + racesCoveredDistance;
  }
}

class Day extends Equatable {
  final DateTime date;
  final bool isToday;
  final List<Workout> workouts;
  final List<Race> races;

  const Day({
    required this.date,
    required this.isToday,
    this.workouts = const [],
    this.races = const [],
  });

  @override
  List<Object?> get props => [
        date,
        isToday,
        workouts,
        races,
      ];
}
