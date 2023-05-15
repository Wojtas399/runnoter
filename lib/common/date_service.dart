class DateService {
  DateTime getToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime getFirstDayOfTheWeek(DateTime date) {
    final int daysToFirstDayOfTheWeek = date.weekday - 1;
    return _getDate(date.subtract(
      Duration(days: daysToFirstDayOfTheWeek),
    ));
  }

  DateTime getLastDayOfTheWeek(DateTime date) {
    final int daysToLastDayOfTheWeek = 7 - date.weekday;
    return _getDate(date.add(
      Duration(days: daysToLastDayOfTheWeek),
    ));
  }

  DateTime getFirstDayOfTheMonth(int month, int year) => DateTime(year, month);

  DateTime getLastDayOfTheMonth(int month, int year) {
    final DateTime nextMonth = DateTime(year, month + 1);
    return nextMonth.subtract(
      const Duration(days: 1),
    );
  }

  List<DateTime> getDaysFromWeek(DateTime date) {
    final DateTime firstDateOfTheWeek = getFirstDayOfTheWeek(date);
    final List<DateTime> datesFromWeek = [firstDateOfTheWeek];
    DateTime currentDate = firstDateOfTheWeek;
    for (int i = 0; i < 6; i++) {
      currentDate = _getDate(
        currentDate.add(
          const Duration(days: 1),
        ),
      );
      datesFromWeek.add(currentDate);
    }
    return datesFromWeek;
  }

  bool isDateFromRange({
    required DateTime date,
    required DateTime startDate,
    required DateTime endDate,
  }) =>
      areDatesTheSame(date, startDate) ||
      areDatesTheSame(date, endDate) ||
      (date.isAfter(startDate) && date.isBefore(endDate));

  bool areDatesTheSame(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isDate1BeforeDate2(DateTime date1, DateTime date2) {
    return date1.year < date2.year ||
        (date1.year == date2.year && date1.month < date2.month) ||
        (date1.year == date2.year &&
            date1.month == date2.month &&
            date1.day < date2.day);
  }

  DateTime _getDate(DateTime d) => DateTime(d.year, d.month, d.day);
}
