import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/health_measurement.dart';
import '../../../../domain/repository/health_measurement_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';

part 'health_measurements_event.dart';
part 'health_measurements_state.dart';

class HealthMeasurementsBloc extends BlocWithStatus<HealthMeasurementsEvent,
    HealthMeasurementsState, HealthMeasurementsBlocInfo, dynamic> {
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;

  HealthMeasurementsBloc({
    BlocStatus status = const BlocStatusInitial(),
    List<HealthMeasurement>? measurements,
  })  : _authService = getIt<AuthService>(),
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        super(
          HealthMeasurementsState(
            status: status,
            measurements: measurements,
          ),
        ) {
    on<HealthMeasurementsEventInitialize>(
      _initialize,
      transformer: restartable(),
    );
    on<HealthMeasurementsEventDeleteMeasurement>(_deleteMeasurement);
  }

  Future<void> _initialize(
    HealthMeasurementsEventInitialize event,
    Emitter<HealthMeasurementsState> emit,
  ) async {
    final Stream<List<HealthMeasurement>?> measurements$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (loggedUserId) => _healthMeasurementRepository.getAllMeasurements(
                userId: loggedUserId,
              ),
            );
    await emit.forEach(
      measurements$,
      onData: (List<HealthMeasurement>? measurements) {
        List<HealthMeasurement>? sortedMeasurements;
        if (measurements != null) sortedMeasurements = [...measurements];
        sortedMeasurements?.sort(_compareDatesOfMeasurements);
        return state.copyWith(measurements: sortedMeasurements);
      },
    );
  }

  Future<void> _deleteMeasurement(
    HealthMeasurementsEventDeleteMeasurement event,
    Emitter<HealthMeasurementsState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _healthMeasurementRepository.deleteMeasurement(
      userId: loggedUserId,
      date: event.date,
    );
    emitCompleteStatus(
      emit,
      info: HealthMeasurementsBlocInfo.measurementDeleted,
    );
  }

  int _compareDatesOfMeasurements(HealthMeasurement m1, HealthMeasurement m2) =>
      m1.date.isBefore(m2.date)
          ? 1
          : m1.date.isAfter(m2.date)
              ? -1
              : 0;
}

enum HealthMeasurementsBlocInfo {
  measurementDeleted,
}
