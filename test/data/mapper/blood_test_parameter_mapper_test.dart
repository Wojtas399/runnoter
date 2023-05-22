import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/blood_test_parameter_mapper.dart';
import 'package:runnoter/domain/model/blood_test_parameter.dart';

void main() {
  const String id = 'p1';
  const String name = 'parameter 1';
  const dto = firebase.BloodTestParameterDto(
    id: id,
    type: firebase.BloodTestParameterType.basic,
    name: name,
    unit: firebase.BloodTestParameterUnit.femtolitre,
    norm: firebase.BloodTestParameterNormDto(min: 2, max: 5.0),
  );
  const entity = BloodTestParameter(
    id: id,
    type: BloodTestParameterType.basic,
    name: name,
    unit: BloodTestParameterUnit.femtolitre,
    norm: BloodTestParameterNorm(min: 2, max: 5.0),
  );

  test(
    'map blood test parameter from dto, '
    'should map dto model to domain entity model',
    () {
      final BloodTestParameter mappedModel = mapBloodTestParameterFromDto(dto);

      expect(mappedModel, entity);
    },
  );
}
