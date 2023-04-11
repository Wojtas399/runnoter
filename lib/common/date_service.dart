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

  DateTime _getDate(DateTime d) => DateTime(d.year, d.month, d.day);
}
