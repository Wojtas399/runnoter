import 'package:firebase/model/blood_test_parameter_norm_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/blood_test_parameter_norm_mapper.dart';
import 'package:runnoter/domain/model/blood_test_parameter.dart';

void main() {
  const BloodTestParameterNorm domainModel = BloodTestParameterNorm(
    min: 0,
    max: 1,
  );
  const BloodTestParameterNormDto dto = BloodTestParameterNormDto(
    min: 0,
    max: 1,
  );

  test(
    'map blood test parameter norm from dto, '
    'should map dto model to domain model',
    () {
      final BloodTestParameterNorm model =
          mapBloodTestParameterNormFromDto(dto);

      expect(model, domainModel);
    },
  );
}
