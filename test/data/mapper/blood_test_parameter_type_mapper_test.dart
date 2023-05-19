import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/blood_test_parameter_type_mapper.dart';
import 'package:runnoter/domain/model/blood_test_parameter.dart';

void main() {
  test(
    'map blood test parameter type from dto, '
    'type basic, '
    'should map dto type to domain type',
    () {
      const dtoType = firebase.BloodTestParameterType.basic;
      const domainType = BloodTestParameterType.basic;

      final BloodTestParameterType type =
          mapBloodTestParameterTypeFromDto(dtoType);

      expect(type, domainType);
    },
  );

  test(
    'map blood test parameter type from dto, '
    'type additional, '
    'should map dto type to domain type',
    () {
      const dtoType = firebase.BloodTestParameterType.additional;
      const domainType = BloodTestParameterType.additional;

      final BloodTestParameterType type =
          mapBloodTestParameterTypeFromDto(dtoType);

      expect(type, domainType);
    },
  );
}
