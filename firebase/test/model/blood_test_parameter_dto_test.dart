import 'package:firebase/model/blood_test_parameter_dto.dart';
import 'package:firebase/model/blood_test_parameter_norm_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'bt1';
  const String userId = 'u1';
  const String name = 'blood test 1';
  const String description = 'description';
  const BloodTestParameterDto bloodTestParameterDto = BloodTestParameterDto(
    id: id,
    userId: userId,
    name: name,
    unit: BloodTestParameterUnit.femtolitre,
    norm: BloodTestParameterNormDto(min: 10.0, max: 25.0),
    description: description,
  );
  final Map<String, dynamic> bloodTestParameterJson = {
    'name': name,
    'unit': 'femtolitre',
    'norm': {
      'min': 10.0,
      'max': 25.0,
    },
    'description': description,
  };

  test(
    'from json, '
    'should map json to dto model',
    () {
      final BloodTestParameterDto dto = BloodTestParameterDto.fromJson(
        parameterId: id,
        userId: userId,
        json: bloodTestParameterJson,
      );

      expect(dto, bloodTestParameterDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final Map<String, dynamic> json = bloodTestParameterDto.toJson();

      expect(json, bloodTestParameterJson);
    },
  );
}
