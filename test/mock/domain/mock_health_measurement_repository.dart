import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/health_measurement.dart';
import 'package:runnoter/domain/repository/health_measurement_repository.dart';

class _FakeHealthMeasurement extends Fake implements HealthMeasurement {}

class MockHealthMeasurementRepository extends Mock
    implements HealthMeasurementRepository {
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

  void mockAddMeasurement() {
    _mockHealthMeasurement();
    when(
      () => addMeasurement(
        userId: any(named: 'userId'),
        measurement: any(named: 'measurement'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void _mockHealthMeasurement() {
    registerFallbackValue(_FakeHealthMeasurement());
  }
}
