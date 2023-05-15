import 'package:firebase/model/health_measurement_dto.dart';
import 'package:firebase/service/firebase_health_measurement_service.dart';
import 'package:mocktail/mocktail.dart';

class _FakeHealthMeasurementDto extends Fake implements HealthMeasurementDto {}

class MockFirebaseHealthMeasurementService extends Mock
    implements FirebaseHealthMeasurementService {
  void mockLoadMeasurementByDate({
    HealthMeasurementDto? healthMeasurementDto,
  }) {
    when(
      () => loadMeasurementByDate(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((invocation) => Future.value(healthMeasurementDto));
  }

  void mockLoadMeasurementsByDateRange({
    List<HealthMeasurementDto>? healthMeasurementDtos,
  }) {
    when(
      () => loadMeasurementsByDateRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(healthMeasurementDtos));
  }

  void mockLoadAllMeasurements({
    List<HealthMeasurementDto>? healthMeasurementDtos,
  }) {
    when(
      () => loadAllMeasurements(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(healthMeasurementDtos));
  }

  void mockAddMeasurement({
    HealthMeasurementDto? addedMeasurementDto,
  }) {
    _mockHealthMeasurementDto();
    when(
      () => addMeasurement(
        userId: any(named: 'userId'),
        measurementDto: any(named: 'measurementDto'),
      ),
    ).thenAnswer((invocation) => Future.value(addedMeasurementDto));
  }

  void mockUpdateMeasurement({
    HealthMeasurementDto? updatedMeasurementDto,
  }) {
    when(
      () => updateMeasurement(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        restingHeartRate: any(named: 'restingHeartRate'),
        fastingWeight: any(named: 'fastingWeight'),
      ),
    ).thenAnswer((invocation) => Future.value(updatedMeasurementDto));
  }

  void _mockHealthMeasurementDto() {
    registerFallbackValue(_FakeHealthMeasurementDto());
  }
}
