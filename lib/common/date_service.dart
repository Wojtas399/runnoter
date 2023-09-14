class DateService {
  DateTime getToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime getYesterday() => getToday().subtract(const Duration(days: 1));

  DateTime getNow() => DateTime.now();

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

  DateTime getFirstDayOfTheYear(int year) => DateTime(year);

  DateTime getLastDayOfTheYear(int year) => DateTime(year, 12, 31);

  bool isDateFromRange({
    required DateTime date,
    required DateTime startDate,
    required DateTime endDate,
  }) =>
      areDaysTheSame(date, startDate) ||
      areDaysTheSame(date, endDate) ||
      (date.isAfter(startDate) && date.isBefore(endDate));

  bool isToday(DateTime date) {
    final DateTime today = getToday();
    return areDaysTheSame(date, today);
  }

  bool areDaysTheSame(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  DateTime _getDate(DateTime d) => DateTime(d.year, d.month, d.day);
}
