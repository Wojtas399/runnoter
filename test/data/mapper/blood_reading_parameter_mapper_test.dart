import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/blood_reading_parameter_mapper.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_reading.dart';

void main() {
  const BloodReadingParameter parameter = BloodReadingParameter(
    parameter: BloodParameter.wbc,
    readingValue: 4.45,
  );
  const firebase.BloodReadingParameterDto parameterDto =
      firebase.BloodReadingParameterDto(
    parameter: firebase.BloodParameter.wbc,
    readingValue: 4.45,
  );

  test(
    'map blood reading parameter from dto, '
    'should map blood reading parameter dto to domain model',
    () {
      final mappedModel = mapBloodReadingParameterFromDto(parameterDto);

      expect(mappedModel, parameter);
    },
  );

  test(
    'map blood reading parameter to dto, '
    'should map blood reading parameter domain model to dto',
    () {
      final dto = mapBloodReadingParameterToDto(parameter);

      expect(dto, parameterDto);
    },
  );
}
