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

part 'health_event.dart';
part 'health_state.dart';

class HealthBloc
    extends BlocWithStatus<HealthEvent, HealthState, HealthBlocInfo, dynamic> {
  final DateService _dateService;
  final AuthService _authService;
  final MorningMeasurementRepository _morningMeasurementRepository;
  StreamSubscription<MorningMeasurement?>? _thisMorningMeasurementListener;
  StreamSubscription<List<MorningMeasurement>?>?
      _morningMeasurementsFromDateRangeListener;

  HealthBloc({
    required DateService dateService,
    required AuthService authService,
    required MorningMeasurementRepository morningMeasurementRepository,
    BlocStatus status = const BlocStatusInitial(),
    MorningMeasurement? thisMorningMeasurement,
    ChartRange chartRange = ChartRange.week,
    List<MorningMeasurement>? morningMeasurements,
    List<HealthChartPoint>? chartPoints,
  })  : _dateService = dateService,
        _authService = authService,
        _morningMeasurementRepository = morningMeasurementRepository,
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
    on<HealthEventChangeChartRange>(_changeChartRange);
  }

  @override
  Future<void> close() {
    _thisMorningMeasurementListener?.cancel();
    _thisMorningMeasurementListener = null;
    _morningMeasurementsFromDateRangeListener?.cancel();
    _morningMeasurementsFromDateRangeListener = null;
    return super.close();
  }

  void _initialize(
    HealthEventInitialize event,
    Emitter<HealthState> emit,
  ) {
    _emitInitialChartPoints(emit);
    _setThisMorningMeasurementListener();
    _setMorningMeasurementsFromDateRangeListener();
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
    final List<MorningMeasurement>? morningMeasurements =
        event.morningMeasurementsFromDateRange;
    List<HealthChartPoint>? updatedChartPoints;
    if (state.chartPoints != null && morningMeasurements != null) {
      updatedChartPoints = [...?state.chartPoints];
      final List<DateTime> pointDates =
          updatedChartPoints.map((point) => point.date).toList();
      for (final measurement in morningMeasurements) {
        if (pointDates.contains(measurement.date)) {
          final pointIndex = updatedChartPoints.indexWhere(
            (point) => _dateService.areDatesTheSame(
              point.date,
              measurement.date,
            ),
          );
          updatedChartPoints[pointIndex] = HealthChartPoint(
            date: measurement.date,
            value: measurement.restingHeartRate,
          );
        }
      }
    }
    emit(state.copyWith(
      morningMeasurements: event.morningMeasurementsFromDateRange,
      chartPoints: updatedChartPoints,
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
        date: _dateService.getTodayDate(),
        restingHeartRate: event.restingHeartRate,
        fastingWeight: event.fastingWeight,
      ),
    );
    emitCompleteStatus(emit, HealthBlocInfo.morningMeasurementAdded);
  }

  void _changeChartRange(
    HealthEventChangeChartRange event,
    Emitter<HealthState> emit,
  ) {
    emit(state.copyWith(
      chartRange: event.newChartRange,
    ));
  }

  void _emitInitialChartPoints(Emitter<HealthState> emit) {
    final DateTime currentDate = _dateService.getTodayDate();
    DateTime counterDate =
        _dateService.getFirstDateFromWeekMatchingToDate(currentDate);
    final DateTime endDate = _dateService
        .getLastDateFromWeekMatchingToDate(currentDate)
        .add(const Duration(days: 1));
    final List<HealthChartPoint> chartPoints = [];
    while (!_dateService.areDatesTheSame(counterDate, endDate)) {
      chartPoints.add(
        HealthChartPoint(date: counterDate, value: null),
      );
      counterDate = counterDate.add(const Duration(days: 1));
    }
    emit(state.copyWith(
      chartPoints: chartPoints,
    ));
  }

  void _setThisMorningMeasurementListener() {
    _thisMorningMeasurementListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (loggedUserId) => _morningMeasurementRepository.getMeasurementByDate(
            date: _dateService.getTodayDate(),
            userId: loggedUserId,
          ),
        )
        .listen(
          (thisMorningMeasurement) => add(
            HealthEventThisMorningMeasurementUpdated(
              thisMorningMeasurement: thisMorningMeasurement,
            ),
          ),
        );
  }

  void _setMorningMeasurementsFromDateRangeListener() {
    final DateTime todayDate = _dateService.getTodayDate();
    _morningMeasurementsFromDateRangeListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (loggedUserId) =>
              _morningMeasurementRepository.getMeasurementsByDateRange(
            startDate: _dateService.getFirstDateFromWeekMatchingToDate(
              todayDate,
            ),
            endDate: _dateService.getLastDateFromWeekMatchingToDate(todayDate),
            userId: loggedUserId,
          ),
        )
        .listen(
          (morningMeasurements) => add(
            HealthEventMorningMeasurementsFromDateRangeUpdated(
              morningMeasurementsFromDateRange: morningMeasurements,
            ),
          ),
        );
  }
}
