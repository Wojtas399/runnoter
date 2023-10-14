import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/health_measurement.dart';
import 'package:runnoter/data/mapper/health_measurement_mapper.dart';

void main() {
  const String userId = 'u1';
  final DateTime date = DateTime(2023, 1, 10);
  const int restingHeartRate = 50;
  const double fastingWeight = 50.9;
  final HealthMeasurement healthMeasurement = HealthMeasurement(
    userId: userId,
    date: date,
    restingHeartRate: restingHeartRate,
    fastingWeight: fastingWeight,
  );
  final HealthMeasurementDto healthMeasurementDto = HealthMeasurementDto(
    userId: userId,
    date: date,
    restingHeartRate: restingHeartRate,
    fastingWeight: fastingWeight,
  );

  test(
    'mapHealthMeasurementToDto, '
    'should map health measurement to dto model',
    () {
      final HealthMeasurementDto dto =
          mapHealthMeasurementToDto(healthMeasurement);

      expect(dto, healthMeasurementDto);
    },
  );

  test(
    'mapHealthMeasurementFromDto, '
    'should map health measurement dto model to domain model',
    () {
      final HealthMeasurement model =
          mapHealthMeasurementFromDto(healthMeasurementDto);

      expect(model, healthMeasurement);
    },
  );
}
