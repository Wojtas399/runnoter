import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const BloodParameterReadingDto parameterReadingDto = BloodParameterReadingDto(
    parameter: BloodParameter.wbc,
    readingValue: 4.42,
  );
  final Map<String, dynamic> parameterReadingJson = {
    'parameter': 'wbc',
    'readingValue': 4.42,
  };

  test(
    'from json, '
    'should json to dto',
    () {
      final BloodParameterReadingDto dto = BloodParameterReadingDto.fromJson(
        parameterReadingJson,
      );

      expect(dto, parameterReadingDto);
    },
  );

  test(
    'to json, '
    'should map dto to json',
    () {
      final Map<String, dynamic> json = parameterReadingDto.toJson();

      expect(json, parameterReadingJson);
    },
  );
}
