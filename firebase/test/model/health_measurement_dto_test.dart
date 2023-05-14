import 'package:firebase/model/health_measurement_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String dateStr = '2023-1-10';
  final DateTime date = DateTime(2023, 1, 10);
  const int restingHeartRate = 50;
  const double fastingWeight = 50.6;
  final HealthMeasurementDto healthMeasurementDto = HealthMeasurementDto(
    date: date,
    restingHeartRate: restingHeartRate,
    fastingWeight: fastingWeight,
  );
  final Map<String, dynamic> healthMeasurementJson = {
    'restingHeartRate': restingHeartRate,
    'fastingWeight': fastingWeight,
  };

  test(
    'from json, '
    'should map json to dto model',
    () {
      final HealthMeasurementDto dto = HealthMeasurementDto.fromJson(
        dateStr,
        healthMeasurementJson,
      );

      expect(dto, healthMeasurementDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final Map<String, dynamic> json = healthMeasurementDto.toJson();

      expect(json, healthMeasurementJson);
    },
  );
}
