import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/model/morning_measurement.dart';
import '../../../../domain/repository/morning_measurement_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'health_chart_service.dart';

part 'health_event.dart';
part 'health_state.dart';

class HealthBloc
    extends BlocWithStatus<HealthEvent, HealthState, HealthBlocInfo, dynamic> {
  final DateService _dateService;
  final AuthService _authService;
  final MorningMeasurementRepository _morningMeasurementRepository;
  final HealthChartService _chartService;
  StreamSubscription<MorningMeasurement?>? _thisMorningMeasurementListener;
  StreamSubscription<List<MorningMeasurement>?>?
      _morningMeasurementsFromDateRangeListener;

  HealthBloc({
    required DateService dateService,
    required AuthService authService,
    required MorningMeasurementRepository morningMeasurementRepository,
    required HealthChartService chartService,
    BlocStatus status = const BlocStatusInitial(),
    ChartRange chartRange = ChartRange.week,
  })  : _dateService = dateService,
        _authService = authService,
        _morningMeasurementRepository = morningMeasurementRepository,
        _chartService = chartService,
        super(
          HealthState(
            status: status,
            chartRange: chartRange,
          ),
        ) {
    on<HealthEventInitialize>(_initialize);
    on<HealthEventThisMorningMeasurementUpdated>(
      _thisMorningMeasurementUpdated,
    );
    on<HealthEventMorningMeasurementsFromDateRangeUpdated>(
      _morningMeasurementsFromDateRangeUpdated,
    );
    on<HealthEventAddMorningMeasurement>(_addMorningMeasurement);
    on<HealthEventChangeChartRangeType>(_changeChartRangeType);
    on<HealthEventPreviousChartRange>(_previousChartRange);
    on<HealthEventNextChartRange>(_nextChartRange);
  }

  @override
  Future<void> close() {
    _thisMorningMeasurementListener?.cancel();
    _thisMorningMeasurementListener = null;
    _removeListenerOfMorningMeasurementsFromDateRange();
    return super.close();
  }

  void _initialize(
    HealthEventInitialize event,
    Emitter<HealthState> emit,
  ) {
    _setThisMorningMeasurementListener();
    final DateTime today = _dateService.getToday();
    _setNewDateRange(
      _dateService.getFirstDayOfTheWeek(today),
      _dateService.getLastDayOfTheWeek(today),
      ChartRange.week,
      emit,
    );
  }

  void _thisMorningMeasurementUpdated(
    HealthEventThisMorningMeasurementUpdated event,
    Emitter<HealthState> emit,
  ) {
    emit(state.copyWith(
      thisMorningMeasurement: event.thisMorningMeasurement,
    ));
  }

  void _morningMeasurementsFromDateRangeUpdated(
    HealthEventMorningMeasurementsFromDateRangeUpdated event,
    Emitter<HealthState> emit,
  ) {
    final List<MorningMeasurement>? measurements = event.measurements;
    final DateTime? startDate = state.chartStartDate;
    final DateTime? endDate = state.chartEndDate;
    if (measurements == null || startDate == null || endDate == null) {
      return;
    }
    final (restingHeartRatePoints, fastingWeightPoints) =
        _chartService.createPointsOfCharts(startDate, endDate, measurements);
    emit(state.copyWith(
      morningMeasurements: measurements,
      restingHeartRatePoints: restingHeartRatePoints,
      fastingWeightPoints: fastingWeightPoints,
    ));
  }

  Future<void> _addMorningMeasurement(
    HealthEventAddMorningMeasurement event,
    Emitter<HealthState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    emitLoadingStatus(emit);
    await _morningMeasurementRepository.addMeasurement(
      userId: loggedUserId,
      measurement: MorningMeasurement(
        date: _dateService.getToday(),
        restingHeartRate: event.restingHeartRate,
        fastingWeight: event.fastingWeight,
      ),
    );
    emitCompleteStatus(emit, HealthBlocInfo.morningMeasurementAdded);
  }

  void _changeChartRangeType(
    HealthEventChangeChartRangeType event,
    Emitter<HealthState> emit,
  ) {
    final (startDate, endDate) = _chartService.computeNewRange(
      event.chartRangeType,
    );
    _setNewDateRange(startDate, endDate, event.chartRangeType, emit);
  }

  void _previousChartRange(
    HealthEventPreviousChartRange event,
    Emitter<HealthState> emit,
  ) {
    DateTime? startDate = state.restingHeartRatePoints?.first.date;
    DateTime? endDate = state.restingHeartRatePoints?.last.date;
    if (startDate != null && endDate != null) {
      (startDate, endDate) = _chartService.computePreviousRange(
        startDate,
        endDate,
        state.chartRange,
      );
      _setNewDateRange(startDate, endDate, state.chartRange, emit);
    }
  }

  void _nextChartRange(
    HealthEventNextChartRange event,
    Emitter<HealthState> emit,
  ) {
    DateTime? startDate = state.restingHeartRatePoints?.first.date;
    DateTime? endDate = state.restingHeartRatePoints?.last.date;
    if (startDate != null && endDate != null) {
      (startDate, endDate) = _chartService.computeNextRange(
        startDate,
        endDate,
        state.chartRange,
      );
      _setNewDateRange(startDate, endDate, state.chartRange, emit);
    }
  }

  void _setThisMorningMeasurementListener() {
    _thisMorningMeasurementListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (loggedUserId) => _morningMeasurementRepository.getMeasurementByDate(
            date: _dateService.getToday(),
            userId: loggedUserId,
          ),
        )
        .listen(
          (MorningMeasurement? thisMorningMeasurement) => add(
            HealthEventThisMorningMeasurementUpdated(
              thisMorningMeasurement: thisMorningMeasurement,
            ),
          ),
        );
  }

  void _setMorningMeasurementsFromDateRangeListener(
    DateTime startDate,
    DateTime endDate,
  ) {
    _morningMeasurementsFromDateRangeListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (loggedUserId) =>
              _morningMeasurementRepository.getMeasurementsByDateRange(
            startDate: startDate,
            endDate: endDate,
            userId: loggedUserId,
          ),
        )
        .listen(
          (List<MorningMeasurement>? morningMeasurements) => add(
            HealthEventMorningMeasurementsFromDateRangeUpdated(
              measurements: morningMeasurements,
            ),
          ),
        );
  }

  void _removeListenerOfMorningMeasurementsFromDateRange() {
    _morningMeasurementsFromDateRangeListener?.cancel();
    _morningMeasurementsFromDateRangeListener = null;
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
    _removeListenerOfMorningMeasurementsFromDateRange();
    _setMorningMeasurementsFromDateRangeListener(startDate, endDate);
  }
}
