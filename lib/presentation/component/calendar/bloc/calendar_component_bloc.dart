import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/date_service.dart';
import '../../../../dependency_injection.dart';
import '../../../../domain/additional_model/calendar_user_data.dart';
import '../../../../domain/additional_model/calendar_week_day.dart';
import '../../../../domain/cubit/date_range_manager_cubit.dart';
import '../../../../domain/entity/health_measurement.dart';
import '../../../../domain/entity/race.dart';
import '../../../../domain/entity/workout.dart';

part 'calendar_component_event.dart';
part 'calendar_component_state.dart';

class CalendarComponentBloc
    extends Bloc<CalendarComponentEvent, CalendarComponentState> {
  final DateRangeManagerCubit _dateRangeManager;
  final DateService _dateService;
  CalendarUserData _dateRangeData = const CalendarUserData(
    healthMeasurements: [],
    workouts: [],
    races: [],
  );

  CalendarComponentBloc()
      : _dateRangeManager = getIt<DateRangeManagerCubit>(),
        _dateService = getIt<DateService>(),
        super(
          const CalendarComponentState(dateRangeType: DateRangeType.week),
        ) {
    on<CalendarComponentEventInitialize>(
      _initialize,
      transformer: restartable(),
    );
    on<CalendarComponentEventChangeDateRangeType>(_changeDateRangeType);
    on<CalendarComponentEventDateRangeDataUpdated>(_dateRangeDataUpdated);
    on<CalendarComponentEventPreviousDateRange>(_previousDateRange);
    on<CalendarComponentEventNextDateRange>(_nextDateRange);
    on<CalendarComponentEventDayPressed>(_dayPressed);
    on<CalendarComponentEventResetPressedDay>(_resetPressedDay);
  }

  Future<void> _initialize(
    CalendarComponentEventInitialize event,
    Emitter<CalendarComponentState> emit,
  ) async {
    if (event.dateRangeType == DateRangeType.year) return;
    _dateRangeManager.initializeNewDateRangeType(event.dateRangeType);
    final DateRangeType initialDateRangeType = _dateRangeManager.state.dateRangeType;
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
    final Stream<DateRangeManagerState> dateRange$ = _dateRangeManager.stream;
    await emit.forEach(
      dateRange$,
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
    CalendarComponentEventChangeDateRangeType event,
    Emitter<CalendarComponentState> emit,
  ) {
    _dateRangeManager.changeDateRangeType(event.dateRangeType);
  }

  void _dateRangeDataUpdated(
    CalendarComponentEventDateRangeDataUpdated event,
    Emitter<CalendarComponentState> emit,
  ) {
    _dateRangeData = event.data;
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
    CalendarComponentEventPreviousDateRange event,
    Emitter<CalendarComponentState> emit,
  ) {
    _dateRangeManager.previousDateRange();
  }

  void _nextDateRange(
    CalendarComponentEventNextDateRange event,
    Emitter<CalendarComponentState> emit,
  ) {
    _dateRangeManager.nextDateRange();
  }

  void _dayPressed(
    CalendarComponentEventDayPressed event,
    Emitter<CalendarComponentState> emit,
  ) {
    emit(state.copyWith(pressedDay: event.date));
  }

  void _resetPressedDay(
    CalendarComponentEventResetPressedDay event,
    Emitter<CalendarComponentState> emit,
  ) {
    emit(state.copyWith(pressedDay: null));
  }

  List<CalendarWeek> _createWeeks({
    required final DateRangeType dateRangeType,
    required final DateRange dateRange,
  }) {
    if (dateRangeType == DateRangeType.year) return [];
    List<CalendarWeek> weeks = [];
    DateTime counterDate = dateRangeType == DateRangeType.week
        ? dateRange.startDate
        : _dateService.getFirstDayOfTheWeek(dateRange.startDate);
    final int numberOfWeeks = dateRangeType == DateRangeType.week ? 1 : 6;
    for (int weekNumber = 1; weekNumber <= numberOfWeeks; weekNumber++) {
      final List<CalendarWeekDay> daysFromWeek = _createDaysFromWeek(
        firstDayOfTheWeek: counterDate,
        displayingMonth: dateRange.startDate.month,
      );
      weeks.add(CalendarWeek(days: daysFromWeek));
      counterDate = counterDate.add(const Duration(days: 7));
    }
    return weeks;
  }

  List<CalendarWeekDay> _createDaysFromWeek({
    required final DateTime firstDayOfTheWeek,
    required final int displayingMonth,
  }) {
    final List<CalendarWeekDay> daysFromWeek = [];
    DateTime date = firstDayOfTheWeek;
    for (int weekDayNumber = 1; weekDayNumber <= 7; weekDayNumber++) {
      final CalendarWeekDay newCalendarWeekDay = _createDay(
        date: date,
        isDisabled: date.month != displayingMonth,
      );
      daysFromWeek.add(newCalendarWeekDay);
      date = date.add(const Duration(days: 1));
    }
    return daysFromWeek;
  }

  CalendarWeekDay _createDay({
    required final DateTime date,
    required final bool isDisabled,
  }) {
    final HealthMeasurement? healthMeasurement =
        _dateRangeData.healthMeasurements.firstWhereOrNull(
      (measurement) => _dateService.areDatesTheSame(measurement.date, date),
    );
    final List<Workout> workoutsFromDay = [
      ..._dateRangeData.workouts
          .where(
            (workout) => _dateService.areDatesTheSame(workout.date, date),
          )
          .toList(),
    ];
    final List<Race> racesFromDay = [
      ..._dateRangeData.races
          .where((race) => _dateService.areDatesTheSame(race.date, date))
          .toList(),
    ];
    return CalendarWeekDay(
      date: date,
      isDisabled: isDisabled,
      isTodayDay: _dateService.isToday(date),
      healthMeasurement: healthMeasurement,
      workouts: workoutsFromDay,
      races: racesFromDay,
    );
  }
}
