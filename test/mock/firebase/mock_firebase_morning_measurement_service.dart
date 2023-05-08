import 'package:firebase/model/morning_measurement_dto.dart';
import 'package:firebase/service/firebase_morning_measurement_service.dart';
import 'package:mocktail/mocktail.dart';

class _FakeMorningMeasurementDto extends Fake
    implements MorningMeasurementDto {}

class MockFirebaseMorningMeasurementService extends Mock
    implements FirebaseMorningMeasurementService {
  void mockAddMeasurement({
    MorningMeasurementDto? addedMeasurementDto,
  }) {
    _mockMorningMeasurementDto();
    when(
      () => addMeasurement(
        userId: any(named: 'userId'),
        measurementDto: any(named: 'measurementDto'),
      ),
    ).thenAnswer((invocation) => Future.value(addedMeasurementDto));
  }

  void _mockMorningMeasurementDto() {
    registerFallbackValue(_FakeMorningMeasurementDto());
  }
}
