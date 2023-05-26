import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/blood_readings_mapper.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_readings.dart';

void main() {
  const String readingsId = 'r1';
  const String userId = 'u1';
  final DateTime date = DateTime(2023, 5, 14);
  final BloodReadings readings = BloodReadings(
    id: readingsId,
    userId: userId,
    date: date,
    readings: const [
      BloodParameterReading(
        parameter: BloodParameter.wbc,
        readingValue: 4.45,
      ),
      BloodParameterReading(
        parameter: BloodParameter.ldl,
        readingValue: 78,
      ),
    ],
  );
  final firebase.BloodReadingsDto readingsDto = firebase.BloodReadingsDto(
    id: readingsId,
    userId: userId,
    date: date,
    readingDtos: const [
      firebase.BloodParameterReadingDto(
        parameter: firebase.BloodParameter.wbc,
        readingValue: 4.45,
      ),
      firebase.BloodParameterReadingDto(
        parameter: firebase.BloodParameter.ldl,
        readingValue: 78,
      ),
    ],
  );

  test(
    'map blood readings from dto, '
    'should map blood readings from dto to domain model',
    () {
      final mappedModel = mapBloodReadingsFromDto(readingsDto);

      expect(mappedModel, readings);
    },
  );
}
