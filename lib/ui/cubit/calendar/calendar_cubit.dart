import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/date_service.dart';
import '../../../../../data/entity/health_measurement.dart';
import '../../../../../data/entity/race.dart';
import '../../../../../data/entity/workout.dart';
import '../../../../../dependency_injection.dart';
import '../calendar_user_data_cubit.dart';
import '../date_range_manager_cubit.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final DateRangeManagerCubit _dateRangeManager;
  final DateService _dateService;
  CalendarUserData? _calendarUserData;
  StreamSubscription<DateRangeManagerState>? _dateRangeListener;

  CalendarCubit()
      : _dateRangeManager = getIt<DateRangeManagerCubit>(),
        _dateService = getIt<DateService>(),
        super(const CalendarState(dateRangeType: DateRangeType.week));

  @override
  Future<void> close() {
    _dateRangeListener?.cancel();
    _dateRangeListener = null;
    return super.close();
  }

  Future<void> initialize(DateRangeType dateRangeType) async {
    if (dateRangeType == DateRangeType.year) return;
    _dateRangeManager.initializeNewDateRangeType(dateRangeType);
    final DateRangeType initialDateRangeType =
        _dateRangeManager.state.dateRangeType;
    final DateRange? initialDateRange = _dateRangeManager.state.dateRange;
    emit(state.copyWith(
      dateRangeType: initialDateRangeType,
      dateRange: initialDateRange,
      weeks: initialDateRange != null
          ? _createWeeks(
              dateRangeType: initialDateRangeType,
              dateRange: initialDateRange,
            )
          : null,
    ));
    _dateRangeListener ??= _dateRangeManager.stream.listen(
      (DateRangeManagerState dateRangeManagerState) => emit(state.copyWith(
        dateRangeType: dateRangeManagerState.dateRangeType,
        dateRange: dateRangeManagerState.dateRange,
        weeks: dateRangeManagerState.dateRange != null
            ? _createWeeks(
                dateRangeType: dateRangeManagerState.dateRangeType,
                dateRange: dateRangeManagerState.dateRange!,
              )
            : null,
      )),
    );
  }

  void changeDateRangeType(DateRangeType dateRangeType) {
    _dateRangeManager.changeDateRangeType(dateRangeType);
  }

  void userDataUpdated(CalendarUserData userData) {
    _calendarUserData = userData;
    emit(state.copyWith(
      weeks: state.dateRange != null
          ? _createWeeks(
              dateRangeType: state.dateRangeType,
              dateRange: state.dateRange!,
            )
          : null,
    ));
  }

  void previousDateRange() {
    _dateRangeManager.previousDateRange();
  }

  void nextDateRange() {
    _dateRangeManager.nextDateRange();
  }

  void dayPressed(DateTime date) {
    emit(state.copyWith(pressedDay: date));
  }

  void resetPressedDay() {
    emit(state.copyWith(pressedDay: null));
  }

  List<Week> _createWeeks({
    required final DateRangeType dateRangeType,
    required final DateRange dateRange,
  }) {
    if (dateRangeType == DateRangeType.year) return [];
    List<Week> weeks = [];
    DateTime counterDate = dateRangeType == DateRangeType.week
        ? dateRange.startDate
        : _dateService.getFirstDayOfTheWeek(dateRange.startDate);
    final int numberOfWeeks = dateRangeType == DateRangeType.week ? 1 : 6;
    for (int weekNumber = 1; weekNumber <= numberOfWeeks; weekNumber++) {
      final List<WeekDay> daysFromWeek = _createDaysFromWeek(
        firstDayOfTheWeek: counterDate,
        displayingMonth: dateRange.startDate.month,
      );
      weeks.add(Week(days: daysFromWeek));
      counterDate = counterDate.add(const Duration(days: 7));
    }
    return weeks;
  }

  List<WeekDay> _createDaysFromWeek({
    required final DateTime firstDayOfTheWeek,
    required final int displayingMonth,
  }) {
    final List<WeekDay> daysFromWeek = [];
    DateTime date = firstDayOfTheWeek;
    for (int weekDayNumber = 1; weekDayNumber <= 7; weekDayNumber++) {
      final WeekDay newWeekDay = _createDay(
        date: date,
        isDisabled: date.month != displayingMonth,
      );
      daysFromWeek.add(newWeekDay);
      date = date.add(const Duration(days: 1));
    }
    return daysFromWeek;
  }

  WeekDay _createDay({
    required final DateTime date,
    required final bool isDisabled,
  }) {
    final HealthMeasurement? healthMeasurement =
        _calendarUserData?.healthMeasurements.firstWhereOrNull(
      (measurement) => _dateService.areDaysTheSame(measurement.date, date),
    );
    final List<Workout> workoutsFromDay = [
      ...?_calendarUserData?.workouts
          .where((workout) => _dateService.areDaysTheSame(workout.date, date))
          .toList(),
    ];
    final List<Race> racesFromDay = [
      ...?_calendarUserData?.races
          .where((race) => _dateService.areDaysTheSame(race.date, date))
          .toList(),
    ];
    return WeekDay(
      date: date,
      isDisabled: isDisabled,
      isTodayDay: _dateService.isToday(date),
      healthMeasurement: healthMeasurement,
      workouts: workoutsFromDay,
      races: racesFromDay,
    );
  }
}

class WeekDay extends Equatable {
  final DateTime date;
  final bool isDisabled;
  final bool isTodayDay;
  final HealthMeasurement? healthMeasurement;
  final List<Workout> workouts;
  final List<Race> races;

  const WeekDay({
    required this.date,
    this.isDisabled = false,
    this.isTodayDay = false,
    this.healthMeasurement,
    this.workouts = const [],
    this.races = const [],
  });

  @override
  List<Object?> get props => [
        date,
        isDisabled,
        isTodayDay,
        healthMeasurement,
        workouts,
        races,
      ];
}
