class DateService {
  DateTime getTodayDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime getFirstDateFromWeekMatchingToDate(DateTime date) {
    final int daysToFirstDayOfTheWeek = date.weekday - 1;
    return _getDate(date.subtract(
      Duration(days: daysToFirstDayOfTheWeek),
    ));
  }

  DateTime getLastDateFromWeekMatchingToDate(DateTime date) {
    final int daysToLastDayOfTheWeek = 7 - date.weekday;
    return _getDate(date.add(
      Duration(days: daysToLastDayOfTheWeek),
    ));
  }

  DateTime getFirstDateOfTheMonth(int month, int year) => DateTime(year, month);

  DateTime getLastDateOfTheMonth(int month, int year) {
    final DateTime nextMonth = DateTime(year, month + 1);
    return nextMonth.subtract(
      const Duration(days: 1),
    );
  }

  List<DateTime> getDatesFromWeekMatchingToDate(DateTime date) {
    final DateTime firstDateOfTheWeek =
        getFirstDateFromWeekMatchingToDate(date);
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
  }) {
    final DateTime correctedStartDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final DateTime correctedEndDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
    );
    return date.isAfter(correctedStartDate) && date.isBefore(correctedEndDate);
  }

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
