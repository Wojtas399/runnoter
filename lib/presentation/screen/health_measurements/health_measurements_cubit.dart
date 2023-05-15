import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/model/health_measurement.dart';
import '../../../domain/repository/health_measurement_repository.dart';
import '../../../domain/service/auth_service.dart';

class HealthMeasurementsCubit extends Cubit<List<HealthMeasurement>?> {
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;
  StreamSubscription<List<HealthMeasurement>?>? _healthMeasurementsListener;

  HealthMeasurementsCubit({
    required AuthService authService,
    required HealthMeasurementRepository healthMeasurementRepository,
  })  : _authService = authService,
        _healthMeasurementRepository = healthMeasurementRepository,
        super(null);

  @override
  Future<void> close() {
    _healthMeasurementsListener?.cancel();
    _healthMeasurementsListener = null;
    return super.close();
  }

  void initialize() {
    _healthMeasurementsListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String loggedUserId) =>
              _healthMeasurementRepository.getAllMeasurements(
            userId: loggedUserId,
          ),
        )
        .listen(
          (List<HealthMeasurement>? measurements) => emit(measurements),
        );
  }
}
