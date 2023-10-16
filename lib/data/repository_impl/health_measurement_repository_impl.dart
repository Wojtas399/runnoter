import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';

import '../../common/date_service.dart';
import '../../dependency_injection.dart';
import '../entity/health_measurement.dart';
import '../interface/repository/health_measurement_repository.dart';
import '../mapper/health_measurement_mapper.dart';
import '../model/state_repository.dart';

class HealthMeasurementRepositoryImpl extends StateRepository<HealthMeasurement>
    implements HealthMeasurementRepository {
  final DateService _dateService;
  final FirebaseHealthMeasurementService _dbHealthMeasurementService;

  HealthMeasurementRepositoryImpl({
    super.initialData,
  })  : _dateService = getIt<DateService>(),
        _dbHealthMeasurementService = getIt<FirebaseHealthMeasurementService>();

  @override
  Stream<HealthMeasurement?> getMeasurementByDate({
    required DateTime date,
    required String userId,
  }) async* {
    await for (final measurements in dataStream$) {
      HealthMeasurement? measurement = measurements?.firstWhereOrNull(
        (measurement) =>
            measurement.userId == userId &&
            _dateService.areDaysTheSame(measurement.date, date),
      );
      measurement ??= await _loadMeasurementByDateFromDb(date, userId);
      yield measurement;
    }
  }

  @override
  Stream<List<HealthMeasurement>?> getMeasurementsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async* {
    final measurementsLoadedFromDb =
        await _loadMeasurementsByDateRangeFromDb(startDate, endDate, userId);
    if (measurementsLoadedFromDb?.isNotEmpty == true) {
      addOrUpdateEntities(measurementsLoadedFromDb!);
    }
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
    await _loadAllMeasurementsFromDb(userId);
    await for (final measurements in dataStream$) {
      yield measurements
          ?.where((measurement) => measurement.userId == userId)
          .toList();
    }
  }

  @override
  Future<void> refreshMeasurementsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async {
    final existingMeasurements = await dataStream$.first;
    final measurementsLoadedFromDb =
        await _loadMeasurementsByDateRangeFromDb(startDate, endDate, userId);
    final List<HealthMeasurement> updatedMeasurements = [
      ...?existingMeasurements?.where(
        (measurement) =>
            measurement.userId != userId ||
            !_dateService.isDateFromRange(
              date: measurement.date,
              startDate: startDate,
              endDate: endDate,
            ),
      ),
      ...?measurementsLoadedFromDb,
    ];
    setEntities(updatedMeasurements);
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
                _dateService.areDaysTheSame(measurement.date, date),
          ),
        )
        .first;
    if (measurement != null) {
      return true;
    } else {
      final HealthMeasurement? measurement =
          await _loadMeasurementByDateFromDb(date, userId);
      return measurement != null;
    }
  }

  @override
  Future<void> addMeasurement({
    required HealthMeasurement measurement,
  }) async {
    final HealthMeasurementDto? healthMeasurementDto =
        await _dbHealthMeasurementService.addMeasurement(
      userId: measurement.userId,
      measurementDto: mapHealthMeasurementToDto(measurement),
    );
    if (healthMeasurementDto != null) {
      final HealthMeasurement healthMeasurement =
          mapHealthMeasurementFromDto(healthMeasurementDto);
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
        await _dbHealthMeasurementService.updateMeasurement(
      userId: userId,
      date: date,
      restingHeartRate: restingHeartRate,
      fastingWeight: fastingWeight,
    );
    if (updatedHealthMeasurementDto != null) {
      final HealthMeasurement updatedMeasurement =
          mapHealthMeasurementFromDto(updatedHealthMeasurementDto);
      updateEntity(updatedMeasurement);
    }
  }

  @override
  Future<void> deleteMeasurement({
    required String userId,
    required DateTime date,
  }) async {
    await _dbHealthMeasurementService.deleteMeasurement(
      userId: userId,
      date: date,
    );
    final measurementToDelete = await dataStream$
        .map(
          (measurements) => <HealthMeasurement?>[...?measurements].firstWhere(
            (HealthMeasurement? measurement) =>
                measurement != null &&
                measurement.userId == userId &&
                _dateService.areDaysTheSame(measurement.date, date),
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
    await _dbHealthMeasurementService.deleteAllUserMeasurements(
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

  Future<HealthMeasurement?> _loadMeasurementByDateFromDb(
    DateTime date,
    String userId,
  ) async {
    final HealthMeasurementDto? measurementDto =
        await _dbHealthMeasurementService.loadMeasurementByDate(
      userId: userId,
      date: date,
    );
    if (measurementDto != null) {
      final HealthMeasurement measurement =
          mapHealthMeasurementFromDto(measurementDto);
      addEntity(measurement);
      return measurement;
    }
    return null;
  }

  Future<List<HealthMeasurement>?> _loadMeasurementsByDateRangeFromDb(
    DateTime startDate,
    DateTime endDate,
    String userId,
  ) async {
    final List<HealthMeasurementDto>? measurementDtos =
        await _dbHealthMeasurementService.loadMeasurementsByDateRange(
      startDate: startDate,
      endDate: endDate,
      userId: userId,
    );
    return measurementDtos?.map(mapHealthMeasurementFromDto).toList();
  }

  Future<void> _loadAllMeasurementsFromDb(String userId) async {
    final List<HealthMeasurementDto>? measurementDtos =
        await _dbHealthMeasurementService.loadAllMeasurements(
      userId: userId,
    );
    if (measurementDtos != null) {
      _addDtos(measurementDtos);
    }
  }

  void _addDtos(List<HealthMeasurementDto> dtos) {
    final List<HealthMeasurement> measurements =
        dtos.map(mapHealthMeasurementFromDto).toList();
    addOrUpdateEntities(measurements);
  }
}
