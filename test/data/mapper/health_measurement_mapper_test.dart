import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/health_measurement_mapper.dart';
import 'package:runnoter/domain/model/health_measurement.dart';

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
    'map health measurement to firebase, '
    'should map health measurement to dto model',
    () {
      final HealthMeasurementDto dto = mapHealthMeasurementToFirebase(
        healthMeasurement,
      );

      expect(dto, healthMeasurementDto);
    },
  );

  test(
    'map health measurement from firebase, '
    'should map health measurement firebase dto model to domain model',
    () {
      final HealthMeasurement model = mapHealthMeasurementFromFirebase(
        healthMeasurementDto,
      );

      expect(model, healthMeasurement);
    },
  );
}
