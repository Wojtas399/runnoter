import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/model/health_measurement.dart';
import '../../../../domain/repository/health_measurement_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';

part 'health_measurement_creator_event.dart';
part 'health_measurement_creator_state.dart';

class HealthMeasurementCreatorBloc extends BlocWithStatus<
    HealthMeasurementCreatorEvent,
    HealthMeasurementCreatorState,
    dynamic,
    dynamic> {
  final DateService _dateService;
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;

  HealthMeasurementCreatorBloc({
    required DateService dateService,
    required AuthService authService,
    required HealthMeasurementRepository healthMeasurementRepository,
    BlocStatus status = const BlocStatusInitial(),
    String? restingHeartRateStr,
    String? fastingWeightStr,
  })  : _dateService = dateService,
        _authService = authService,
        _healthMeasurementRepository = healthMeasurementRepository,
        super(
          HealthMeasurementCreatorState(
            status: status,
            restingHeartRateStr: restingHeartRateStr,
            fastingWeightStr: fastingWeightStr,
          ),
        ) {
    on<HealthMeasurementCreatorEventInitialize>(_initialize);
    on<HealthMeasurementCreatorEventRestingHeartRateChanged>(
      _restingHeartRateChanged,
    );
    on<HealthMeasurementCreatorEventFastingWeightChanged>(
      _fastingWeightChanged,
    );
  }

  Future<void> _initialize(
    HealthMeasurementCreatorEventInitialize event,
    Emitter<HealthMeasurementCreatorState> emit,
  ) async {
    if (event.date == null) {
      emit(state.copyWith(
        date: _dateService.getToday(),
      ));
    } else {
      final HealthMeasurement? measurement = await _loadMeasurementFromRemoteDb(
        event.date!,
      );
      emit(state.copyWith(
        status: const BlocStatusComplete<HealthMeasurementCreatorBlocInfo>(
          info: HealthMeasurementCreatorBlocInfo.measurementLoaded,
        ),
        date: event.date,
        restingHeartRateStr: measurement?.restingHeartRate.toString(),
        fastingWeightStr: measurement?.fastingWeight.toString(),
      ));
    }
  }

  void _restingHeartRateChanged(
    HealthMeasurementCreatorEventRestingHeartRateChanged event,
    Emitter<HealthMeasurementCreatorState> emit,
  ) {
    emit(state.copyWith(
      restingHeartRateStr: event.restingHeartRateStr,
    ));
  }

  void _fastingWeightChanged(
    HealthMeasurementCreatorEventFastingWeightChanged event,
    Emitter<HealthMeasurementCreatorState> emit,
  ) {
    emit(state.copyWith(
      fastingWeightStr: event.fastingWeightStr,
    ));
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
  measurementLoaded,
}
