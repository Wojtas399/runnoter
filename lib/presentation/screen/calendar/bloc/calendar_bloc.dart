import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/model/workout.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc
    extends BlocWithStatus<CalendarEvent, CalendarState, dynamic, dynamic> {
  final DateService _dateService;
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  StreamSubscription<List<Workout>?>? _workoutsListener;

  CalendarBloc({
    required DateService dateService,
    required AuthService authService,
    required WorkoutRepository workoutRepository,
  })  : _dateService = dateService,
        _authService = authService,
        _workoutRepository = workoutRepository,
        super(
          const CalendarState(
            status: BlocStatusInitial(),
            workouts: null,
            month: null,
            year: null,
          ),
        ) {
    on<CalendarEventInitialize>(_initialize);
    on<CalendarEventWorkoutsUpdated>(_workoutsUpdated);
    on<CalendarEventMonthChanged>(_monthChanged);
  }

  @override
  Future<void> close() {
    _disposeWorkoutsListener();
    return super.close();
  }

  void _initialize(
    CalendarEventInitialize event,
    Emitter<CalendarState> emit,
  ) {
    final DateTime todayDate = _dateService.getTodayDate();
    final int month = todayDate.month;
    final int year = todayDate.year;
    emit(state.copyWith(
      month: month,
      year: year,
    ));
    _setWorkoutsListener(month, year);
  }

  void _workoutsUpdated(
    CalendarEventWorkoutsUpdated event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(
      workouts: event.workouts,
    ));
  }

  void _monthChanged(
    CalendarEventMonthChanged event,
    Emitter<CalendarState> emit,
  ) {
    final newMonth = event.month;
    final newYear = event.year;
    emit(state.copyWith(
      month: newMonth,
      year: newYear,
    ));
    _disposeWorkoutsListener();
    _setWorkoutsListener(newMonth, newYear);
  }

  void _setWorkoutsListener(int month, int year) {
    _workoutsListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String loggedUserId) => _workoutRepository.getWorkoutsByDateRange(
            startDate: _dateService.getFirstDateOfTheMonth(month, year),
            endDate: _dateService.getLastDateOfTheMonth(month, year),
            userId: loggedUserId,
          ),
        )
        .listen(
          (List<Workout>? workouts) => add(
            CalendarEventWorkoutsUpdated(workouts: workouts),
          ),
        );
  }

  void _disposeWorkoutsListener() {
    _workoutsListener?.cancel();
    _workoutsListener = null;
  }
}
