import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
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
import '../../service/health_chart_service.dart';

part 'health_event.dart';
part 'health_state.dart';

class HealthBloc
    extends BlocWithStatus<HealthEvent, HealthState, HealthBlocInfo, dynamic> {
  final DateService _dateService;
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final HealthChartService _chartService;
  StreamSubscription<List<HealthMeasurement>?>?
      _measurementsFromDateRangeListener;

  HealthBloc({
    required DateService dateService,
    required HealthChartService chartService,
    HealthState state = const HealthState(
      status: BlocStatusInitial(),
      chartRange: ChartRange.week,
    ),
  })  : _dateService = dateService,
        _authService = getIt<AuthService>(),
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _chartService = chartService,
        super(state) {
    on<HealthEventInitialize>(_initialize, transformer: restartable());
    on<HealthEventMeasurementsFromDateRangeUpdated>(
      _measurementsFromDateRangeUpdated,
    );
    on<HealthEventAddTodayMeasurement>(_addTodayMeasurement);
    on<HealthEventDeleteTodayMeasurement>(_deleteTodayMeasurement);
    on<HealthEventChangeChartRangeType>(_changeChartRangeType);
    on<HealthEventPreviousChartRange>(_previousChartRange);
    on<HealthEventNextChartRange>(_nextChartRange);
  }

  @override
  Future<void> close() {
    _removeMeasurementsFromDateRangeListener();
    return super.close();
  }

  Future<void> _initialize(
    HealthEventInitialize event,
    Emitter<HealthState> emit,
  ) async {
    final DateTime today = _dateService.getToday();
    _setNewDateRange(
      _dateService.getFirstDayOfTheWeek(today),
      _dateService.getLastDayOfTheWeek(today),
      ChartRange.week,
      emit,
    );
    await _setTodayMeasurementListener(emit);
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
    if (loggedUserId == null) return;
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
    emitCompleteStatus(emit, HealthBlocInfo.healthMeasurementDeleted);
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

  Future<void> _setTodayMeasurementListener(Emitter<HealthState> emit) async {
    final Stream<HealthMeasurement?> todayMeasurement$ =
        _loggedUserId$.switchMap(
      (loggedUserId) => _healthMeasurementRepository.getMeasurementByDate(
        date: _dateService.getToday(),
        userId: loggedUserId,
      ),
    );
    await emit.forEach(
      todayMeasurement$,
      onData: (HealthMeasurement? todayMeasurement) => state.copyWith(
        todayMeasurement: todayMeasurement,
        removedTodayMeasurement: todayMeasurement == null,
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

enum HealthBlocInfo {
  healthMeasurementAdded,
  healthMeasurementDeleted,
}
