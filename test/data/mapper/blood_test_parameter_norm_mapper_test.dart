import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/blood_test_parameter_norm_mapper.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';

void main() {
  const BloodParameterNorm domainModel = BloodParameterNorm(
    min: 0,
    max: 1,
  );
  const BloodParameterNormDto dto = BloodParameterNormDto(
    min: 0,
    max: 1,
  );

  test(
    'map blood test parameter norm from dto, '
    'should map dto model to domain model',
    () {
      final BloodParameterNorm model = mapBloodParameterNormFromDto(dto);

      expect(model, domainModel);
    },
  );
}
