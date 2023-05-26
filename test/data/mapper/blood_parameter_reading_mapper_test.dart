import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/blood_parameter_reading_mapper.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_readings.dart';

void main() {
  const BloodParameterReading parameterReading = BloodParameterReading(
    parameter: BloodParameter.wbc,
    readingValue: 4.45,
  );
  const firebase.BloodParameterReadingDto parameterReadingDto =
      firebase.BloodParameterReadingDto(
    parameter: firebase.BloodParameter.wbc,
    readingValue: 4.45,
  );

  test(
    'map blood parameter reading from dto, '
    'should map blood parameter reading dto to domain model',
    () {
      final mappedModel = mapBloodParameterReadingFromDto(parameterReadingDto);

      expect(mappedModel, parameterReading);
    },
  );

  test(
    'map blood parameter to dto, '
    'should map blood parameter reading from domain model to dto',
    () {
      final dto = mapBloodParameterReadingToDto(parameterReading);

      expect(dto, parameterReadingDto);
    },
  );
}
