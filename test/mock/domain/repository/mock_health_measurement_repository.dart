import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';
import 'package:runnoter/domain/repository/health_measurement_repository.dart';

class _FakeHealthMeasurement extends Fake implements HealthMeasurement {}

class MockHealthMeasurementRepository extends Mock
    implements HealthMeasurementRepository {
  MockHealthMeasurementRepository() {
    registerFallbackValue(_FakeHealthMeasurement());
  }

  void mockGetMeasurementByDate({
    HealthMeasurement? measurement,
  }) {
    when(
      () => getMeasurementByDate(
        date: any(named: 'date'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(measurement));
  }

  void mockGetMeasurementsByDateRange({
    List<HealthMeasurement>? measurements,
  }) {
    when(
      () => getMeasurementsByDateRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(measurements));
  }

  void mockGetAllMeasurements({
    List<HealthMeasurement>? measurements,
  }) {
    when(
      () => getAllMeasurements(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(measurements));
  }

  void mockAddMeasurement() {
    when(
      () => addMeasurement(
        measurement: any(named: 'measurement'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockUpdateMeasurement() {
    when(
      () => updateMeasurement(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        restingHeartRate: any(named: 'restingHeartRate'),
        fastingWeight: any(named: 'fastingWeight'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockDeleteMeasurement() {
    when(
      () => deleteMeasurement(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockDeleteAllUserMeasurements() {
    when(
      () => deleteAllUserMeasurements(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }
}
