import 'dart:async';

import 'package:equatable/equatable.dart';
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
  StreamSubscription<HealthStateListenedParams>? _listenedParamsListener;

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
    on<HealthEventListenedParamsUpdated>(_listenedParamsUpdated);
    on<HealthEventAddMorningMeasurement>(_addMorningMeasurement);
    on<HealthEventChangeChartRange>(_changeChartRange);
  }

  @override
  Future<void> close() {
    _listenedParamsListener?.cancel();
    _listenedParamsListener = null;
    return super.close();
  }

  void _initialize(
    HealthEventInitialize event,
    Emitter<HealthState> emit,
  ) {
    final DateTime todayDate = _dateService.getTodayDate();
    _listenedParamsListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String loggedUserId) => Rx.combineLatest2(
            _morningMeasurementRepository.getMeasurementByDate(
              date: todayDate,
              userId: loggedUserId,
            ),
            _morningMeasurementRepository.getMeasurementsByDateRange(
              startDate:
                  _dateService.getFirstDateFromWeekMatchingToDate(todayDate),
              endDate:
                  _dateService.getLastDateFromWeekMatchingToDate(todayDate),
              userId: loggedUserId,
            ),
            (
              MorningMeasurement? thisMorningMeasurement,
              List<MorningMeasurement>? morningMeasurements,
            ) =>
                HealthStateListenedParams(
              thisMorningMeasurement: thisMorningMeasurement,
              morningMeasurements: morningMeasurements,
            ),
          ),
        )
        .listen(
          (HealthStateListenedParams listenedParams) => add(
            HealthEventListenedParamsUpdated(
              updatedListenedParams: listenedParams,
            ),
          ),
        );
  }

  void _listenedParamsUpdated(
    HealthEventListenedParamsUpdated event,
    Emitter<HealthState> emit,
  ) {
    emit(state.copyWith(
      thisMorningMeasurement:
          event.updatedListenedParams.thisMorningMeasurement,
      morningMeasurements: event.updatedListenedParams.morningMeasurements,
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
}
