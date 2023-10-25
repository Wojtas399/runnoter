import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/model/health_measurement.dart';
import 'package:runnoter/data/repository/health_measurement/health_measurement_repository.dart';

class _FakeHealthMeasurement extends Fake implements HealthMeasurement {}

class MockHealthMeasurementRepository extends Mock
    implements HealthMeasurementRepository {
  MockHealthMeasurementRepository() {
    registerFallbackValue(_FakeHealthMeasurement());
  }

  void mockGetMeasurementByDate({
    HealthMeasurement? measurement,
    Stream<HealthMeasurement?>? measurementStream,
  }) {
    when(
      () => getMeasurementByDate(
        date: any(named: 'date'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => measurementStream ?? Stream.value(measurement));
  }

  void mockGetMeasurementsByDateRange({
    List<HealthMeasurement>? measurements,
    Stream<List<HealthMeasurement>?>? measurementsStream,
  }) {
    when(
      () => getMeasurementsByDateRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => measurementsStream ?? Stream.value(measurements));
  }

  void mockGetAllMeasurements({
    List<HealthMeasurement>? measurements,
  }) {
    when(
      () => getAllMeasurements(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(measurements));
  }

  void mockRefreshMeasurementsByDateRange() {
    when(
      () => refreshMeasurementsByDateRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDoesMeasurementFromDateExist({
    required bool expected,
  }) {
    when(
      () => doesMeasurementFromDateExist(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((_) => Future.value(expected));
  }

  void mockAddMeasurement() {
    when(
      () => addMeasurement(
        measurement: any(named: 'measurement'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockUpdateMeasurement() {
    when(
      () => updateMeasurement(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        restingHeartRate: any(named: 'restingHeartRate'),
        fastingWeight: any(named: 'fastingWeight'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteMeasurement() {
    when(
      () => deleteMeasurement(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteAllUserMeasurements() {
    when(
      () => deleteAllUserMeasurements(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
