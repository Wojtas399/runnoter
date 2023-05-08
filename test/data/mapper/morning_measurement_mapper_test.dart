import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/morning_measurement_mapper.dart';
import 'package:runnoter/domain/model/morning_measurement.dart';

void main() {
  final DateTime date = DateTime(2023, 1, 10);
  const int restingHeartRate = 50;
  const double weight = 50.9;
  final MorningMeasurement morningMeasurement = MorningMeasurement(
    date: date,
    restingHeartRate: restingHeartRate,
    weight: weight,
  );
  final MorningMeasurementDto morningMeasurementDto = MorningMeasurementDto(
    date: date,
    restingHeartRate: restingHeartRate,
    weight: weight,
  );

  test(
    'map morning measurement to firebase, '
    'should map morning measurement to dto model',
    () {
      final MorningMeasurementDto dto = mapMorningMeasurementToFirebase(
        morningMeasurement,
      );

      expect(dto, morningMeasurementDto);
    },
  );

  test(
    'map morning measurement from firebase, '
    'should map morning measurement firebase dto model to domain model',
    () {
      final MorningMeasurement model = mapMorningMeasurementFromFirebase(
        morningMeasurementDto,
      );

      expect(model, morningMeasurement);
    },
  );
}
