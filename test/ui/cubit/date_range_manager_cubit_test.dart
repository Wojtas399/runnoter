import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/ui/cubit/date_range_manager_cubit.dart';

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
    build: () => DateRangeManagerCubit(),
    setUp: () {
      dateService.mockGetFirstDayOfTheWeek(date: DateTime(2023, 8, 21));
      dateService.mockGetLastDayOfTheWeek(date: DateTime(2023, 8, 27));
    },
    act: (cubit) => cubit.initializeNewDateRangeType(DateRangeType.week),
    expect: () => [
      DateRangeManagerState(
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
    build: () => DateRangeManagerCubit(),
    setUp: () {
      dateService.mockGetFirstDayOfTheMonth(date: DateTime(2023, 8));
      dateService.mockGetLastDayOfTheMonth(date: DateTime(2023, 8, 31));
    },
    act: (cubit) => cubit.initializeNewDateRangeType(DateRangeType.month),
    expect: () => [
      DateRangeManagerState(
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
    build: () => DateRangeManagerCubit(),
    setUp: () {
      dateService.mockGetFirstDayOfTheYear(date: DateTime(2023));
      dateService.mockGetLastDayOfTheYear(date: DateTime(2023, 12, 31));
    },
    act: (cubit) => cubit.initializeNewDateRangeType(DateRangeType.year),
    expect: () => [
      DateRangeManagerState(
        dateRangeType: DateRangeType.year,
        dateRange: DateRange(
          startDate: DateTime(2023),
          endDate: DateTime(2023, 12, 31),
        ),
      ),
    ],
  );

  blocTest(
    'change date range type, '
    'week to month, '
    'should set date range of the month got from end date',
    build: () => DateRangeManagerCubit(
      initialState: DateRangeManagerState(
        dateRangeType: DateRangeType.week,
        dateRange: DateRange(
          startDate: DateTime(2023, 8, 28),
          endDate: DateTime(2023, 9, 3),
        ),
      ),
    ),
    setUp: () {
      dateService.mockGetFirstDayOfTheMonth(date: DateTime(2023, 9));
      dateService.mockGetLastDayOfTheMonth(date: DateTime(2023, 9, 30));
    },
    act: (cubit) => cubit.changeDateRangeType(DateRangeType.month),
    expect: () => [
      DateRangeManagerState(
        dateRangeType: DateRangeType.month,
        dateRange: DateRange(
          startDate: DateTime(2023, 9),
          endDate: DateTime(2023, 9, 30),
        ),
      ),
    ],
    verify: (_) {
      verify(() => dateService.getFirstDayOfTheMonth(9, 2023)).called(1);
      verify(() => dateService.getLastDayOfTheMonth(9, 2023)).called(1);
    },
  );

  blocTest(
    'change date range type, '
    'week to year, '
    'should set date range of the year got from end date',
    build: () => DateRangeManagerCubit(
      initialState: DateRangeManagerState(
        dateRangeType: DateRangeType.week,
        dateRange: DateRange(
          startDate: DateTime(2022, 1, 26),
          endDate: DateTime(2023, 1, 1),
        ),
      ),
    ),
    setUp: () {
      dateService.mockGetFirstDayOfTheYear(date: DateTime(2023, 1, 1));
      dateService.mockGetLastDayOfTheYear(date: DateTime(2023, 12, 31));
    },
    act: (cubit) => cubit.changeDateRangeType(DateRangeType.year),
    expect: () => [
      DateRangeManagerState(
        dateRangeType: DateRangeType.year,
        dateRange: DateRange(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 12, 31),
        ),
      ),
    ],
    verify: (_) {
      verify(() => dateService.getFirstDayOfTheYear(2023)).called(1);
      verify(() => dateService.getLastDayOfTheYear(2023)).called(1);
    },
  );

  blocTest(
    'change date range type, '
    'month to week, '
    'should set date range of the first week of the month got from start date',
    build: () => DateRangeManagerCubit(
      initialState: DateRangeManagerState(
        dateRangeType: DateRangeType.month,
        dateRange: DateRange(
          startDate: DateTime(2023, 8, 1),
          endDate: DateTime(2023, 8, 31),
        ),
      ),
    ),
    setUp: () {
      dateService.mockGetFirstDayOfTheWeek(date: DateTime(2023, 7, 31));
      dateService.mockGetLastDayOfTheWeek(date: DateTime(2023, 8, 6));
    },
    act: (cubit) => cubit.changeDateRangeType(DateRangeType.week),
    expect: () => [
      DateRangeManagerState(
        dateRangeType: DateRangeType.week,
        dateRange: DateRange(
          startDate: DateTime(2023, 7, 31),
          endDate: DateTime(2023, 8, 6),
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => dateService.getFirstDayOfTheWeek(DateTime(2023, 8, 1)),
      ).called(1);
      verify(
        () => dateService.getLastDayOfTheWeek(DateTime(2023, 8, 1)),
      ).called(1);
    },
  );

  blocTest(
    'change date range type, '
    'month to year, '
    'should set date range of the year got from start date',
    build: () => DateRangeManagerCubit(
      initialState: DateRangeManagerState(
        dateRangeType: DateRangeType.month,
        dateRange: DateRange(
          startDate: DateTime(2023, 8, 1),
          endDate: DateTime(2023, 8, 31),
        ),
      ),
    ),
    setUp: () {
      dateService.mockGetFirstDayOfTheYear(date: DateTime(2023, 1, 1));
      dateService.mockGetLastDayOfTheYear(date: DateTime(2023, 12, 31));
    },
    act: (cubit) => cubit.changeDateRangeType(DateRangeType.year),
    expect: () => [
      DateRangeManagerState(
        dateRangeType: DateRangeType.year,
        dateRange: DateRange(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 12, 31),
        ),
      ),
    ],
    verify: (_) {
      verify(() => dateService.getFirstDayOfTheYear(2023)).called(1);
      verify(() => dateService.getLastDayOfTheYear(2023)).called(1);
    },
  );

  blocTest(
    'change date range type, '
    'year to week, '
    'should set date range of the first week of the year',
    build: () => DateRangeManagerCubit(
      initialState: DateRangeManagerState(
        dateRangeType: DateRangeType.year,
        dateRange: DateRange(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 12, 31),
        ),
      ),
    ),
    setUp: () {
      dateService.mockGetFirstDayOfTheWeek(date: DateTime(2022, 12, 26));
      dateService.mockGetLastDayOfTheWeek(date: DateTime(2023, 1, 1));
    },
    act: (cubit) => cubit.changeDateRangeType(DateRangeType.week),
    expect: () => [
      DateRangeManagerState(
        dateRangeType: DateRangeType.week,
        dateRange: DateRange(
          startDate: DateTime(2022, 12, 26),
          endDate: DateTime(2023, 1, 1),
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => dateService.getFirstDayOfTheWeek(DateTime(2023, 1, 1)),
      ).called(1);
      verify(
        () => dateService.getLastDayOfTheWeek(DateTime(2023, 1, 1)),
      ).called(1);
    },
  );

  blocTest(
    'change date range type, '
    'year to month, '
    'should set date range of the first month of the year',
    build: () => DateRangeManagerCubit(
      initialState: DateRangeManagerState(
        dateRangeType: DateRangeType.year,
        dateRange: DateRange(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 12, 31),
        ),
      ),
    ),
    setUp: () {
      dateService.mockGetFirstDayOfTheMonth(date: DateTime(2023, 1, 1));
      dateService.mockGetLastDayOfTheMonth(date: DateTime(2023, 1, 31));
    },
    act: (cubit) => cubit.changeDateRangeType(DateRangeType.month),
    expect: () => [
      DateRangeManagerState(
        dateRangeType: DateRangeType.month,
        dateRange: DateRange(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 1, 31),
        ),
      ),
    ],
    verify: (_) {
      verify(() => dateService.getFirstDayOfTheMonth(1, 2023)).called(1);
      verify(() => dateService.getLastDayOfTheMonth(1, 2023)).called(1);
    },
  );

  blocTest(
    'next date range, '
    'current date range is null, '
    'should do nothing',
    build: () => DateRangeManagerCubit(),
    act: (cubit) => cubit.nextDateRange(),
    expect: () => [],
  );

  blocTest(
    'next date range, '
    'week, '
    'should emit date range of next week',
    build: () => DateRangeManagerCubit(
      initialState: DateRangeManagerState(
        dateRangeType: DateRangeType.week,
        dateRange: DateRange(
          startDate: DateTime(2023, 8, 21),
          endDate: DateTime(2023, 8, 27),
        ),
      ),
    ),
    act: (cubit) => cubit.nextDateRange(),
    expect: () => [
      DateRangeManagerState(
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
    build: () => DateRangeManagerCubit(
      initialState: DateRangeManagerState(
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
      DateRangeManagerState(
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
    build: () => DateRangeManagerCubit(
      initialState: DateRangeManagerState(
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
      DateRangeManagerState(
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
    build: () => DateRangeManagerCubit(),
    act: (cubit) => cubit.previousDateRange(),
    expect: () => [],
  );

  blocTest(
    'previous date range, '
    'week, '
    'should emit date range of previous week',
    build: () => DateRangeManagerCubit(
      initialState: DateRangeManagerState(
        dateRangeType: DateRangeType.week,
        dateRange: DateRange(
          startDate: DateTime(2023, 8, 21),
          endDate: DateTime(2023, 8, 27),
        ),
      ),
    ),
    act: (cubit) => cubit.previousDateRange(),
    expect: () => [
      DateRangeManagerState(
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
    build: () => DateRangeManagerCubit(
      initialState: DateRangeManagerState(
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
      DateRangeManagerState(
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
    build: () => DateRangeManagerCubit(
      initialState: DateRangeManagerState(
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
      DateRangeManagerState(
        dateRangeType: DateRangeType.year,
        dateRange: DateRange(
          startDate: DateTime(2022),
          endDate: DateTime(2022, 12, 31),
        ),
      ),
    ],
  );
}
