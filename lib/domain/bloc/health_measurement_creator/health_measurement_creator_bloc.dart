import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/health_measurement.dart';
import '../../../../domain/repository/health_measurement_repository.dart';
import '../../../../domain/service/auth_service.dart';

part 'health_measurement_creator_event.dart';
part 'health_measurement_creator_state.dart';

class HealthMeasurementCreatorBloc extends BlocWithStatus<
    HealthMeasurementCreatorEvent,
    HealthMeasurementCreatorState,
    HealthMeasurementCreatorBlocInfo,
    dynamic> {
  final DateService _dateService;
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;

  HealthMeasurementCreatorBloc({
    required DateService dateService,
    required AuthService authService,
    required HealthMeasurementRepository healthMeasurementRepository,
    BlocStatus status = const BlocStatusInitial(),
    HealthMeasurement? measurement,
    int? restingHeartRate,
    double? fastingWeight,
  })  : _dateService = dateService,
        _authService = authService,
        _healthMeasurementRepository = healthMeasurementRepository,
        super(
          HealthMeasurementCreatorState(
            dateService: dateService,
            status: status,
            measurement: measurement,
            restingHeartRate: restingHeartRate,
            fastingWeight: fastingWeight,
          ),
        ) {
    on<HealthMeasurementCreatorEventInitialize>(_initialize);
    on<HealthMeasurementCreatorEventDateChanged>(_dateChanged);
    on<HealthMeasurementCreatorEventRestingHeartRateChanged>(
      _restingHeartRateChanged,
    );
    on<HealthMeasurementCreatorEventFastingWeightChanged>(
      _fastingWeightChanged,
    );
    on<HealthMeasurementCreatorEventSubmit>(_submit);
  }

  Future<void> _initialize(
    HealthMeasurementCreatorEventInitialize event,
    Emitter<HealthMeasurementCreatorState> emit,
  ) async {
    if (event.date != null) {
      final HealthMeasurement? measurement = await _loadMeasurementFromRemoteDb(
        event.date!,
      );
      emit(state.copyWith(
        measurement: measurement,
        date: measurement?.date,
        restingHeartRate: measurement?.restingHeartRate,
        fastingWeight: measurement?.fastingWeight,
      ));
    } else {
      emit(state.copyWith(
        date: _dateService.getToday(),
      ));
    }
  }

  void _dateChanged(
    HealthMeasurementCreatorEventDateChanged event,
    Emitter<HealthMeasurementCreatorState> emit,
  ) {
    emit(state.copyWith(
      date: event.date,
    ));
  }

  void _restingHeartRateChanged(
    HealthMeasurementCreatorEventRestingHeartRateChanged event,
    Emitter<HealthMeasurementCreatorState> emit,
  ) {
    emit(state.copyWith(
      restingHeartRate: event.restingHeartRate,
    ));
  }

  void _fastingWeightChanged(
    HealthMeasurementCreatorEventFastingWeightChanged event,
    Emitter<HealthMeasurementCreatorState> emit,
  ) {
    emit(state.copyWith(
      fastingWeight: event.fastingWeight,
    ));
  }

  Future<void> _submit(
    HealthMeasurementCreatorEventSubmit event,
    Emitter<HealthMeasurementCreatorState> emit,
  ) async {
    if (state.restingHeartRate == null || state.fastingWeight == null) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    if (state.measurement == null) {
      final HealthMeasurement measurement = HealthMeasurement(
        userId: loggedUserId,
        date: _dateService.getToday(),
        restingHeartRate: state.restingHeartRate!,
        fastingWeight: state.fastingWeight!,
      );
      await _healthMeasurementRepository.addMeasurement(
        measurement: measurement,
      );
    } else {
      await _healthMeasurementRepository.updateMeasurement(
        userId: loggedUserId,
        date: state.measurement!.date,
        restingHeartRate: state.restingHeartRate!,
        fastingWeight: state.fastingWeight!,
      );
    }
    emitCompleteStatus(emit, HealthMeasurementCreatorBlocInfo.measurementSaved);
  }

  Future<HealthMeasurement?> _loadMeasurementFromRemoteDb(
    DateTime date,
  ) async =>
      await _authService.loggedUserId$
          .whereType<String>()
          .switchMap(
            (loggedUserId) => _healthMeasurementRepository.getMeasurementByDate(
              date: date,
              userId: loggedUserId,
            ),
          )
          .first;
}

enum HealthMeasurementCreatorBlocInfo {
  measurementSaved,
}
