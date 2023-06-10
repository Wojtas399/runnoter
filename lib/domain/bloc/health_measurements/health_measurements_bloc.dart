import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/health_measurement.dart';
import '../../../../domain/repository/health_measurement_repository.dart';
import '../../../../domain/service/auth_service.dart';

part 'health_measurements_event.dart';
part 'health_measurements_state.dart';

class HealthMeasurementsBloc extends BlocWithStatus<HealthMeasurementsEvent,
    HealthMeasurementsState, HealthMeasurementsBlocInfo, dynamic> {
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;
  StreamSubscription<List<HealthMeasurement>?>? _measurementsListener;

  HealthMeasurementsBloc({
    required AuthService authService,
    required HealthMeasurementRepository healthMeasurementRepository,
    BlocStatus status = const BlocStatusInitial(),
    List<HealthMeasurement>? measurements,
  })  : _authService = authService,
        _healthMeasurementRepository = healthMeasurementRepository,
        super(
          HealthMeasurementsState(
            status: status,
            measurements: measurements,
          ),
        ) {
    on<HealthMeasurementsEventInitialize>(_initialize);
    on<HealthMeasurementsEventMeasurementsUpdated>(_measurementsUpdated);
    on<HealthMeasurementsEventDeleteMeasurement>(_deleteMeasurement);
  }

  @override
  Future<void> close() {
    _measurementsListener?.cancel();
    _measurementsListener = null;
    return super.close();
  }

  void _initialize(
    HealthMeasurementsEventInitialize event,
    Emitter<HealthMeasurementsState> emit,
  ) {
    _measurementsListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (loggedUserId) => _healthMeasurementRepository.getAllMeasurements(
            userId: loggedUserId,
          ),
        )
        .listen(
          (measurements) => add(
            HealthMeasurementsEventMeasurementsUpdated(
              measurements: measurements,
            ),
          ),
        );
  }

  void _measurementsUpdated(
    HealthMeasurementsEventMeasurementsUpdated event,
    Emitter<HealthMeasurementsState> emit,
  ) {
    List<HealthMeasurement>? sortedMeasurements;
    if (event.measurements != null) {
      sortedMeasurements = [...?event.measurements];
    }
    sortedMeasurements?.sort(_compareDatesOfMeasurements);
    emit(state.copyWith(
      measurements: sortedMeasurements,
    ));
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
    emitCompleteStatus(emit, HealthMeasurementsBlocInfo.measurementDeleted);
  }

  int _compareDatesOfMeasurements(
    HealthMeasurement m1,
    HealthMeasurement m2,
  ) =>
      m1.date.isBefore(m2.date)
          ? 1
          : m1.date.isAfter(m2.date)
              ? -1
              : 0;
}

enum HealthMeasurementsBlocInfo {
  measurementDeleted,
}
