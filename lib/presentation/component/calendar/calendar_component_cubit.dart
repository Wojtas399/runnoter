import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/date_service.dart';

class CalendarComponentCubit extends Cubit<CalendarComponentState> {
  final DateService _dateService;
  List<WorkoutDay> _workoutDays = [];

  CalendarComponentCubit({
    required DateService dateService,
  })  : _dateService = dateService,
        super(
          CalendarComponentState(
            displayingMonth: dateService.getToday().month,
            displayingYear: dateService.getToday().year,
            weeks: null,
          ),
        );

  void updateState({
    DateTime? date,
    List<WorkoutDay>? workoutDays,
  }) {
    _workoutDays = workoutDays ?? _workoutDays;
    final int? month = date?.month ?? state.displayingMonth;
    final int? year = date?.year ?? state.displayingYear;
    emit(state.copyWith(
      displayingMonth: month,
      displayingYear: year,
      weeks: month != null && year != null ? _createWeeks(month, year) : null,
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
    updateState(date: dateOfFirstDayInPreviousMonth);
  }

  void nextMonth() {
    if (state.displayingMonth == null || state.displayingYear == null) {
      return;
    }
    final DateTime dateOfFirstDayInNextMonth = DateTime(
      state.displayingYear!,
      state.displayingMonth! + 1,
    );
    updateState(date: dateOfFirstDayInNextMonth);
  }

  void onDayPressed(DateTime date) {
    emit(state.copyWith(
      pressedDate: date,
    ));
  }

  List<CalendarWeek> _createWeeks(int month, int year) {
    List<CalendarWeek> weeks = [];
    DateTime date = DateTime(year, month);
    date = _dateService.getFirstDayOfTheWeek(date);
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
    final DateTime todayDate = _dateService.getToday();
    DateTime date = dateOfFirstDayOfTheWeek;
    for (int weekDayNumber = 1; weekDayNumber <= 7; weekDayNumber++) {
      final CalendarDay newCalendarDay = CalendarDay(
        date: date,
        isDisabled: date.month != month,
        isTodayDay: _dateService.areDatesTheSame(date, todayDate),
        icon: _getRunStatusIconForDay(date),
      );
      daysFromWeek.add(newCalendarDay);
      date = date.add(
        const Duration(days: 1),
      );
    }
    return daysFromWeek;
  }

  Icon? _getRunStatusIconForDay(DateTime date) {
    return <WorkoutDay?>[..._workoutDays]
        .firstWhere(
          (WorkoutDay? day) => day?.date == date,
          orElse: () => null,
        )
        ?.runStatusIcon;
  }
}

class CalendarComponentState extends Equatable {
  final int? displayingMonth;
  final int? displayingYear;
  final List<CalendarWeek>? weeks;
  final DateTime? pressedDate;

  const CalendarComponentState({
    required this.displayingMonth,
    required this.displayingYear,
    required this.weeks,
    this.pressedDate,
  });

  @override
  List<Object?> get props => [
        displayingMonth,
        displayingYear,
        weeks,
        pressedDate,
      ];

  CalendarComponentState copyWith({
    int? displayingMonth,
    int? displayingYear,
    List<CalendarWeek>? weeks,
    DateTime? pressedDate,
  }) =>
      CalendarComponentState(
        displayingMonth: displayingMonth ?? this.displayingMonth,
        displayingYear: displayingYear ?? this.displayingYear,
        weeks: weeks ?? this.weeks,
        pressedDate: pressedDate,
      );
}

class WorkoutDay extends Equatable {
  final DateTime date;
  final Icon runStatusIcon;

  const WorkoutDay({
    required this.date,
    required this.runStatusIcon,
  });

  @override
  List<Object?> get props => [
        date,
        runStatusIcon,
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
