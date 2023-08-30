import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/date_service.dart';
import '../../../../dependency_injection.dart';
import '../../../../domain/additional_model/calendar_user_data.dart';
import '../../../../domain/cubit/date_range_manager_cubit.dart';
import '../../../../domain/entity/health_measurement.dart';
import '../../../../domain/entity/race.dart';
import '../../../../domain/entity/workout.dart';
import '../../additional_model/week_day.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final DateRangeManagerCubit _dateRangeManager;
  final DateService _dateService;
  CalendarUserData? _calendarUserData;

  CalendarBloc()
      : _dateRangeManager = getIt<DateRangeManagerCubit>(),
        _dateService = getIt<DateService>(),
        super(
          const CalendarState(dateRangeType: DateRangeType.week),
        ) {
    on<CalendarEventInitialize>(
      _initialize,
      transformer: restartable(),
    );
    on<CalendarEventChangeDateRangeType>(_changeDateRangeType);
    on<CalendarEventUserDataUpdated>(_userDataUpdated);
    on<CalendarEventPreviousDateRange>(_previousDateRange);
    on<CalendarEventNextDateRange>(_nextDateRange);
    on<CalendarEventDayPressed>(_dayPressed);
    on<CalendarEventResetPressedDay>(_resetPressedDay);
  }

  Future<void> _initialize(
    CalendarEventInitialize event,
    Emitter<CalendarState> emit,
  ) async {
    if (event.dateRangeType == DateRangeType.year) return;
    _dateRangeManager.initializeNewDateRangeType(event.dateRangeType);
    final DateRangeType initialDateRangeType =
        _dateRangeManager.state.dateRangeType;
    final DateRange? initialDateRange = _dateRangeManager.state.dateRange;
    emit(state.copyWith(
      dateRangeType: initialDateRangeType,
      dateRange: initialDateRange,
      weeks: initialDateRange != null
          ? _createWeeks(
              dateRangeType: initialDateRangeType,
              dateRange: initialDateRange,
            )
          : null,
    ));
    await emit.forEach(
      _dateRangeManager.stream,
      onData: (DateRangeManagerState dateRangeManagerState) => state.copyWith(
        dateRangeType: dateRangeManagerState.dateRangeType,
        dateRange: dateRangeManagerState.dateRange,
        weeks: dateRangeManagerState.dateRange != null
            ? _createWeeks(
                dateRangeType: dateRangeManagerState.dateRangeType,
                dateRange: dateRangeManagerState.dateRange!,
              )
            : null,
      ),
    );
  }

  void _changeDateRangeType(
    CalendarEventChangeDateRangeType event,
    Emitter<CalendarState> emit,
  ) {
    _dateRangeManager.changeDateRangeType(event.dateRangeType);
  }

  void _userDataUpdated(
    CalendarEventUserDataUpdated event,
    Emitter<CalendarState> emit,
  ) {
    _calendarUserData = event.userData;
    emit(state.copyWith(
      weeks: state.dateRange != null
          ? _createWeeks(
              dateRangeType: state.dateRangeType,
              dateRange: state.dateRange!,
            )
          : null,
    ));
  }

  void _previousDateRange(
    CalendarEventPreviousDateRange event,
    Emitter<CalendarState> emit,
  ) {
    _dateRangeManager.previousDateRange();
  }

  void _nextDateRange(
    CalendarEventNextDateRange event,
    Emitter<CalendarState> emit,
  ) {
    _dateRangeManager.nextDateRange();
  }

  void _dayPressed(
    CalendarEventDayPressed event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(pressedDay: event.date));
  }

  void _resetPressedDay(
    CalendarEventResetPressedDay event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(pressedDay: null));
  }

  List<Week> _createWeeks({
    required final DateRangeType dateRangeType,
    required final DateRange dateRange,
  }) {
    if (dateRangeType == DateRangeType.year) return [];
    List<Week> weeks = [];
    DateTime counterDate = dateRangeType == DateRangeType.week
        ? dateRange.startDate
        : _dateService.getFirstDayOfTheWeek(dateRange.startDate);
    final int numberOfWeeks = dateRangeType == DateRangeType.week ? 1 : 6;
    for (int weekNumber = 1; weekNumber <= numberOfWeeks; weekNumber++) {
      final List<WeekDay> daysFromWeek = _createDaysFromWeek(
        firstDayOfTheWeek: counterDate,
        displayingMonth: dateRange.startDate.month,
      );
      weeks.add(Week(days: daysFromWeek));
      counterDate = counterDate.add(const Duration(days: 7));
    }
    return weeks;
  }

  List<WeekDay> _createDaysFromWeek({
    required final DateTime firstDayOfTheWeek,
    required final int displayingMonth,
  }) {
    final List<WeekDay> daysFromWeek = [];
    DateTime date = firstDayOfTheWeek;
    for (int weekDayNumber = 1; weekDayNumber <= 7; weekDayNumber++) {
      final WeekDay newWeekDay = _createDay(
        date: date,
        isDisabled: date.month != displayingMonth,
      );
      daysFromWeek.add(newWeekDay);
      date = date.add(const Duration(days: 1));
    }
    return daysFromWeek;
  }

  WeekDay _createDay({
    required final DateTime date,
    required final bool isDisabled,
  }) {
    final HealthMeasurement? healthMeasurement =
        _calendarUserData?.healthMeasurements.firstWhereOrNull(
      (measurement) => _dateService.areDatesTheSame(measurement.date, date),
    );
    final List<Workout> workoutsFromDay = [
      ...?_calendarUserData?.workouts
          .where((workout) => _dateService.areDatesTheSame(workout.date, date))
          .toList(),
    ];
    final List<Race> racesFromDay = [
      ...?_calendarUserData?.races
          .where((race) => _dateService.areDatesTheSame(race.date, date))
          .toList(),
    ];
    return WeekDay(
      date: date,
      isDisabled: isDisabled,
      isTodayDay: _dateService.isToday(date),
      healthMeasurement: healthMeasurement,
      workouts: workoutsFromDay,
      races: racesFromDay,
    );
  }
}
