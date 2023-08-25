import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/health_measurement.dart';
import '../../../../domain/repository/health_measurement_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../cubit/chart_date_range_cubit.dart';

part 'health_event.dart';
part 'health_state.dart';

class HealthBloc
    extends BlocWithStatus<HealthEvent, HealthState, HealthBlocInfo, dynamic> {
  final DateService _dateService;
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final ChartDateRangeCubit _chartDateRangeCubit;
  StreamSubscription<ChartDateRangeState>? _chartDateRangeListener;

  HealthBloc({
    HealthState state = const HealthState(
      status: BlocStatusInitial(),
    ),
  })  : _dateService = getIt<DateService>(),
        _authService = getIt<AuthService>(),
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _chartDateRangeCubit = getIt<ChartDateRangeCubit>(),
        super(state) {
    on<HealthEventInitializeTodayMeasurementListener>(
      _initializeTodayMeasurementListener,
      transformer: restartable(),
    );
    on<HealthEventChartDateRangeUpdated>(
      _chartDateRangeUpdated,
      transformer: restartable(),
    );
    on<HealthEventInitializeChartDateRangeListener>(
      _initializeChartDateRangeListener,
      transformer: restartable(),
    );
    on<HealthEventDeleteTodayMeasurement>(_deleteTodayMeasurement);
    on<HealthEventChangeChartDateRangeType>(_changeChartDateRangeType);
    on<HealthEventPreviousChartDateRange>(_previousChartDateRange);
    on<HealthEventNextChartDateRange>(_nextChartDateRange);
  }

  @override
  Future<void> close() {
    _disposeChartDateRangeListener();
    return super.close();
  }

  Future<void> _initializeTodayMeasurementListener(
    HealthEventInitializeTodayMeasurementListener event,
    Emitter<HealthState> emit,
  ) async {
    final Stream<HealthMeasurement?> measurement$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (userId) => _healthMeasurementRepository.getMeasurementByDate(
                date: _dateService.getToday(),
                userId: userId,
              ),
            );
    await emit.forEach(
      measurement$,
      onData: (HealthMeasurement? measurement) => state.copyWith(
        todayMeasurement: measurement,
        removedTodayMeasurement: measurement == null,
      ),
    );
  }

  void _initializeChartDateRangeListener(
    HealthEventInitializeChartDateRangeListener event,
    Emitter<HealthState> emit,
  ) {
    _disposeChartDateRangeListener();
    _chartDateRangeListener ??= _chartDateRangeCubit.stream.listen(
      (ChartDateRangeState chartDateRange) => add(
        HealthEventChartDateRangeUpdated(chartDateRange: chartDateRange),
      ),
    );
    _chartDateRangeCubit.initializeNewDateRangeType(DateRangeType.week);
  }

  Future<void> _chartDateRangeUpdated(
    HealthEventChartDateRangeUpdated event,
    Emitter<HealthState> emit,
  ) async {
    final DateRange? dateRange = event.chartDateRange.dateRange;
    if (dateRange == null) return;
    final Stream<List<HealthMeasurement>> stream$ = _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (userId) => _healthMeasurementRepository.getMeasurementsByDateRange(
            startDate: dateRange.startDate,
            endDate: dateRange.endDate,
            userId: userId,
          ),
        )
        .map((List<HealthMeasurement>? measurements) => [...?measurements]);
    await emit.forEach(
      stream$,
      onData: (List<HealthMeasurement> measurements) {
        final points = event.chartDateRange.dateRangeType == DateRangeType.year
            ? _createPointsForEachMonth(dateRange.startDate.year, measurements)
            : _createPointsForEachDay(dateRange, measurements);
        return state.copyWith(
          dateRangeType: event.chartDateRange.dateRangeType,
          dateRange: dateRange,
          restingHeartRatePoints: points.restingHeartRatePoints,
          fastingWeightPoints: points.fastingWeightPoints,
        );
      },
    );
  }

  Future<void> _deleteTodayMeasurement(
    HealthEventDeleteTodayMeasurement event,
    Emitter<HealthState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    emitLoadingStatus(emit);
    await _healthMeasurementRepository.deleteMeasurement(
      userId: loggedUserId,
      date: _dateService.getToday(),
    );
    emitCompleteStatus(emit, info: HealthBlocInfo.healthMeasurementDeleted);
  }

  void _changeChartDateRangeType(
    HealthEventChangeChartDateRangeType event,
    Emitter<HealthState> emit,
  ) {
    _chartDateRangeCubit.initializeNewDateRangeType(event.dateRangeType);
  }

  void _previousChartDateRange(
    HealthEventPreviousChartDateRange event,
    Emitter<HealthState> emit,
  ) {
    _chartDateRangeCubit.previousDateRange();
  }

  void _nextChartDateRange(
    HealthEventNextChartDateRange event,
    Emitter<HealthState> emit,
  ) {
    _chartDateRangeCubit.nextDateRange();
  }

  _ListenedPointsOfCharts _createPointsForEachDay(
    DateRange dateRange,
    List<HealthMeasurement> measurements,
  ) {
    DateTime counterDate = dateRange.startDate;
    final dayAfterEndDay = dateRange.endDate.add(const Duration(days: 1));
    final pointsOfCharts = _ListenedPointsOfCharts();
    while (!_dateService.areDatesTheSame(counterDate, dayAfterEndDay)) {
      final HealthMeasurement? foundMeasurement = measurements.firstWhereOrNull(
        (mes) => _dateService.areDatesTheSame(mes.date, counterDate),
      );
      pointsOfCharts.restingHeartRatePoints.add(HealthChartPoint(
        date: counterDate,
        value: foundMeasurement?.restingHeartRate,
      ));
      pointsOfCharts.fastingWeightPoints.add(HealthChartPoint(
        date: counterDate,
        value: foundMeasurement?.fastingWeight,
      ));
      counterDate = counterDate.add(const Duration(days: 1));
    }
    return pointsOfCharts;
  }

  _ListenedPointsOfCharts _createPointsForEachMonth(
    final int year,
    final List<HealthMeasurement> measurements,
  ) {
    DateTime counterDate = _dateService.getFirstDayOfTheYear(year);
    final pointsOfCharts = _ListenedPointsOfCharts();
    while (counterDate.year == year) {
      final measurementsFromMonth = measurements.where(
        (measurement) => measurement.date.month == counterDate.month,
      );
      double? avgRestingHeartRate, avgFastingWeight;
      if (measurementsFromMonth.isNotEmpty) {
        avgRestingHeartRate = measurementsFromMonth
            .map((measurement) => measurement.restingHeartRate)
            .average;
        avgFastingWeight = measurementsFromMonth
            .map((measurement) => measurement.fastingWeight)
            .average;
      }
      pointsOfCharts.restingHeartRatePoints.add(
        HealthChartPoint(date: counterDate, value: avgRestingHeartRate),
      );
      pointsOfCharts.fastingWeightPoints.add(
        HealthChartPoint(date: counterDate, value: avgFastingWeight),
      );
      counterDate = DateTime(counterDate.year, counterDate.month + 1);
    }
    return pointsOfCharts;
  }

  void _disposeChartDateRangeListener() {
    _chartDateRangeListener?.cancel();
    _chartDateRangeListener = null;
  }
}

enum HealthBlocInfo { healthMeasurementAdded, healthMeasurementDeleted }

class _ListenedPointsOfCharts extends Equatable {
  final List<HealthChartPoint> restingHeartRatePoints = [];
  final List<HealthChartPoint> fastingWeightPoints = [];

  @override
  List<Object?> get props => [restingHeartRatePoints, fastingWeightPoints];
}
