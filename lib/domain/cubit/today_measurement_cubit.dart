import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/date_service.dart';
import '../../dependency_injection.dart';
import '../entity/health_measurement.dart';
import '../repository/health_measurement_repository.dart';
import '../service/auth_service.dart';

class TodayMeasurementCubit extends Cubit<HealthMeasurement?> {
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final DateService _dateService;
  StreamSubscription<HealthMeasurement?>? _todayMeasurementListener;

  TodayMeasurementCubit({HealthMeasurement? initialTodayMeasurement})
      : _authService = getIt<AuthService>(),
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _dateService = getIt<DateService>(),
        super(initialTodayMeasurement);

  @override
  Future<void> close() {
    _todayMeasurementListener?.cancel();
    _todayMeasurementListener = null;
    return super.close();
  }

  void initialize() {
    _todayMeasurementListener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (loggedUserId) => _healthMeasurementRepository.getMeasurementByDate(
            date: _dateService.getToday(),
            userId: loggedUserId,
          ),
        )
        .listen(
          (HealthMeasurement? todayMeasurement) => emit(todayMeasurement),
        );
  }

  Future<void> deleteTodayMeasurement() async {
    if (state != null) {
      await _healthMeasurementRepository.deleteMeasurement(
        userId: state!.userId,
        date: state!.date,
      );
    }
  }
}
