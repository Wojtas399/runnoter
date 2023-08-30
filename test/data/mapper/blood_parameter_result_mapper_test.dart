import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/blood_parameter_result_mapper.dart';
import 'package:runnoter/domain/additional_model/blood_parameter.dart';

void main() {
  const BloodParameterResult parameterResult = BloodParameterResult(
    parameter: BloodParameter.wbc,
    value: 4.45,
  );
  const firebase.BloodParameterResultDto parameterResultDto =
      firebase.BloodParameterResultDto(
    parameter: firebase.BloodParameter.wbc,
    value: 4.45,
  );

  test(
    'map blood parameter result from dto, '
    'should map blood parameter result dto to domain model',
    () {
      final mappedModel = mapBloodParameterResultFromDto(parameterResultDto);

      expect(mappedModel, parameterResult);
    },
  );

  test(
    'map blood parameter result to dto, '
    'should map blood parameter result domain model to dto',
    () {
      final dto = mapBloodParameterResultToDto(parameterResult);

      expect(dto, parameterResultDto);
    },
  );
}
