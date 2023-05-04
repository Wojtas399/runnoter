import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/date_service.dart';

class CalendarCubit extends Cubit<DisplayingDate?> {
  final DateService _dateService;
  List<DateTime> _markedDates = [];

  CalendarCubit({
    required DateService dateService,
  })  : _dateService = dateService,
        super(null);

  void initialize(
    DateTime initialDate,
    List<DateTime> markedDays,
  ) {
    _markedDates = markedDays;
    emit(
      DisplayingDate(
        month: initialDate.month,
        year: initialDate.year,
      ),
    );
  }

  void previousMonth() {
    if (state == null) {
      return;
    }
    final DateTime dateOfFirstDayInPreviousMonth = DateTime(
      state!.year,
      state!.month - 1,
    );
    emit(
      DisplayingDate(
        month: dateOfFirstDayInPreviousMonth.month,
        year: dateOfFirstDayInPreviousMonth.year,
      ),
    );
  }

  void nextMonth() {
    if (state == null) {
      return;
    }
    final DateTime dateOfFirstDayInNextMonth = DateTime(
      state!.year,
      state!.month + 1,
    );
    emit(
      DisplayingDate(
        month: dateOfFirstDayInNextMonth.month,
        year: dateOfFirstDayInNextMonth.year,
      ),
    );
  }

  List<List<CalendarComponentDay>> createWeeks() {
    List<List<CalendarComponentDay>> weeks = [];
    if (state == null) {
      return weeks;
    }
    DateTime date = DateTime(state!.year, state!.month);
    date = _dateService.getFirstDateFromWeekMatchingToDate(date);
    for (int weekNumber = 1; weekNumber <= 6; weekNumber++) {
      final List<CalendarComponentDay> newWeek = _createDaysFromWeek(date);
      weeks.add(newWeek);
      date = DateTime(date.year, date.month, date.day + 7);
    }
    return weeks;
  }

  List<CalendarComponentDay> _createDaysFromWeek(
    DateTime dateOfFirstDayOfTheWeek,
  ) {
    final List<CalendarComponentDay> daysFromWeek = [];
    final DateTime todayDate = _dateService.getTodayDate();
    DateTime date = dateOfFirstDayOfTheWeek;
    for (int weekDayNumber = 1; weekDayNumber <= 7; weekDayNumber++) {
      final CalendarComponentDay newCalendarDay = CalendarComponentDay(
        date: date,
        isDisabled: date.month != state!.month,
        isTodayDay: _dateService.areDatesTheSame(date, todayDate),
        isMarked: _markedDates.contains(date),
      );
      daysFromWeek.add(newCalendarDay);
      date = date.add(
        const Duration(days: 1),
      );
    }
    return daysFromWeek;
  }
}

class DisplayingDate {
  final int month;
  final int year;

  const DisplayingDate({
    required this.month,
    required this.year,
  });
}

class CalendarComponentDay {
  final DateTime date;
  final bool isDisabled;
  final bool isTodayDay;
  final bool isMarked;

  const CalendarComponentDay({
    required this.date,
    required this.isDisabled,
    required this.isTodayDay,
    this.isMarked = false,
  });
}
