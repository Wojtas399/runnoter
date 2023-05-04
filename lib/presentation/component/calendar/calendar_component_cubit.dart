import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/date_service.dart';

class CalendarComponentCubit extends Cubit<CalendarState> {
  final DateService _dateService;
  List<WorkoutDay> _workoutDays = [];

  CalendarComponentCubit({
    required DateService dateService,
  })  : _dateService = dateService,
        super(
          const CalendarState(
            displayingMonth: null,
            displayingYear: null,
            weeks: null,
          ),
        );

  void initialize({
    required DateTime initialDate,
    required List<WorkoutDay> workoutDays,
  }) {
    _workoutDays = workoutDays;
    emit(state.copyWith(
      displayingMonth: initialDate.month,
      displayingYear: initialDate.year,
      weeks: _createWeeks(initialDate.month, initialDate.year),
    ));
  }

  void previousMonth() {
    if (state.displayingMonth == null || state.displayingYear == null) {
      return;
    }
    final DateTime dateOfFirstDayInPreviousMonth = DateTime(
      state.displayingYear!,
      state.displayingMonth! - 1,
    );
    final int newDisplayingMonth = dateOfFirstDayInPreviousMonth.month;
    final int newDisplayingYear = dateOfFirstDayInPreviousMonth.year;
    emit(state.copyWith(
      displayingMonth: dateOfFirstDayInPreviousMonth.month,
      displayingYear: dateOfFirstDayInPreviousMonth.year,
      weeks: _createWeeks(newDisplayingMonth, newDisplayingYear),
    ));
  }

  void nextMonth() {
    if (state.displayingMonth == null || state.displayingYear == null) {
      return;
    }
    final DateTime dateOfFirstDayInNextMonth = DateTime(
      state.displayingYear!,
      state.displayingMonth! + 1,
    );
    final int newDisplayingMonth = dateOfFirstDayInNextMonth.month;
    final int newDisplayingYear = dateOfFirstDayInNextMonth.year;
    emit(state.copyWith(
      displayingMonth: newDisplayingMonth,
      displayingYear: newDisplayingYear,
      weeks: _createWeeks(newDisplayingMonth, newDisplayingYear),
    ));
  }

  List<CalendarWeek> _createWeeks(int month, int year) {
    List<CalendarWeek> weeks = [];
    DateTime date = DateTime(year, month);
    date = _dateService.getFirstDateFromWeekMatchingToDate(date);
    for (int weekNumber = 1; weekNumber <= 6; weekNumber++) {
      final List<CalendarDay> daysFromWeek = _createDaysFromWeek(date, month);
      weeks.add(
        CalendarWeek(days: daysFromWeek),
      );
      date = DateTime(date.year, date.month, date.day + 7);
    }
    return weeks;
  }

  List<CalendarDay> _createDaysFromWeek(
    DateTime dateOfFirstDayOfTheWeek,
    int month,
  ) {
    final List<CalendarDay> daysFromWeek = [];
    final DateTime todayDate = _dateService.getTodayDate();
    DateTime date = dateOfFirstDayOfTheWeek;
    for (int weekDayNumber = 1; weekDayNumber <= 7; weekDayNumber++) {
      final CalendarDay newCalendarDay = CalendarDay(
        date: date,
        isDisabled: date.month != month,
        isTodayDay: _dateService.areDatesTheSame(date, todayDate),
        icon: _getWorkoutStatusIconForDay(date),
      );
      daysFromWeek.add(newCalendarDay);
      date = date.add(
        const Duration(days: 1),
      );
    }
    return daysFromWeek;
  }

  Icon? _getWorkoutStatusIconForDay(DateTime date) {
    return <WorkoutDay?>[..._workoutDays]
        .firstWhere(
          (WorkoutDay? day) => day?.date == date,
          orElse: () => null,
        )
        ?.workoutStatusIcon;
  }
}

class CalendarState extends Equatable {
  final int? displayingMonth;
  final int? displayingYear;
  final List<CalendarWeek>? weeks;

  const CalendarState({
    required this.displayingMonth,
    required this.displayingYear,
    required this.weeks,
  });

  @override
  List<Object?> get props => [
        displayingMonth,
        displayingYear,
        weeks,
      ];

  CalendarState copyWith({
    int? displayingMonth,
    int? displayingYear,
    List<CalendarWeek>? weeks,
  }) =>
      CalendarState(
        displayingMonth: displayingMonth ?? this.displayingMonth,
        displayingYear: displayingYear ?? this.displayingYear,
        weeks: weeks ?? this.weeks,
      );
}

class WorkoutDay extends Equatable {
  final DateTime date;
  final Icon workoutStatusIcon;

  const WorkoutDay({
    required this.date,
    required this.workoutStatusIcon,
  });

  @override
  List<Object?> get props => [
        date,
        workoutStatusIcon,
      ];
}

class CalendarWeek extends Equatable {
  final List<CalendarDay> days;

  const CalendarWeek({
    required this.days,
  });

  @override
  List<Object?> get props => [
        days,
      ];
}

class CalendarDay extends Equatable {
  final DateTime date;
  final bool isDisabled;
  final bool isTodayDay;
  final Icon? icon;

  const CalendarDay({
    required this.date,
    required this.isDisabled,
    required this.isTodayDay,
    this.icon,
  });

  @override
  List<Object?> get props => [
        date,
        isDisabled,
        isTodayDay,
        icon,
      ];
}
