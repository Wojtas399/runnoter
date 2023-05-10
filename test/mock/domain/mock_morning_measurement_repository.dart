import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/morning_measurement.dart';
import 'package:runnoter/domain/repository/morning_measurement_repository.dart';

class _FakeMorningMeasurement extends Fake implements MorningMeasurement {}

class MockMorningMeasurementRepository extends Mock
    implements MorningMeasurementRepository {
  void mockGetMeasurementByDate({
    MorningMeasurement? measurement,
  }) {
    when(
      () => getMeasurementByDate(
        date: any(named: 'date'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(measurement));
  }

  void mockAddMeasurement() {
    _mockMorningMeasurement();
    when(
      () => addMeasurement(
        userId: any(named: 'userId'),
        measurement: any(named: 'measurement'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void _mockMorningMeasurement() {
    registerFallbackValue(_FakeMorningMeasurement());
  }
}
