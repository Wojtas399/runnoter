import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const BloodParameterResultDto parameterResultDto = BloodParameterResultDto(
    parameter: BloodParameter.wbc,
    value: 4.42,
  );
  final Map<String, dynamic> parameterResultJson = {
    'parameter': 'wbc',
    'value': 4.42,
  };

  test(
    'from json, '
    'should json to dto',
    () {
      final BloodParameterResultDto dto = BloodParameterResultDto.fromJson(
        parameterResultJson,
      );

      expect(dto, parameterResultDto);
    },
  );

  test(
    'to json, '
    'should map dto to json',
    () {
      final Map<String, dynamic> json = parameterResultDto.toJson();

      expect(json, parameterResultJson);
    },
  );
}
