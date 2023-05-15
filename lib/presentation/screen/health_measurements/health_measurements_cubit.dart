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
        .listen(_emitSortedMeasurements);
  }

  void _emitSortedMeasurements(List<HealthMeasurement>? measurements) {
    List<HealthMeasurement>? sortedMeasurements;
    if (measurements != null) {
      sortedMeasurements = [...measurements];
    }
    sortedMeasurements?.sort(_compareDatesOfMeasurements);
    emit(sortedMeasurements);
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
