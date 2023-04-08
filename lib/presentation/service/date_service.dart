class DateService {
  DateTime getNow() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  List<DateTime> getDatesFromWeekMatchingToDate(DateTime date) {
    final int daysToFirstDayOfTheWeek = date.weekday - 1;
    final DateTime firstDateOfTheWeek = _getDate(
      date.subtract(Duration(
        days: daysToFirstDayOfTheWeek,
      )),
    );
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

  DateTime _getDate(DateTime d) => DateTime(d.year, d.month, d.day);
}
