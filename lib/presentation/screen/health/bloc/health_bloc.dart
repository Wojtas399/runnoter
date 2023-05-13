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
    MorningMeasurement? thisMorningMeasurement,
    ChartRange chartRange = ChartRange.week,
    List<MorningMeasurement>? morningMeasurements,
    List<HealthChartPoint>? chartPoints,
  })  : _dateService = dateService,
        _authService = authService,
        _morningMeasurementRepository = morningMeasurementRepository,
        _chartService = chartService,
        super(
          HealthState(
            status: status,
            thisMorningMeasurement: thisMorningMeasurement,
            chartRange: chartRange,
            morningMeasurements: morningMeasurements,
            chartPoints: chartPoints,
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
    final DateTime today = _dateService.getToday();
    final firstWeekDay = _dateService.getFirstDayOfTheWeek(today);
    final lastWeekDay = _dateService.getLastDayOfTheWeek(today);
    emit(state.copyWith(
      chartPoints: _chartService.createInitialChartPoints(
        firstWeekDay,
        lastWeekDay,
      ),
    ));
    _setThisMorningMeasurementListener();
    _setMorningMeasurementsFromDateRangeListener(firstWeekDay, lastWeekDay);
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
    if (measurements == null) {
      return;
    }
    emit(state.copyWith(
      morningMeasurements: measurements,
      chartPoints:
          _chartService.updateChartPointsWithRestingHeartRateMeasurements(
        state.chartPoints,
        measurements,
      ),
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
    emit(state.copyWith(
      chartPoints: _chartService.createInitialChartPoints(startDate, endDate),
      chartRange: event.chartRangeType,
    ));
    _removeListenerOfMorningMeasurementsFromDateRange();
    _setMorningMeasurementsFromDateRangeListener(startDate, endDate);
  }

  void _previousChartRange(
    HealthEventPreviousChartRange event,
    Emitter<HealthState> emit,
  ) {
    DateTime? startDate = state.chartPoints?.first.date;
    DateTime? endDate = state.chartPoints?.last.date;
    if (startDate != null && endDate != null) {
      (startDate, endDate) = _chartService.computePreviousRange(
        startDate,
        endDate,
        state.chartRange,
      );
      _setNewDateRange(startDate, endDate, emit);
    }
  }

  void _nextChartRange(
    HealthEventNextChartRange event,
    Emitter<HealthState> emit,
  ) {
    DateTime? startDate = state.chartPoints?.first.date;
    DateTime? endDate = state.chartPoints?.last.date;
    if (startDate != null && endDate != null) {
      (startDate, endDate) = _chartService.computeNextRange(
        startDate,
        endDate,
        state.chartRange,
      );
      _setNewDateRange(startDate, endDate, emit);
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
    Emitter<HealthState> emit,
  ) {
    emit(state.copyWith(
      chartPoints: _chartService.createInitialChartPoints(startDate, endDate),
    ));
    _removeListenerOfMorningMeasurementsFromDateRange();
    _setMorningMeasurementsFromDateRangeListener(startDate, endDate);
  }
}
