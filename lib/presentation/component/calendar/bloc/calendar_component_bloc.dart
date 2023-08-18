import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/date_service.dart';
import '../../../../dependency_injection.dart';

part 'calendar_component_event.dart';
part 'calendar_component_state.dart';

class CalendarComponentBloc
    extends Bloc<CalendarComponentEvent, CalendarComponentState> {
  final DateService _dateService;
  List<CalendarDayActivity> _activities = [];

  CalendarComponentBloc()
      : _dateService = getIt<DateService>(),
        super(const CalendarComponentState()) {
    on<CalendarComponentEventInitialize>(_initialize);
    on<CalendarComponentEventChangeDateRange>(_changeDateRange);
    on<CalendarComponentEventActivitiesUpdated>(_activitiesUpdated);
    on<CalendarComponentEventPreviousDateRange>(_previousDateRange);
    on<CalendarComponentEventNextDateRange>(_nextDateRange);
    on<CalendarComponentEventOnDayPressed>(_onDayPressed);
  }

  void _initialize(
    CalendarComponentEventInitialize event,
    Emitter<CalendarComponentState> emit,
  ) {
    final DateTime today = _dateService.getToday();
    DateRange? dateRange;
    switch (event.dateRangeType) {
      case DateRangeType.week:
        dateRange = DateRangeWeek(
          firstDayOfTheWeek: _dateService.getFirstDayOfTheWeek(today),
        );
        break;
      case DateRangeType.month:
        dateRange = DateRangeMonth(month: today.month, year: today.year);
        break;
    }
    emit(state.copyWith(
      dateRange: dateRange,
      weeks: _createWeeks(dateRange),
    ));
  }

  void _changeDateRange(
    CalendarComponentEventChangeDateRange event,
    Emitter<CalendarComponentState> emit,
  ) {
    final DateRange? currentDateRange = state.dateRange;
    DateRange? newDateRange;
    switch (event.dateRangeType) {
      case DateRangeType.week:
        if (currentDateRange is DateRangeMonth) {
          newDateRange = DateRangeWeek(
            firstDayOfTheWeek: _dateService.getFirstDayOfTheWeek(
              DateTime(currentDateRange.year, currentDateRange.month),
            ),
          );
        }
        break;
      case DateRangeType.month:
        if (currentDateRange is DateRangeWeek) {
          newDateRange = DateRangeMonth(
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

  void _activitiesUpdated(
    CalendarComponentEventActivitiesUpdated event,
    Emitter<CalendarComponentState> emit,
  ) {
    _activities = [...event.activities];
    emit(state.copyWith(
      weeks: state.dateRange != null ? _createWeeks(state.dateRange!) : null,
    ));
  }

  void _previousDateRange(
    CalendarComponentEventPreviousDateRange event,
    Emitter<CalendarComponentState> emit,
  ) {
    final DateRange? currentDateRange = state.dateRange;
    if (currentDateRange != null) {
      final DateRange newDateRange = switch (currentDateRange) {
        DateRangeWeek() => DateRangeWeek(
            firstDayOfTheWeek: currentDateRange.firstDayOfTheWeek.subtract(
              const Duration(days: 7),
            ),
          ),
        DateRangeMonth() => _getPreviousMonthDateRange(currentDateRange),
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
    final DateRange? currentDateRange = state.dateRange;
    if (currentDateRange != null) {
      final DateRange newDateRange = switch (currentDateRange) {
        DateRangeWeek() => DateRangeWeek(
            firstDayOfTheWeek: currentDateRange.firstDayOfTheWeek.add(
              const Duration(days: 7),
            ),
          ),
        DateRangeMonth() => _getNextMonthDateRange(currentDateRange),
      };
      emit(state.copyWith(
        dateRange: newDateRange,
        weeks: _createWeeks(newDateRange),
      ));
    }
  }

  void _onDayPressed(
    CalendarComponentEventOnDayPressed event,
    Emitter<CalendarComponentState> emit,
  ) {
    emit(state.copyWith(
      pressedDate: event.date,
    ));
  }

  List<CalendarWeek> _createWeeks(final DateRange dateRange) {
    List<CalendarWeek> weeks = [];
    DateTime date = switch (dateRange) {
      DateRangeWeek() => dateRange.firstDayOfTheWeek,
      DateRangeMonth() => _dateService.getFirstDayOfTheWeek(
          DateTime(dateRange.year, dateRange.month),
        ),
    };
    final int numberOfWeeks = switch (dateRange) {
      DateRangeWeek() => 1,
      DateRangeMonth() => 6,
    };
    for (int weekNumber = 1; weekNumber <= numberOfWeeks; weekNumber++) {
      final List<CalendarDay> daysFromWeek =
          _createDaysFromWeek(date, dateRange);
      weeks.add(
        CalendarWeek(days: daysFromWeek),
      );
      date = DateTime(date.year, date.month, date.day + 7);
    }
    return weeks;
  }

  DateRangeMonth _getPreviousMonthDateRange(
    DateRangeMonth currentMonthDateRange,
  ) {
    final DateTime firstDayOfPreviousMonth = DateTime(
      currentMonthDateRange.year,
      currentMonthDateRange.month - 1,
    );
    return DateRangeMonth(
      month: firstDayOfPreviousMonth.month,
      year: firstDayOfPreviousMonth.year,
    );
  }

  DateRangeMonth _getNextMonthDateRange(DateRangeMonth currentMonthDateRange) {
    final DateTime firstDayOfPreviousMonth = DateTime(
      currentMonthDateRange.year,
      currentMonthDateRange.month + 1,
    );
    return DateRangeMonth(
      month: firstDayOfPreviousMonth.month,
      year: firstDayOfPreviousMonth.year,
    );
  }

  List<CalendarDay> _createDaysFromWeek(
    final DateTime firstDayOfTheWeek,
    final DateRange dateRange,
  ) {
    final List<CalendarDay> daysFromWeek = [];
    final DateTime todayDate = _dateService.getToday();
    DateTime date = firstDayOfTheWeek;
    for (int weekDayNumber = 1; weekDayNumber <= 7; weekDayNumber++) {
      final CalendarDay newCalendarDay = CalendarDay(
        date: date,
        isDisabled:
            dateRange is DateRangeMonth ? date.month != dateRange.month : false,
        isTodayDay: _dateService.areDatesTheSame(date, todayDate),
        activities: [..._activities]
            .where(
              (activity) => _dateService.areDatesTheSame(activity.date, date),
            )
            .toList(),
      );
      daysFromWeek.add(newCalendarDay);
      date = date.add(
        const Duration(days: 1),
      );
    }
    return daysFromWeek;
  }
}

enum DateRangeType { week, month }
