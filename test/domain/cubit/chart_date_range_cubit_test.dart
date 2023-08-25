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
    'initialize new date range type, '
    'week, '
    'should emit date range of current week',
    build: () => ChartDateRangeCubit(),
    setUp: () {
      dateService.mockGetFirstDayOfTheWeek(date: DateTime(2023, 8, 21));
      dateService.mockGetLastDayOfTheWeek(date: DateTime(2023, 8, 27));
    },
    act: (cubit) => cubit.initializeNewDateRangeType(DateRangeType.week),
    expect: () => [
      ChartDateRangeState(
        dateRangeType: DateRangeType.week,
        dateRange: DateRange(
          startDate: DateTime(2023, 8, 21),
          endDate: DateTime(2023, 8, 27),
        ),
      ),
    ],
  );

  blocTest(
    'initialize new date range type, '
    'month, '
    'should emit date range of current month',
    build: () => ChartDateRangeCubit(),
    setUp: () {
      dateService.mockGetFirstDayOfTheMonth(date: DateTime(2023, 8));
      dateService.mockGetLastDayOfTheMonth(date: DateTime(2023, 8, 31));
    },
    act: (cubit) => cubit.initializeNewDateRangeType(DateRangeType.month),
    expect: () => [
      ChartDateRangeState(
        dateRangeType: DateRangeType.month,
        dateRange: DateRange(
          startDate: DateTime(2023, 8),
          endDate: DateTime(2023, 8, 31),
        ),
      ),
    ],
  );

  blocTest(
    'initialize new date range type, '
    'year, '
    'should emit date range of current year',
    build: () => ChartDateRangeCubit(),
    setUp: () {
      dateService.mockGetFirstDayOfTheYear(date: DateTime(2023));
      dateService.mockGetLastDayOfTheYear(date: DateTime(2023, 12, 31));
    },
    act: (cubit) => cubit.initializeNewDateRangeType(DateRangeType.year),
    expect: () => [
      ChartDateRangeState(
        dateRangeType: DateRangeType.year,
        dateRange: DateRange(
          startDate: DateTime(2023),
          endDate: DateTime(2023, 12, 31),
        ),
      ),
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
    'should emit date range of next week',
    build: () => ChartDateRangeCubit(
      initialState: ChartDateRangeState(
        dateRangeType: DateRangeType.week,
        dateRange: DateRange(
          startDate: DateTime(2023, 8, 21),
          endDate: DateTime(2023, 8, 27),
        ),
      ),
    ),
    act: (cubit) => cubit.nextDateRange(),
    expect: () => [
      ChartDateRangeState(
        dateRangeType: DateRangeType.week,
        dateRange: DateRange(
          startDate: DateTime(2023, 8, 28),
          endDate: DateTime(2023, 9, 3),
        ),
      ),
    ],
  );

  blocTest(
    'next date range, '
    'month, '
    'should emit date range of next month',
    build: () => ChartDateRangeCubit(
      initialState: ChartDateRangeState(
        dateRangeType: DateRangeType.month,
        dateRange: DateRange(
          startDate: DateTime(2023, 8),
          endDate: DateTime(2023, 8, 31),
        ),
      ),
    ),
    setUp: () => dateService.mockGetLastDayOfTheMonth(
      date: DateTime(2023, 9, 30),
    ),
    act: (cubit) => cubit.nextDateRange(),
    expect: () => [
      ChartDateRangeState(
        dateRangeType: DateRangeType.month,
        dateRange: DateRange(
          startDate: DateTime(2023, 9),
          endDate: DateTime(2023, 9, 30),
        ),
      ),
    ],
  );

  blocTest(
    'next date range, '
    'year, '
    'should emit date range of next year',
    build: () => ChartDateRangeCubit(
      initialState: ChartDateRangeState(
        dateRangeType: DateRangeType.year,
        dateRange: DateRange(
          startDate: DateTime(2023),
          endDate: DateTime(2023, 12, 31),
        ),
      ),
    ),
    setUp: () {
      dateService.mockGetFirstDayOfTheYear(date: DateTime(2024));
      dateService.mockGetLastDayOfTheYear(date: DateTime(2024, 12, 31));
    },
    act: (cubit) => cubit.nextDateRange(),
    expect: () => [
      ChartDateRangeState(
        dateRangeType: DateRangeType.year,
        dateRange: DateRange(
          startDate: DateTime(2024),
          endDate: DateTime(2024, 12, 31),
        ),
      ),
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
    'should emit date range of previous week',
    build: () => ChartDateRangeCubit(
      initialState: ChartDateRangeState(
        dateRangeType: DateRangeType.week,
        dateRange: DateRange(
          startDate: DateTime(2023, 8, 21),
          endDate: DateTime(2023, 8, 27),
        ),
      ),
    ),
    act: (cubit) => cubit.previousDateRange(),
    expect: () => [
      ChartDateRangeState(
        dateRangeType: DateRangeType.week,
        dateRange: DateRange(
          startDate: DateTime(2023, 8, 14),
          endDate: DateTime(2023, 8, 20),
        ),
      ),
    ],
  );

  blocTest(
    'previous date range, '
    'month, '
    'should emit date range of previous month',
    build: () => ChartDateRangeCubit(
      initialState: ChartDateRangeState(
        dateRangeType: DateRangeType.month,
        dateRange: DateRange(
          startDate: DateTime(2023, 8),
          endDate: DateTime(2023, 8, 31),
        ),
      ),
    ),
    setUp: () => dateService.mockGetLastDayOfTheMonth(
      date: DateTime(2023, 7, 31),
    ),
    act: (cubit) => cubit.previousDateRange(),
    expect: () => [
      ChartDateRangeState(
        dateRangeType: DateRangeType.month,
        dateRange: DateRange(
          startDate: DateTime(2023, 7),
          endDate: DateTime(2023, 7, 31),
        ),
      ),
    ],
  );

  blocTest(
    'previous date range, '
    'year, '
    'should emit date range of previous year',
    build: () => ChartDateRangeCubit(
      initialState: ChartDateRangeState(
        dateRangeType: DateRangeType.year,
        dateRange: DateRange(
          startDate: DateTime(2023),
          endDate: DateTime(2023, 12, 31),
        ),
      ),
    ),
    setUp: () {
      dateService.mockGetFirstDayOfTheYear(date: DateTime(2022));
      dateService.mockGetLastDayOfTheYear(date: DateTime(2022, 12, 31));
    },
    act: (cubit) => cubit.previousDateRange(),
    expect: () => [
      ChartDateRangeState(
        dateRangeType: DateRangeType.year,
        dateRange: DateRange(
          startDate: DateTime(2022),
          endDate: DateTime(2022, 12, 31),
        ),
      ),
    ],
  );
}
