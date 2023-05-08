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
          ),
        ) {
    on<CalendarEventWorkoutsUpdated>(_workoutsUpdated);
    on<CalendarEventMonthChanged>(_monthChanged);
  }

  @override
  Future<void> close() {
    _disposeWorkoutsListener();
    return super.close();
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
    _disposeWorkoutsListener();
    _setWorkoutsListener(event.firstDisplayingDate, event.lastDisplayingDate);
  }

  void _setWorkoutsListener(DateTime startDate, DateTime endDate) {
    _workoutsListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String loggedUserId) => _workoutRepository.getWorkoutsByDateRange(
            startDate: startDate,
            endDate: endDate,
            userId: loggedUserId,
          ),
        )
        .listen(
      (List<Workout>? workouts) {
        add(
          CalendarEventWorkoutsUpdated(workouts: workouts),
        );
      },
    );
  }

  void _disposeWorkoutsListener() {
    _workoutsListener?.cancel();
    _workoutsListener = null;
  }
}
