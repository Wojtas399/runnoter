import 'package:rxdart/rxdart.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/additional_model/cubit_status.dart';
import '../../../../domain/entity/health_measurement.dart';
import '../../../../domain/repository/health_measurement_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_with_status.dart';

part 'health_measurement_creator_state.dart';

class HealthMeasurementCreatorCubit extends CubitWithStatus<
    HealthMeasurementCreatorState,
    HealthMeasurementCreatorCubitInfo,
    HealthMeasurementCreatorCubitError> {
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;

  HealthMeasurementCreatorCubit({
    HealthMeasurementCreatorState? initialState,
  })  : _authService = getIt<AuthService>(),
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        super(
          initialState ??
              HealthMeasurementCreatorState(status: const CubitStatusInitial()),
        );

  Future<void> initialize(DateTime? date) async {
    if (date == null) {
      emitCompleteStatus();
      return;
    }
    final Stream<HealthMeasurement?> measurement$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) =>
                  _healthMeasurementRepository.getMeasurementByDate(
                date: date,
                userId: loggedUserId,
              ),
            );
    await for (final measurement in measurement$) {
      emit(state.copyWith(
        date: date,
        measurement: measurement,
        restingHeartRate: measurement?.restingHeartRate,
        fastingWeight: measurement?.fastingWeight,
      ));
      return;
    }
  }

  void dateChanged(DateTime date) {
    emit(state.copyWith(date: date));
  }

  void restingHeartRateChanged(int restingHeartRate) {
    emit(state.copyWith(restingHeartRate: restingHeartRate));
  }

  void fastingWeightChanged(double fastingWeight) {
    emit(state.copyWith(fastingWeight: fastingWeight));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emitLoadingStatus();
    if (state.date == state.measurement?.date) {
      await _updateMeasurement(loggedUserId);
      emitCompleteStatus(
        info: HealthMeasurementCreatorCubitInfo.measurementUpdated,
      );
    } else if (await _healthMeasurementRepository.doesMeasurementFromDateExist(
      userId: loggedUserId,
      date: state.date!,
    )) {
      emitErrorStatus(
        HealthMeasurementCreatorCubitError
            .measurementWithSelectedDateAlreadyExist,
      );
    } else {
      await _addMeasurement(loggedUserId);
      if (state.measurement != null) {
        await _deleteOriginalMeasurement(loggedUserId);
        emitCompleteStatus(
          info: HealthMeasurementCreatorCubitInfo.measurementUpdated,
        );
        return;
      }
      emitCompleteStatus(
        info: HealthMeasurementCreatorCubitInfo.measurementAdded,
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

enum HealthMeasurementCreatorCubitInfo { measurementAdded, measurementUpdated }

enum HealthMeasurementCreatorCubitError {
  measurementWithSelectedDateAlreadyExist
}
