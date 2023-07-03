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
    HealthMeasurementCreatorBlocError> {
  final DateService _dateService;
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;

  HealthMeasurementCreatorBloc({
    required DateService dateService,
    required AuthService authService,
    required HealthMeasurementRepository healthMeasurementRepository,
    BlocStatus status = const BlocStatusInitial(),
    HealthMeasurement? measurement,
    DateTime? date,
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
            date: date,
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

  Future<void> _dateChanged(
    HealthMeasurementCreatorEventDateChanged event,
    Emitter<HealthMeasurementCreatorState> emit,
  ) async {
    if (event.date == state.measurement?.date) {
      emit(state.copyWith(
        date: event.date,
      ));
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    emitLoadingStatus(emit);
    if (await _healthMeasurementRepository.doesMeasurementFromDateExist(
      userId: loggedUserId,
      date: event.date,
    )) {
      emitErrorStatus(
        emit,
        HealthMeasurementCreatorBlocError
            .measurementWithSelectedDateAlreadyExist,
      );
    } else {
      emit(state.copyWith(
        date: event.date,
      ));
    }
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
    if (!state.canSubmit) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    if (state.date == state.measurement?.date) {
      await _healthMeasurementRepository.updateMeasurement(
        userId: loggedUserId,
        date: state.measurement!.date,
        restingHeartRate: state.restingHeartRate!,
        fastingWeight: state.fastingWeight!,
      );
      emitCompleteStatus(
        emit,
        HealthMeasurementCreatorBlocInfo.measurementUpdated,
      );
    } else {
      final HealthMeasurement measurement = HealthMeasurement(
        userId: loggedUserId,
        date: state.date!,
        restingHeartRate: state.restingHeartRate!,
        fastingWeight: state.fastingWeight!,
      );
      await _healthMeasurementRepository.addMeasurement(
        measurement: measurement,
      );
      if (state.measurement != null) {
        await _healthMeasurementRepository.deleteMeasurement(
          userId: loggedUserId,
          date: state.measurement!.date,
        );
        emitCompleteStatus(
          emit,
          HealthMeasurementCreatorBlocInfo.measurementUpdated,
        );
        return;
      }
      emitCompleteStatus(
        emit,
        HealthMeasurementCreatorBlocInfo.measurementAdded,
      );
    }
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
  measurementAdded,
  measurementUpdated,
}

enum HealthMeasurementCreatorBlocError {
  measurementWithSelectedDateAlreadyExist,
}
