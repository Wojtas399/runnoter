import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/additional_model/blood_parameter.dart';
import 'package:runnoter/data/entity/blood_test.dart';
import 'package:runnoter/data/mapper/blood_test_mapper.dart';

void main() {
  const String readingsId = 'r1';
  const String userId = 'u1';
  final DateTime date = DateTime(2023, 5, 14);
  final BloodTest bloodTest = BloodTest(
    id: readingsId,
    userId: userId,
    date: date,
    parameterResults: const [
      BloodParameterResult(
        parameter: BloodParameter.wbc,
        value: 4.45,
      ),
      BloodParameterResult(
        parameter: BloodParameter.ldl,
        value: 78,
      ),
    ],
  );
  final firebase.BloodTestDto bloodTestDto = firebase.BloodTestDto(
    id: readingsId,
    userId: userId,
    date: date,
    parameterResultDtos: const [
      firebase.BloodParameterResultDto(
        parameter: firebase.BloodParameter.wbc,
        value: 4.45,
      ),
      firebase.BloodParameterResultDto(
        parameter: firebase.BloodParameter.ldl,
        value: 78,
      ),
    ],
  );

  test(
    'map blood test from dto, '
    'should map blood test dto to domain model',
    () {
      final mappedModel = mapBloodTestFromDto(bloodTestDto);

      expect(mappedModel, bloodTest);
    },
  );
}
