import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';

import '../../common/date_service.dart';
import '../../dependency_injection.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/health_measurement.dart';
import '../../domain/repository/health_measurement_repository.dart';
import '../mapper/health_measurement_mapper.dart';

class HealthMeasurementRepositoryImpl extends StateRepository<HealthMeasurement>
    implements HealthMeasurementRepository {
  final DateService _dateService;
  final FirebaseHealthMeasurementService _firebaseHealthMeasurementService;

  HealthMeasurementRepositoryImpl({
    required FirebaseHealthMeasurementService firebaseHealthMeasurementService,
    List<HealthMeasurement>? initialState,
  })  : _dateService = getIt<DateService>(),
        _firebaseHealthMeasurementService = firebaseHealthMeasurementService,
        super(initialData: initialState);

  @override
  Stream<HealthMeasurement?> getMeasurementByDate({
    required DateTime date,
    required String userId,
  }) async* {
    await for (final measurements in dataStream$) {
      HealthMeasurement? measurement = measurements?.firstWhereOrNull(
        (measurement) =>
            measurement.userId == userId &&
            _dateService.areDatesTheSame(measurement.date, date),
      );
      measurement ??= await _loadMeasurementByDateFromRemoteDb(date, userId);
      yield measurement;
    }
  }

  @override
  Stream<List<HealthMeasurement>?> getMeasurementsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async* {
    await _loadMeasurementsByDateRangeFromRemoteDb(startDate, endDate, userId);
    await for (final measurements in dataStream$) {
      yield measurements
          ?.where(
            (measurement) =>
                measurement.userId == userId &&
                _dateService.isDateFromRange(
                  date: measurement.date,
                  startDate: startDate,
                  endDate: endDate,
                ),
          )
          .toList();
    }
  }

  @override
  Stream<List<HealthMeasurement>?> getAllMeasurements({
    required String userId,
  }) async* {
    await _loadAllMeasurementsFromRemoteDb(userId);
    await for (final measurements in dataStream$) {
      yield measurements
          ?.where((measurement) => measurement.userId == userId)
          .toList();
    }
  }

  @override
  Future<bool> doesMeasurementFromDateExist({
    required String userId,
    required DateTime date,
  }) async {
    final HealthMeasurement? measurement = await dataStream$
        .map(
          (measurements) => measurements?.firstWhereOrNull(
            (measurement) =>
                measurement.userId == userId &&
                _dateService.areDatesTheSame(measurement.date, date),
          ),
        )
        .first;
    if (measurement != null) {
      return true;
    } else {
      final HealthMeasurement? measurement =
          await _loadMeasurementByDateFromRemoteDb(date, userId);
      return measurement != null;
    }
  }

  @override
  Future<void> addMeasurement({
    required HealthMeasurement measurement,
  }) async {
    final HealthMeasurementDto? healthMeasurementDto =
        await _firebaseHealthMeasurementService.addMeasurement(
      userId: measurement.userId,
      measurementDto: mapHealthMeasurementToFirebase(measurement),
    );
    if (healthMeasurementDto != null) {
      final HealthMeasurement healthMeasurement =
          mapHealthMeasurementFromFirebase(healthMeasurementDto);
      addEntity(healthMeasurement);
    }
  }

  @override
  Future<void> updateMeasurement({
    required String userId,
    required DateTime date,
    int? restingHeartRate,
    double? fastingWeight,
  }) async {
    final HealthMeasurementDto? updatedHealthMeasurementDto =
        await _firebaseHealthMeasurementService.updateMeasurement(
      userId: userId,
      date: date,
      restingHeartRate: restingHeartRate,
      fastingWeight: fastingWeight,
    );
    if (updatedHealthMeasurementDto != null) {
      final HealthMeasurement updatedMeasurement =
          mapHealthMeasurementFromFirebase(updatedHealthMeasurementDto);
      updateEntity(updatedMeasurement);
    }
  }

  @override
  Future<void> deleteMeasurement({
    required String userId,
    required DateTime date,
  }) async {
    await _firebaseHealthMeasurementService.deleteMeasurement(
      userId: userId,
      date: date,
    );
    final measurementToDelete = await dataStream$
        .map(
          (measurements) => <HealthMeasurement?>[...?measurements].firstWhere(
            (HealthMeasurement? measurement) =>
                measurement != null &&
                measurement.userId == userId &&
                _dateService.areDatesTheSame(measurement.date, date),
            orElse: () => null,
          ),
        )
        .first;
    if (measurementToDelete != null) {
      removeEntity(measurementToDelete.id);
    }
  }

  @override
  Future<void> deleteAllUserMeasurements({
    required String userId,
  }) async {
    await _firebaseHealthMeasurementService.deleteAllUserMeasurements(
      userId: userId,
    );
    final repositoryState = await dataStream$.first;
    final List<String> idsOfUserMeasurements = [
      ...?repositoryState
          ?.where((measurement) => measurement.userId == userId)
          .map((measurement) => measurement.id)
          .toList(),
    ];
    removeEntities(idsOfUserMeasurements);
  }

  Future<HealthMeasurement?> _loadMeasurementByDateFromRemoteDb(
    DateTime date,
    String userId,
  ) async {
    final HealthMeasurementDto? measurementDto =
        await _firebaseHealthMeasurementService.loadMeasurementByDate(
      userId: userId,
      date: date,
    );
    if (measurementDto != null) {
      final HealthMeasurement measurement = mapHealthMeasurementFromFirebase(
        measurementDto,
      );
      addEntity(measurement);
      return measurement;
    }
    return null;
  }

  Future<void> _loadMeasurementsByDateRangeFromRemoteDb(
    DateTime startDate,
    DateTime endDate,
    String userId,
  ) async {
    final List<HealthMeasurementDto>? measurementDtos =
        await _firebaseHealthMeasurementService.loadMeasurementsByDateRange(
      startDate: startDate,
      endDate: endDate,
      userId: userId,
    );
    if (measurementDtos != null) {
      _addDtos(measurementDtos);
    }
  }

  Future<void> _loadAllMeasurementsFromRemoteDb(String userId) async {
    final List<HealthMeasurementDto>? measurementDtos =
        await _firebaseHealthMeasurementService.loadAllMeasurements(
      userId: userId,
    );
    if (measurementDtos != null) {
      _addDtos(measurementDtos);
    }
  }

  void _addDtos(List<HealthMeasurementDto> dtos) {
    final List<HealthMeasurement> measurements =
        dtos.map(mapHealthMeasurementFromFirebase).toList();
    addEntities(measurements);
  }
}
