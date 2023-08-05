import 'package:firebase/model/health_measurement_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String userId = 'u1';
  const String dateStr = '2023-1-10';
  final DateTime date = DateTime(2023, 1, 10);
  const int restingHeartRate = 50;
  const double fastingWeight = 50.6;

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'restingHeartRate': restingHeartRate,
        'fastingWeight': fastingWeight,
      };
      final HealthMeasurementDto expectedDto = HealthMeasurementDto(
        userId: userId,
        date: date,
        restingHeartRate: restingHeartRate,
        fastingWeight: fastingWeight,
      );

      final HealthMeasurementDto dto = HealthMeasurementDto.fromJson(
        userId: userId,
        dateStr: dateStr,
        json: json,
      );

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final HealthMeasurementDto dto = HealthMeasurementDto(
        userId: userId,
        date: date,
        restingHeartRate: restingHeartRate,
        fastingWeight: fastingWeight,
      );
      final Map<String, dynamic> expectedJson = {
        'restingHeartRate': restingHeartRate,
        'fastingWeight': fastingWeight,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'resting heart rate is null, '
    'should not include resting heart rate in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'fastingWeight': fastingWeight,
      };

      final Map<String, dynamic> json = createHealthMeasurementJsonToUpdate(
        fastingWeight: fastingWeight,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'fasting weight is null, '
    'should not include fasting weight in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'restingHeartRate': restingHeartRate,
      };

      final Map<String, dynamic> json = createHealthMeasurementJsonToUpdate(
        restingHeartRate: restingHeartRate,
      );

      expect(json, expectedJson);
    },
  );
}
