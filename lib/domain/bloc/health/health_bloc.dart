import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/health_measurement.dart';
import '../../../../domain/repository/health_measurement_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../service/health_chart_service.dart';

part 'health_event.dart';
part 'health_state.dart';

class HealthBloc
    extends BlocWithStatus<HealthEvent, HealthState, HealthBlocInfo, dynamic> {
  final DateService _dateService;
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final HealthChartService _chartService;
  StreamSubscription<HealthMeasurement?>? _todayMeasurementListener;
  StreamSubscription<List<HealthMeasurement>?>?
      _measurementsFromDateRangeListener;

  HealthBloc({
    required DateService dateService,
    required AuthService authService,
    required HealthMeasurementRepository healthMeasurementRepository,
    required HealthChartService chartService,
    HealthState state = const HealthState(
      status: BlocStatusInitial(),
      chartRange: ChartRange.week,
    ),
  })  : _dateService = dateService,
        _authService = authService,
        _healthMeasurementRepository = healthMeasurementRepository,
        _chartService = chartService,
        super(state) {
    on<HealthEventInitialize>(_initialize);
    on<HealthEventTodayMeasurementUpdated>(_todayMeasurementUpdated);
    on<HealthEventMeasurementsFromDateRangeUpdated>(
      _measurementsFromDateRangeUpdated,
    );
    on<HealthEventAddTodayMeasurement>(_addTodayMeasurement);
    on<HealthEventChangeChartRangeType>(_changeChartRangeType);
    on<HealthEventPreviousChartRange>(_previousChartRange);
    on<HealthEventNextChartRange>(_nextChartRange);
  }

  @override
  Future<void> close() {
    _todayMeasurementListener?.cancel();
    _todayMeasurementListener = null;
    _removeMeasurementsFromDateRangeListener();
    return super.close();
  }

  void _initialize(
    HealthEventInitialize event,
    Emitter<HealthState> emit,
  ) {
    final DateTime today = _dateService.getToday();
    _setNewDateRange(
      _dateService.getFirstDayOfTheWeek(today),
      _dateService.getLastDayOfTheWeek(today),
      ChartRange.week,
      emit,
    );
    _setTodayMeasurementListener();
  }

  void _todayMeasurementUpdated(
    HealthEventTodayMeasurementUpdated event,
    Emitter<HealthState> emit,
  ) {
    emit(state.copyWith(
      todayMeasurement: event.todayMeasurement,
      removedTodayMeasurement: event.todayMeasurement == null,
    ));
  }

  void _measurementsFromDateRangeUpdated(
    HealthEventMeasurementsFromDateRangeUpdated event,
    Emitter<HealthState> emit,
  ) {
    final List<HealthMeasurement>? measurements = event.measurements;
    final DateTime? startDate = state.chartStartDate;
    final DateTime? endDate = state.chartEndDate;
    if (measurements == null || startDate == null || endDate == null) {
      return;
    }
    final (restingHeartRatePoints, fastingWeightPoints) =
        _chartService.createPointsOfCharts(
      chartRange: state.chartRange,
      startDate: startDate,
      endDate: endDate,
      measurements: measurements,
    );
    emit(state.copyWith(
      restingHeartRatePoints: restingHeartRatePoints,
      fastingWeightPoints: fastingWeightPoints,
    ));
  }

  Future<void> _addTodayMeasurement(
    HealthEventAddTodayMeasurement event,
    Emitter<HealthState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    emitLoadingStatus(emit);
    await _healthMeasurementRepository.addMeasurement(
      measurement: HealthMeasurement(
        userId: loggedUserId,
        date: _dateService.getToday(),
        restingHeartRate: event.restingHeartRate,
        fastingWeight: event.fastingWeight,
      ),
    );
    emitCompleteStatus(emit, HealthBlocInfo.healthMeasurementAdded);
  }

  void _changeChartRangeType(
    HealthEventChangeChartRangeType event,
    Emitter<HealthState> emit,
  ) {
    final (startDate, endDate) = _chartService.computeNewRange(
      chartRange: event.chartRangeType,
    );
    _setNewDateRange(startDate, endDate, event.chartRangeType, emit);
  }

  void _previousChartRange(
    HealthEventPreviousChartRange event,
    Emitter<HealthState> emit,
  ) {
    if (state.chartStartDate != null && state.chartEndDate != null) {
      final (startDate, endDate) = _chartService.computePreviousRange(
        startDate: state.chartStartDate!,
        endDate: state.chartEndDate!,
        chartRange: state.chartRange,
      );
      _setNewDateRange(startDate, endDate, state.chartRange, emit);
    }
  }

  void _nextChartRange(
    HealthEventNextChartRange event,
    Emitter<HealthState> emit,
  ) {
    if (state.chartStartDate != null && state.chartEndDate != null) {
      final (startDate, endDate) = _chartService.computeNextRange(
        startDate: state.chartStartDate!,
        endDate: state.chartEndDate!,
        chartRange: state.chartRange,
      );
      _setNewDateRange(startDate, endDate, state.chartRange, emit);
    }
  }

  void _removeMeasurementsFromDateRangeListener() {
    _measurementsFromDateRangeListener?.cancel();
    _measurementsFromDateRangeListener = null;
  }

  void _setTodayMeasurementListener() {
    _todayMeasurementListener ??= _loggedUserId$
        .switchMap(
          (loggedUserId) => _healthMeasurementRepository.getMeasurementByDate(
            date: _dateService.getToday(),
            userId: loggedUserId,
          ),
        )
        .listen(
          (HealthMeasurement? todayMeasurement) => add(
            HealthEventTodayMeasurementUpdated(
              todayMeasurement: todayMeasurement,
            ),
          ),
        );
  }

  void _setMeasurementsFromDateRangeListener(
    DateTime startDate,
    DateTime endDate,
  ) {
    _measurementsFromDateRangeListener ??= _loggedUserId$
        .switchMap(
          (loggedUserId) =>
              _healthMeasurementRepository.getMeasurementsByDateRange(
            startDate: startDate,
            endDate: endDate,
            userId: loggedUserId,
          ),
        )
        .listen(
          (List<HealthMeasurement>? measurements) => add(
            HealthEventMeasurementsFromDateRangeUpdated(
              measurements: measurements,
            ),
          ),
        );
  }

  void _setNewDateRange(
    DateTime startDate,
    DateTime endDate,
    ChartRange chartRange,
    Emitter<HealthState> emit,
  ) {
    emit(state.copyWith(
      chartRange: chartRange,
      chartStartDate: startDate,
      chartEndDate: endDate,
    ));
    _removeMeasurementsFromDateRangeListener();
    _setMeasurementsFromDateRangeListener(startDate, endDate);
  }

  Stream<String> get _loggedUserId$ =>
      _authService.loggedUserId$.whereType<String>();
}
