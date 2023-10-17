import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/date_service.dart';
import '../../../data/interface/repository/health_measurement_repository.dart';
import '../../../data/model/health_measurement.dart';
import '../../../dependency_injection.dart';
import '../../cubit/date_range_manager_cubit.dart';

part 'health_stats_state.dart';

class HealthStatsCubit extends Cubit<HealthStatsState> {
  final String _userId;
  final DateService _dateService;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final DateRangeManagerCubit _dateRangeManagerCubit;
  StreamSubscription<DateRangeManagerState>? _dateRangeManagerListener;
  StreamSubscription<List<HealthMeasurement>?>? _measurementsListener;

  HealthStatsCubit({
    required String userId,
    HealthStatsState initialState = const HealthStatsState(),
  })  : _userId = userId,
        _dateService = getIt<DateService>(),
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _dateRangeManagerCubit = getIt<DateRangeManagerCubit>(),
        super(initialState);

  @override
  Future<void> close() {
    _disposeChartDateRangeListener();
    _disposeHealthMeasurementsListener();
    return super.close();
  }

  void initialize() {
    _disposeChartDateRangeListener();
    _dateRangeManagerListener ??= _dateRangeManagerCubit.stream.listen(
      _chartDateRangeUpdated,
    );
    _dateRangeManagerCubit.initializeNewDateRangeType(DateRangeType.week);
  }

  void changeChartDateRangeType(DateRangeType dateRangeType) {
    _dateRangeManagerCubit.initializeNewDateRangeType(dateRangeType);
  }

  void previousChartDateRange() {
    _dateRangeManagerCubit.previousDateRange();
  }

  void nextChartDateRange() {
    _dateRangeManagerCubit.nextDateRange();
  }

  Future<void> refresh() async {
    final DateRange? dateRange = state.dateRange;
    if (dateRange == null) return;
    await _healthMeasurementRepository.refreshMeasurementsByDateRange(
      startDate: dateRange.startDate,
      endDate: dateRange.endDate,
      userId: _userId,
    );
  }

  void _chartDateRangeUpdated(DateRangeManagerState dateRangeManagerState) {
    final DateRange? dateRange = dateRangeManagerState.dateRange;
    if (dateRange == null) return;
    _disposeHealthMeasurementsListener();
    _measurementsListener ??= _healthMeasurementRepository
        .getMeasurementsByDateRange(
          startDate: dateRange.startDate,
          endDate: dateRange.endDate,
          userId: _userId,
        )
        .map((List<HealthMeasurement>? measurements) => [...?measurements])
        .listen(
      (List<HealthMeasurement> measurements) {
        final points = dateRangeManagerState.dateRangeType == DateRangeType.year
            ? _createPointsForEachMonth(dateRange.startDate.year, measurements)
            : _createPointsForEachDay(dateRange, measurements);
        emit(state.copyWith(
          dateRangeType: dateRangeManagerState.dateRangeType,
          dateRange: dateRange,
          restingHeartRatePoints: points.restingHeartRatePoints,
          fastingWeightPoints: points.fastingWeightPoints,
        ));
      },
    );
  }

  _ListenedPointsOfCharts _createPointsForEachDay(
    DateRange dateRange,
    List<HealthMeasurement> measurements,
  ) {
    DateTime counterDate = dateRange.startDate;
    final dayAfterEndDay = dateRange.endDate.add(const Duration(days: 1));
    final pointsOfCharts = _ListenedPointsOfCharts();
    while (!_dateService.areDaysTheSame(counterDate, dayAfterEndDay)) {
      final HealthMeasurement? foundMeasurement = measurements.firstWhereOrNull(
        (mes) => _dateService.areDaysTheSame(mes.date, counterDate),
      );
      pointsOfCharts.restingHeartRatePoints.add(HealthStatsChartPoint(
        date: counterDate,
        value: foundMeasurement?.restingHeartRate,
      ));
      pointsOfCharts.fastingWeightPoints.add(HealthStatsChartPoint(
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
        HealthStatsChartPoint(date: counterDate, value: avgRestingHeartRate),
      );
      pointsOfCharts.fastingWeightPoints.add(
        HealthStatsChartPoint(date: counterDate, value: avgFastingWeight),
      );
      counterDate = DateTime(counterDate.year, counterDate.month + 1);
    }
    return pointsOfCharts;
  }

  void _disposeChartDateRangeListener() {
    _dateRangeManagerListener?.cancel();
    _dateRangeManagerListener = null;
  }

  void _disposeHealthMeasurementsListener() {
    _measurementsListener?.cancel();
    _measurementsListener = null;
  }
}

class _ListenedPointsOfCharts extends Equatable {
  final List<HealthStatsChartPoint> restingHeartRatePoints = [];
  final List<HealthStatsChartPoint> fastingWeightPoints = [];

  @override
  List<Object?> get props => [restingHeartRatePoints, fastingWeightPoints];
}
