import 'package:firebase/model/morning_measurement_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String dateStr = '2023-1-10';
  final DateTime date = DateTime(2023, 1, 10);
  const int restingHeartRate = 50;
  const double weight = 50.6;
  final MorningMeasurementDto morningMeasurementDto = MorningMeasurementDto(
    date: date,
    restingHeartRate: restingHeartRate,
    weight: weight,
  );
  final Map<String, dynamic> morningMeasurementJson = {
    'restingHeartRate': restingHeartRate,
    'weight': weight,
  };

  test(
    'from json, '
    'should map json to dto model',
    () {
      final MorningMeasurementDto dto = MorningMeasurementDto.fromJson(
        dateStr,
        morningMeasurementJson,
      );

      expect(dto, morningMeasurementDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final Map<String, dynamic> json = morningMeasurementDto.toJson();

      expect(json, morningMeasurementJson);
    },
  );
}
