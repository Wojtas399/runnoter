import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/date_service.dart';
import '../../../domain/model/workout.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';

class CurrentWeekCubit extends Cubit<List<Day>?> {
  final DateService _dateService;
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  StreamSubscription<List<Workout>?>? _workoutsListener;

  CurrentWeekCubit({
    required DateService dateService,
    required AuthService authService,
    required WorkoutRepository workoutRepository,
  })  : _dateService = dateService,
        _authService = authService,
        _workoutRepository = workoutRepository,
        super(null);

  @override
  Future<void> close() {
    _workoutsListener?.cancel();
    _workoutsListener = null;
    return super.close();
  }

  void initialize() {
    final DateTime today = _dateService.getTodayDate();
    _workoutsListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String loggedUserId) =>
              _workoutRepository.getWorkoutsByUserIdAndDateRange(
            userId: loggedUserId,
            startDate: _dateService.getFirstDateFromWeekMatchingToDate(today),
            endDate: _dateService.getLastDateFromWeekMatchingToDate(today),
          ),
        )
        .listen(_manageWorkoutsFromWeek);
  }

  void _manageWorkoutsFromWeek(List<Workout>? workouts) {
    final List<Workout?> workoutsFromWeek = [...?workouts];
    final DateTime today = _dateService.getTodayDate();
    final List<DateTime> datesFromWeek =
        _dateService.getDatesFromWeekMatchingToDate(today);
    final List<Day> days = datesFromWeek
        .map(
          (DateTime date) => Day(
            date: date,
            isToday: date == today,
            workout: workoutsFromWeek.firstWhere(
              (Workout? workout) => workout?.date == date,
              orElse: () => null,
            ),
          ),
        )
        .toList();
    emit(days);
  }
}

class Day extends Equatable {
  final DateTime date;
  final bool isToday;
  final Workout? workout;

  const Day({
    required this.date,
    required this.isToday,
    required this.workout,
  });

  @override
  List<Object?> get props => [
        date,
        isToday,
        workout,
      ];
}
