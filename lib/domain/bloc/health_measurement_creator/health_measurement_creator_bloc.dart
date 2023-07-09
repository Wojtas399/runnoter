import 'package:flutter_bloc/flutter_bloc.dart';

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
  })  : _authService = authService,
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
    if (event.date == null) {
      emit(state.copyWith(
        status: const BlocStatusComplete(),
      ));
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId != null) {
      final Stream<HealthMeasurement?> measurement$ =
          _healthMeasurementRepository.getMeasurementByDate(
        date: event.date!,
        userId: loggedUserId,
      );
      await for (final measurement in measurement$) {
        emit(state.copyWith(
          measurement: measurement,
          date: event.date,
          restingHeartRate: measurement?.restingHeartRate,
          fastingWeight: measurement?.fastingWeight,
        ));
        return;
      }
    }
  }

  Future<void> _dateChanged(
    HealthMeasurementCreatorEventDateChanged event,
    Emitter<HealthMeasurementCreatorState> emit,
  ) async {
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
    if (!state.canSubmit) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    if (await _healthMeasurementRepository.doesMeasurementFromDateExist(
      userId: loggedUserId,
      date: state.date!,
    )) {
      emitErrorStatus(
        emit,
        HealthMeasurementCreatorBlocError
            .measurementWithSelectedDateAlreadyExist,
      );
    } else if (state.date == state.measurement?.date) {
      await _updateMeasurement(loggedUserId);
      emitCompleteStatus(
        emit,
        HealthMeasurementCreatorBlocInfo.measurementUpdated,
      );
    } else {
      await _addMeasurement(loggedUserId);
      if (state.measurement != null) {
        await _deleteOriginalMeasurement(loggedUserId);
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

  Future<void> _updateMeasurement(String loggedUserId) async {
    await _healthMeasurementRepository.updateMeasurement(
      userId: loggedUserId,
      date: state.measurement!.date,
      restingHeartRate: state.restingHeartRate!,
      fastingWeight: state.fastingWeight!,
    );
  }

  Future<void> _addMeasurement(String loggedUserId) async {
    final HealthMeasurement measurement = HealthMeasurement(
      userId: loggedUserId,
      date: state.date!,
      restingHeartRate: state.restingHeartRate!,
      fastingWeight: state.fastingWeight!,
    );
    await _healthMeasurementRepository.addMeasurement(measurement: measurement);
  }

  Future<void> _deleteOriginalMeasurement(String loggedUserId) async {
    await _healthMeasurementRepository.deleteMeasurement(
      userId: loggedUserId,
      date: state.measurement!.date,
    );
  }
}

enum HealthMeasurementCreatorBlocInfo {
  measurementAdded,
  measurementUpdated,
}

enum HealthMeasurementCreatorBlocError {
  measurementWithSelectedDateAlreadyExist,
}
