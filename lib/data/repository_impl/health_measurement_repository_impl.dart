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
                  ? _dateService.areDatesTheSame(measurement.date, date)
                  : false,
              orElse: () => null,
            ),
          )
          .doOnListen(
            () async => await _doesMeasurementWithGivenDateNotExist(date)
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
                  (measurement) => _dateService.isDateFromRange(
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
  Future<void> addMeasurement({
    required String userId,
    required HealthMeasurement measurement,
  }) async {
    final HealthMeasurementDto? healthMeasurementDto =
        await _firebaseHealthMeasurementService.addMeasurement(
      userId: userId,
      measurementDto: mapHealthMeasurementToFirebase(measurement),
    );
    if (healthMeasurementDto != null) {
      final HealthMeasurement healthMeasurement =
          mapHealthMeasurementFromFirebase(healthMeasurementDto);
      addEntity(healthMeasurement);
    }
  }

  Future<bool> _doesMeasurementWithGivenDateNotExist(DateTime date) async {
    final List<HealthMeasurement>? measurements = await dataStream$.first;
    if (measurements == null) {
      return true;
    }
    for (final measurement in measurements) {
      if (_dateService.areDatesTheSame(measurement.date, date)) {
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
      final List<HealthMeasurement> measurements = measurementDtos
          .map((dto) => mapHealthMeasurementFromFirebase(dto))
          .toList();
      addEntities(measurements);
    }
  }
}
