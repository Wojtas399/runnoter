import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/domain/cubit/chart_date_range_cubit.dart';

import '../../mock/common/mock_date_service.dart';

void main() {
  final dateService = MockDateService();
  final DateTime today = DateTime(2023, 8, 24);

  setUpAll(() {
    GetIt.I.registerFactory<DateService>(() => dateService);
  });

  setUp(() {
    dateService.mockGetToday(todayDate: today);
  });

  tearDown(() {
    reset(dateService);
  });

  blocTest(
    'set week date range, '
    'should emit current week date range',
    build: () => ChartDateRangeCubit(),
    setUp: () {
      dateService.mockGetFirstDayOfTheWeek(date: DateTime(2023, 8, 21));
      dateService.mockGetLastDayOfTheWeek(date: DateTime(2023, 8, 27));
    },
    act: (cubit) => cubit.setWeekDateRange(),
    expect: () => [
      ChartDateRangeWeek(
        firstDateOfTheWeek: DateTime(2023, 8, 21),
        lastDateOfTheWeek: DateTime(2023, 8, 27),
      ),
    ],
  );

  blocTest(
    'set month date range, '
    'should set current month',
    build: () => ChartDateRangeCubit(),
    act: (cubit) => cubit.setMonthDateRange(),
    expect: () => [
      ChartDateRangeMonth(month: today.month, year: today.year),
    ],
  );

  blocTest(
    'set year date range, '
    'should set current year',
    build: () => ChartDateRangeCubit(),
    act: (cubit) => cubit.setYearDateRange(),
    expect: () => [
      ChartDateRangeYear(year: today.year),
    ],
  );

  blocTest(
    'next date range, '
    'current date range is null, '
    'should do nothing',
    build: () => ChartDateRangeCubit(),
    act: (cubit) => cubit.nextDateRange(),
    expect: () => [],
  );

  blocTest(
    'next date range, '
    'week, '
    'should set next week date range',
    build: () => ChartDateRangeCubit(
      initialDateRange: ChartDateRangeWeek(
        firstDateOfTheWeek: DateTime(2023, 8, 21),
        lastDateOfTheWeek: DateTime(2023, 8, 27),
      ),
    ),
    act: (cubit) => cubit.nextDateRange(),
    expect: () => [
      ChartDateRangeWeek(
        firstDateOfTheWeek: DateTime(2023, 8, 28),
        lastDateOfTheWeek: DateTime(2023, 9, 3),
      ),
    ],
  );

  blocTest(
    'next date range, '
    'month, '
    'should set next month',
    build: () => ChartDateRangeCubit(
      initialDateRange: const ChartDateRangeMonth(month: 12, year: 2023),
    ),
    act: (cubit) => cubit.nextDateRange(),
    expect: () => [
      const ChartDateRangeMonth(month: 1, year: 2024),
    ],
  );

  blocTest(
    'next date range, '
    'year, '
    'should set next year',
    build: () => ChartDateRangeCubit(
      initialDateRange: const ChartDateRangeYear(year: 2023),
    ),
    act: (cubit) => cubit.nextDateRange(),
    expect: () => [
      const ChartDateRangeYear(year: 2024),
    ],
  );

  blocTest(
    'previous date range, '
    'current date range is null, '
    'should do nothing',
    build: () => ChartDateRangeCubit(),
    act: (cubit) => cubit.previousDateRange(),
    expect: () => [],
  );

  blocTest(
    'previous date range, '
    'week, '
    'should set previous week date range',
    build: () => ChartDateRangeCubit(
      initialDateRange: ChartDateRangeWeek(
        firstDateOfTheWeek: DateTime(2023, 8, 21),
        lastDateOfTheWeek: DateTime(2023, 8, 27),
      ),
    ),
    act: (cubit) => cubit.previousDateRange(),
    expect: () => [
      ChartDateRangeWeek(
        firstDateOfTheWeek: DateTime(2023, 8, 14),
        lastDateOfTheWeek: DateTime(2023, 8, 20),
      ),
    ],
  );

  blocTest(
    'previous date range, '
    'month, '
    'should set previous month',
    build: () => ChartDateRangeCubit(
      initialDateRange: const ChartDateRangeMonth(month: 1, year: 2023),
    ),
    act: (cubit) => cubit.previousDateRange(),
    expect: () => [
      const ChartDateRangeMonth(month: 12, year: 2022),
    ],
  );

  blocTest(
    'previous date range, '
    'year, '
    'should set previous year',
    build: () => ChartDateRangeCubit(
      initialDateRange: const ChartDateRangeYear(year: 2023),
    ),
    act: (cubit) => cubit.previousDateRange(),
    expect: () => [
      const ChartDateRangeYear(year: 2022),
    ],
  );
}
