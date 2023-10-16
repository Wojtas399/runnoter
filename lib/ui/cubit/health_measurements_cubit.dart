import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/interface/repository/health_measurement_repository.dart';
import '../../data/interface/service/auth_service.dart';
import '../../data/model/health_measurement.dart';
import '../../dependency_injection.dart';

class HealthMeasurementsCubit extends Cubit<List<HealthMeasurement>?> {
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;
  StreamSubscription<List<HealthMeasurement>?>? _healthMeasurementsListener;

  HealthMeasurementsCubit({List<HealthMeasurement>? initialMeasurements})
      : _authService = getIt<AuthService>(),
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        super(initialMeasurements);

  @override
  Future<void> close() {
    _healthMeasurementsListener?.cancel();
    _healthMeasurementsListener = null;
    return super.close();
  }

  Future<void> initialize() async {
    _healthMeasurementsListener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (loggedUserId) => _healthMeasurementRepository.getAllMeasurements(
            userId: loggedUserId,
          ),
        )
        .listen(
      (List<HealthMeasurement>? measurements) {
        List<HealthMeasurement>? sortedMeasurements;
        if (measurements != null) sortedMeasurements = [...measurements];
        sortedMeasurements?.sort(_compareDatesOfMeasurements);
        emit(sortedMeasurements);
      },
    );
  }

  Future<void> deleteMeasurement(DateTime measurementDate) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    await _healthMeasurementRepository.deleteMeasurement(
      userId: loggedUserId,
      date: measurementDate,
    );
  }

  int _compareDatesOfMeasurements(HealthMeasurement m1, HealthMeasurement m2) =>
      m1.date.isBefore(m2.date)
          ? 1
          : m1.date.isAfter(m2.date)
              ? -1
              : 0;
}
