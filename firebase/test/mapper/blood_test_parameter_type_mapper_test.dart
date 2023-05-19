import 'package:firebase/mapper/blood_test_parameter_type_mapper.dart';
import 'package:firebase/model/blood_test_parameter_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map blood test parameter type to string, '
    'type basic',
    () {
      const BloodTestParameterType type = BloodTestParameterType.basic;
      const String expectedStr = 'basic';

      final String str = mapBloodTestParameterTypeToString(type);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter type to string, '
    'type additional',
    () {
      const BloodTestParameterType type = BloodTestParameterType.additional;
      const String expectedStr = 'additional';

      final String str = mapBloodTestParameterTypeToString(type);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter type from string, '
    'type basic',
    () {
      const String str = 'basic';
      const BloodTestParameterType expectedType = BloodTestParameterType.basic;

      final BloodTestParameterType type =
          mapBloodTestParameterTypeFromString(str);

      expect(type, expectedType);
    },
  );

  test(
    'map blood test parameter type from string, '
    'type additional',
    () {
      const String str = 'additional';
      const BloodTestParameterType expectedType =
          BloodTestParameterType.additional;

      final BloodTestParameterType type =
          mapBloodTestParameterTypeFromString(str);

      expect(type, expectedType);
    },
  );
}
