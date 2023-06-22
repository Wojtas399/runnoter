import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/date_service.dart';
import '../../entity/competition.dart';
import '../../entity/workout.dart';
import '../../repository/competition_repository.dart';
import '../../repository/workout_repository.dart';
import '../../service/auth_service.dart';

class CurrentWeekCubit extends Cubit<List<Day>?> {
  final DateService _dateService;
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  final CompetitionRepository _competitionRepository;
  StreamSubscription? _listener;

  CurrentWeekCubit({
    required DateService dateService,
    required AuthService authService,
    required WorkoutRepository workoutRepository,
    required CompetitionRepository competitionRepository,
  })  : _dateService = dateService,
        _authService = authService,
        _workoutRepository = workoutRepository,
        _competitionRepository = competitionRepository,
        super(null);

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
            _competitionRepository.getCompetitionsByDateRange(
              userId: loggedUserId,
              startDate: firstDayOfTheWeek,
              endDate: lastDayOfTheWeek,
            ),
            (
              List<Workout>? workouts,
              List<Competition>? competitions,
            ) =>
                (workouts, competitions),
          ),
        )
        .listen(_manageWorkoutsAndCompetitionsFromWeek);
  }

  void _manageWorkoutsAndCompetitionsFromWeek(
    (List<Workout>?, List<Competition>?) params,
  ) {
    final List<Workout> workoutsFromWeek = [...?params.$1];
    final List<Competition> competitionsFromWeek = [...?params.$2];
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
            competitions: competitionsFromWeek
                .where(
                  (competition) =>
                      _dateService.areDatesTheSame(competition.date, date),
                )
                .toList(),
          ),
        )
        .toList();
    emit(days);
  }
}

class Day extends Equatable {
  final DateTime date;
  final bool isToday;
  final List<Workout> workouts;
  final List<Competition> competitions;

  const Day({
    required this.date,
    required this.isToday,
    this.workouts = const [],
    this.competitions = const [],
  });

  @override
  List<Object?> get props => [
        date,
        isToday,
        workouts,
        competitions,
      ];
}
