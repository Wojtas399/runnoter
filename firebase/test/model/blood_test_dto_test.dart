import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'br1';
  const String userId = 'u1';
  final BloodTestDto testDto = BloodTestDto(
    id: id,
    userId: userId,
    date: DateTime(2023, 5, 2),
    parameterResultDtos: const [
      BloodParameterResultDto(
        parameter: BloodParameter.wbc,
        value: 4.45,
      ),
      BloodParameterResultDto(
        parameter: BloodParameter.ferritin,
        value: 54.1,
      ),
    ],
  );
  Map<String, dynamic> testJson = {
    'date': '2023-05-02',
    'parameterResults': [
      {
        'parameter': 'wbc',
        'value': 4.45,
      },
      {
        'parameter': 'ferritin',
        'value': 54.1,
      },
    ],
  };

  test(
    'from json, '
    'should map json to dto',
    () {
      final BloodTestDto dto = BloodTestDto.fromJson(
        id: id,
        userId: userId,
        json: testJson,
      );

      expect(dto, testDto);
    },
  );

  test(
    'to json, '
    'should map dto to json',
    () {
      final Map<String, dynamic> json = testDto.toJson();

      expect(json, testJson);
    },
  );
}
