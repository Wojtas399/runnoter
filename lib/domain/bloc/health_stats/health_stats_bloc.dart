import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/entity/health_measurement.dart';
import '../../../../domain/repository/health_measurement_repository.dart';
import '../../../dependency_injection.dart';
import '../../cubit/date_range_manager_cubit.dart';

part 'health_stats_event.dart';
part 'health_stats_state.dart';

class HealthStatsBloc extends Bloc<HealthStatsEvent, HealthStatsState> {
  final String _userId;
  final DateService _dateService;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final DateRangeManagerCubit _dateRangeManagerCubit;
  StreamSubscription<DateRangeManagerState>? _dateRangeManagerListener;

  HealthStatsBloc({
    required String userId,
    HealthStatsState initialState = const HealthStatsState(),
  })  : _userId = userId,
        _dateService = getIt<DateService>(),
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _dateRangeManagerCubit = getIt<DateRangeManagerCubit>(),
        super(initialState) {
    on<HealthStatsEventInitialize>(_initialize);
    on<HealthStatsEventChartDateRangeUpdated>(
      _chartDateRangeUpdated,
      transformer: restartable(),
    );
    on<HealthStatsEventChangeChartDateRangeType>(_changeChartDateRangeType);
    on<HealthStatsEventPreviousChartDateRange>(_previousChartDateRange);
    on<HealthStatsEventNextChartDateRange>(_nextChartDateRange);
  }

  @override
  Future<void> close() {
    _disposeChartDateRangeListener();
    return super.close();
  }

  //TODO: you can combine RxDart functions to create only one listener instead of 2
  void _initialize(
    HealthStatsEventInitialize event,
    Emitter<HealthStatsState> emit,
  ) {
    _disposeChartDateRangeListener();
    _dateRangeManagerListener ??= _dateRangeManagerCubit.stream.listen(
      (DateRangeManagerState dateRangeManagerState) => add(
        HealthStatsEventChartDateRangeUpdated(
          dateRangeManagerState: dateRangeManagerState,
        ),
      ),
    );
    _dateRangeManagerCubit.initializeNewDateRangeType(DateRangeType.week);
  }

  Future<void> _chartDateRangeUpdated(
    HealthStatsEventChartDateRangeUpdated event,
    Emitter<HealthStatsState> emit,
  ) async {
    final DateRange? dateRange = event.dateRangeManagerState.dateRange;
    if (dateRange == null) return;
    final Stream<List<HealthMeasurement>> stream$ = _healthMeasurementRepository
        .getMeasurementsByDateRange(
          startDate: dateRange.startDate,
          endDate: dateRange.endDate,
          userId: _userId,
        )
        .map((List<HealthMeasurement>? measurements) => [...?measurements]);
    await emit.forEach(
      stream$,
      onData: (List<HealthMeasurement> measurements) {
        final points = event.dateRangeManagerState.dateRangeType ==
                DateRangeType.year
            ? _createPointsForEachMonth(dateRange.startDate.year, measurements)
            : _createPointsForEachDay(dateRange, measurements);
        return state.copyWith(
          dateRangeType: event.dateRangeManagerState.dateRangeType,
          dateRange: dateRange,
          restingHeartRatePoints: points.restingHeartRatePoints,
          fastingWeightPoints: points.fastingWeightPoints,
        );
      },
    );
  }

  void _changeChartDateRangeType(
    HealthStatsEventChangeChartDateRangeType event,
    Emitter<HealthStatsState> emit,
  ) {
    _dateRangeManagerCubit.initializeNewDateRangeType(event.dateRangeType);
  }

  void _previousChartDateRange(
    HealthStatsEventPreviousChartDateRange event,
    Emitter<HealthStatsState> emit,
  ) {
    _dateRangeManagerCubit.previousDateRange();
  }

  void _nextChartDateRange(
    HealthStatsEventNextChartDateRange event,
    Emitter<HealthStatsState> emit,
  ) {
    _dateRangeManagerCubit.nextDateRange();
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
}

class _ListenedPointsOfCharts extends Equatable {
  final List<HealthStatsChartPoint> restingHeartRatePoints = [];
  final List<HealthStatsChartPoint> fastingWeightPoints = [];

  @override
  List<Object?> get props => [restingHeartRatePoints, fastingWeightPoints];
}
