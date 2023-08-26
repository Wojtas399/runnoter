import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/date_service.dart';
import '../../../../dependency_injection.dart';
import '../../../../domain/additional_model/calendar_date_range_data.dart';
import '../../../../domain/additional_model/calendar_week_day.dart';
import '../../../../domain/entity/health_measurement.dart';
import '../../../../domain/entity/race.dart';
import '../../../../domain/entity/workout.dart';

part 'calendar_component_event.dart';
part 'calendar_component_state.dart';

class CalendarComponentBloc
    extends Bloc<CalendarComponentEvent, CalendarComponentState> {
  final DateService _dateService;
  CalendarDateRangeData _dateRangeData = const CalendarDateRangeData(
    healthMeasurements: [],
    workouts: [],
    races: [],
  );

  CalendarComponentBloc()
      : _dateService = getIt<DateService>(),
        super(const CalendarComponentState()) {
    on<CalendarComponentEventInitialize>(_initialize);
    on<CalendarComponentEventChangeDateRangeType>(_changeDateRangeType);
    on<CalendarComponentEventDateRangeDataUpdated>(_dateRangeDataUpdated);
    on<CalendarComponentEventPreviousDateRange>(_previousDateRange);
    on<CalendarComponentEventNextDateRange>(_nextDateRange);
    on<CalendarComponentEventDayPressed>(_dayPressed);
    on<CalendarComponentEventResetPressedDay>(_resetPressedDay);
  }

  void _initialize(
    CalendarComponentEventInitialize event,
    Emitter<CalendarComponentState> emit,
  ) {
    final DateTime today = _dateService.getToday();
    CalendarDateRange? dateRange;
    switch (event.dateRangeType) {
      case CalendarDateRangeType.week:
        dateRange = CalendarDateRangeWeek(
          firstDayOfTheWeek: _dateService.getFirstDayOfTheWeek(today),
        );
        break;
      case CalendarDateRangeType.month:
        dateRange =
            CalendarDateRangeMonth(month: today.month, year: today.year);
        break;
    }
    emit(state.copyWith(
      dateRange: dateRange,
      weeks: _createWeeks(dateRange),
    ));
  }

  void _changeDateRangeType(
    CalendarComponentEventChangeDateRangeType event,
    Emitter<CalendarComponentState> emit,
  ) {
    final CalendarDateRange? currentDateRange = state.dateRange;
    CalendarDateRange? newDateRange;
    switch (event.dateRangeType) {
      case CalendarDateRangeType.week:
        if (currentDateRange is CalendarDateRangeMonth) {
          newDateRange = CalendarDateRangeWeek(
            firstDayOfTheWeek: _dateService.getFirstDayOfTheWeek(
              DateTime(currentDateRange.year, currentDateRange.month),
            ),
          );
        }
        break;
      case CalendarDateRangeType.month:
        if (currentDateRange is CalendarDateRangeWeek) {
          newDateRange = CalendarDateRangeMonth(
            month: currentDateRange.firstDayOfTheWeek.month,
            year: currentDateRange.firstDayOfTheWeek.year,
          );
        }
        break;
    }
    emit(state.copyWith(
      dateRange: newDateRange,
      weeks: newDateRange != null ? _createWeeks(newDateRange) : null,
    ));
  }

  void _dateRangeDataUpdated(
    CalendarComponentEventDateRangeDataUpdated event,
    Emitter<CalendarComponentState> emit,
  ) {
    _dateRangeData = event.data;
    emit(state.copyWith(
      weeks: state.dateRange != null ? _createWeeks(state.dateRange!) : null,
    ));
  }

  void _previousDateRange(
    CalendarComponentEventPreviousDateRange event,
    Emitter<CalendarComponentState> emit,
  ) {
    final CalendarDateRange? currentDateRange = state.dateRange;
    if (currentDateRange != null) {
      final CalendarDateRange newDateRange = switch (currentDateRange) {
        CalendarDateRangeWeek() => CalendarDateRangeWeek(
            firstDayOfTheWeek: currentDateRange.firstDayOfTheWeek.subtract(
              const Duration(days: 7),
            ),
          ),
        CalendarDateRangeMonth() =>
          _getPreviousMonthDateRange(currentDateRange),
      };
      emit(state.copyWith(
        dateRange: newDateRange,
        weeks: _createWeeks(newDateRange),
      ));
    }
  }

  void _nextDateRange(
    CalendarComponentEventNextDateRange event,
    Emitter<CalendarComponentState> emit,
  ) {
    final CalendarDateRange? currentDateRange = state.dateRange;
    if (currentDateRange != null) {
      final CalendarDateRange newDateRange = switch (currentDateRange) {
        CalendarDateRangeWeek() => CalendarDateRangeWeek(
            firstDayOfTheWeek: currentDateRange.firstDayOfTheWeek.add(
              const Duration(days: 7),
            ),
          ),
        CalendarDateRangeMonth() => _getNextMonthDateRange(currentDateRange),
      };
      emit(state.copyWith(
        dateRange: newDateRange,
        weeks: _createWeeks(newDateRange),
      ));
    }
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

  List<CalendarWeek> _createWeeks(final CalendarDateRange dateRange) {
    List<CalendarWeek> weeks = [];
    DateTime date = switch (dateRange) {
      CalendarDateRangeWeek() => dateRange.firstDayOfTheWeek,
      CalendarDateRangeMonth() => _dateService.getFirstDayOfTheWeek(
          DateTime(dateRange.year, dateRange.month),
        ),
    };
    final int numberOfWeeks = switch (dateRange) {
      CalendarDateRangeWeek() => 1,
      CalendarDateRangeMonth() => 6,
    };
    for (int weekNumber = 1; weekNumber <= numberOfWeeks; weekNumber++) {
      final List<CalendarWeekDay> daysFromWeek =
          _createDaysFromWeek(date, dateRange);
      weeks.add(
        CalendarWeek(days: daysFromWeek),
      );
      date = DateTime(date.year, date.month, date.day + 7);
    }
    return weeks;
  }

  CalendarDateRangeMonth _getPreviousMonthDateRange(
    CalendarDateRangeMonth currentMonthDateRange,
  ) {
    final DateTime firstDayOfPreviousMonth = DateTime(
      currentMonthDateRange.year,
      currentMonthDateRange.month - 1,
    );
    return CalendarDateRangeMonth(
      month: firstDayOfPreviousMonth.month,
      year: firstDayOfPreviousMonth.year,
    );
  }

  CalendarDateRangeMonth _getNextMonthDateRange(
    CalendarDateRangeMonth currentMonthDateRange,
  ) {
    final DateTime firstDayOfPreviousMonth = DateTime(
      currentMonthDateRange.year,
      currentMonthDateRange.month + 1,
    );
    return CalendarDateRangeMonth(
      month: firstDayOfPreviousMonth.month,
      year: firstDayOfPreviousMonth.year,
    );
  }

  List<CalendarWeekDay> _createDaysFromWeek(
    final DateTime firstDayOfTheWeek,
    final CalendarDateRange dateRange,
  ) {
    final List<CalendarWeekDay> daysFromWeek = [];
    final DateTime todayDate = _dateService.getToday();
    DateTime date = firstDayOfTheWeek;
    for (int weekDayNumber = 1; weekDayNumber <= 7; weekDayNumber++) {
      final CalendarWeekDay newCalendarWeekDay =
          _createDay(date, todayDate, dateRange);
      daysFromWeek.add(newCalendarWeekDay);
      date = date.add(const Duration(days: 1));
    }
    return daysFromWeek;
  }

  CalendarWeekDay _createDay(
    DateTime date,
    DateTime todayDate,
    CalendarDateRange dateRange,
  ) {
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
      isDisabled: dateRange is CalendarDateRangeMonth
          ? date.month != dateRange.month
          : false,
      isTodayDay: _dateService.areDatesTheSame(date, todayDate),
      healthMeasurement: healthMeasurement,
      workouts: workoutsFromDay,
      races: racesFromDay,
    );
  }
}

enum CalendarDateRangeType { week, month }
