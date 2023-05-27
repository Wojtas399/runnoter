import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const BloodReadingParameterDto parameterDto = BloodReadingParameterDto(
    parameter: BloodParameter.wbc,
    readingValue: 4.42,
  );
  final Map<String, dynamic> parameterJson = {
    'parameter': 'wbc',
    'readingValue': 4.42,
  };

  test(
    'from json, '
    'should json to dto',
    () {
      final BloodReadingParameterDto dto = BloodReadingParameterDto.fromJson(
        parameterJson,
      );

      expect(dto, parameterDto);
    },
  );

  test(
    'to json, '
    'should map dto to json',
    () {
      final Map<String, dynamic> json = parameterDto.toJson();

      expect(json, parameterJson);
    },
  );
}
