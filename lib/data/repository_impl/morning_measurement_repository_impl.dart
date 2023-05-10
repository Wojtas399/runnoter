import 'package:firebase/firebase.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/date_service.dart';
import '../../domain/model/morning_measurement.dart';
import '../../domain/model/state_repository.dart';
import '../../domain/repository/morning_measurement_repository.dart';
import '../mapper/morning_measurement_mapper.dart';

class MorningMeasurementRepositoryImpl
    extends StateRepository<MorningMeasurement>
    implements MorningMeasurementRepository {
  final DateService _dateService;
  final FirebaseMorningMeasurementService _firebaseMorningMeasurementService;

  MorningMeasurementRepositoryImpl({
    required DateService dateService,
    required FirebaseMorningMeasurementService
        firebaseMorningMeasurementService,
    List<MorningMeasurement>? initialState,
  })  : _dateService = dateService,
        _firebaseMorningMeasurementService = firebaseMorningMeasurementService,
        super(initialData: initialState);

  @override
  Stream<MorningMeasurement?> getMeasurementByDate({
    required DateTime date,
    required String userId,
  }) =>
      dataStream$
          .map(
            (List<MorningMeasurement>? measurements) =>
                <MorningMeasurement?>[...?measurements].firstWhere(
              (MorningMeasurement? measurement) => measurement != null
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
  Stream<List<MorningMeasurement>?> getMeasurementsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) =>
      dataStream$
          .map(
            (List<MorningMeasurement>? measurements) => measurements
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
    required MorningMeasurement measurement,
  }) async {
    final MorningMeasurementDto? morningMeasurementDto =
        await _firebaseMorningMeasurementService.addMeasurement(
      userId: userId,
      measurementDto: mapMorningMeasurementToFirebase(measurement),
    );
    if (morningMeasurementDto != null) {
      final MorningMeasurement morningMeasurement =
          mapMorningMeasurementFromFirebase(morningMeasurementDto);
      addEntity(morningMeasurement);
    }
  }

  Future<bool> _doesMeasurementWithGivenDateNotExist(DateTime date) async {
    final List<MorningMeasurement>? measurements = await dataStream$.first;
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
    final MorningMeasurementDto? measurementDto =
        await _firebaseMorningMeasurementService.loadMeasurementByDate(
      userId: userId,
      date: date,
    );
    if (measurementDto != null) {
      final MorningMeasurement measurement = mapMorningMeasurementFromFirebase(
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
    final List<MorningMeasurementDto>? measurementDtos =
        await _firebaseMorningMeasurementService.loadMeasurementsByDateRange(
      startDate: startDate,
      endDate: endDate,
      userId: userId,
    );
    if (measurementDtos != null) {
      final List<MorningMeasurement> measurements = measurementDtos
          .map((dto) => mapMorningMeasurementFromFirebase(dto))
          .toList();
      addEntities(measurements);
    }
  }
}
