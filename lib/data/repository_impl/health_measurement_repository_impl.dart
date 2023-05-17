import 'package:firebase/firebase.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/date_service.dart';
import '../../domain/model/health_measurement.dart';
import '../../domain/model/state_repository.dart';
import '../../domain/repository/health_measurement_repository.dart';
import '../mapper/health_measurement_mapper.dart';

class HealthMeasurementRepositoryImpl extends StateRepository<HealthMeasurement>
    implements HealthMeasurementRepository {
  final DateService _dateService;
  final FirebaseHealthMeasurementService _firebaseHealthMeasurementService;

  HealthMeasurementRepositoryImpl({
    required DateService dateService,
    required FirebaseHealthMeasurementService firebaseHealthMeasurementService,
    List<HealthMeasurement>? initialState,
  })  : _dateService = dateService,
        _firebaseHealthMeasurementService = firebaseHealthMeasurementService,
        super(initialData: initialState);

  @override
  Stream<HealthMeasurement?> getMeasurementByDate({
    required DateTime date,
    required String userId,
  }) =>
      dataStream$
          .map(
            (List<HealthMeasurement>? measurements) =>
                <HealthMeasurement?>[...?measurements].firstWhere(
              (HealthMeasurement? measurement) => measurement != null
                  ? measurement.userId == userId &&
                      _dateService.areDatesTheSame(measurement.date, date)
                  : false,
              orElse: () => null,
            ),
          )
          .doOnListen(
            () async =>
                await _doesMeasurementWithGivenDateNotExist(date, userId)
                    ? _loadMeasurementByDateFromRemoteDb(date, userId)
                    : null,
          );

  @override
  Stream<List<HealthMeasurement>?> getMeasurementsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) =>
      dataStream$
          .map(
            (List<HealthMeasurement>? measurements) => measurements
                ?.where(
                  (measurement) =>
                      measurement.userId == userId &&
                      _dateService.isDateFromRange(
                        date: measurement.date,
                        startDate: startDate,
                        endDate: endDate,
                      ),
                )
                .toList(),
          )
          .doOnListen(
            () => _loadMeasurementsByDateRangeFromRemoteDb(
              startDate,
              endDate,
              userId,
            ),
          );

  @override
  Stream<List<HealthMeasurement>?> getAllMeasurements({
    required String userId,
  }) =>
      dataStream$
          .map(
            (List<HealthMeasurement>? measurements) => measurements
                ?.where((measurement) => measurement.userId == userId)
                .toList(),
          )
          .doOnListen(
            () => _loadAllMeasurementsFromRemoteDb(userId),
          );

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

  Future<bool> _doesMeasurementWithGivenDateNotExist(
    DateTime date,
    String userId,
  ) async {
    final List<HealthMeasurement>? measurements = await dataStream$.first;
    if (measurements == null) {
      return true;
    }
    for (final measurement in measurements) {
      if (_dateService.areDatesTheSame(measurement.date, date) &&
          measurement.userId == userId) {
        return false;
      }
    }
    return true;
  }

  Future<void> _loadMeasurementByDateFromRemoteDb(
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
    }
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
