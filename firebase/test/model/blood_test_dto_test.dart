import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'br1';
  const String userId = 'u1';
  final DateTime date = DateTime(2023, 5, 2);
  const String dateStr = '2023-05-02';
  const List<BloodParameterResultDto> parameterResults = [
    BloodParameterResultDto(
      parameter: BloodParameter.wbc,
      value: 4.45,
    ),
    BloodParameterResultDto(
      parameter: BloodParameter.ferritin,
      value: 54.1,
    ),
  ];
  const List<Map<String, dynamic>> parameterResultJsons = [
    {'parameter': 'wbc', 'value': 4.45},
    {'parameter': 'ferritin', 'value': 54.1},
  ];

  test(
    'from json, '
    'should map json to dto',
    () {
      final Map<String, dynamic> json = {
        'date': dateStr,
        'parameterResults': parameterResultJsons,
      };
      final BloodTestDto expectedDto = BloodTestDto(
        id: id,
        userId: userId,
        date: date,
        parameterResultDtos: parameterResults,
      );

      final BloodTestDto dto = BloodTestDto.fromJson(
        bloodTestId: id,
        userId: userId,
        json: json,
      );

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto to json',
    () {
      final BloodTestDto dto = BloodTestDto(
        id: id,
        userId: userId,
        date: date,
        parameterResultDtos: parameterResults,
      );
      final Map<String, dynamic> expectedJson = {
        'date': dateStr,
        'parameterResults': parameterResultJsons,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'date is null, '
    'should not include date in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'parameterResults': parameterResultJsons,
      };

      final Map<String, dynamic> json = createBloodTestJsonToUpdate(
        parameterResultDtos: parameterResults,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'parameter results are null, '
    'should not include parameter results in json',
    () {
      final Map<String, dynamic> expectedJson = {'date': dateStr};

      final Map<String, dynamic> json = createBloodTestJsonToUpdate(date: date);

      expect(json, expectedJson);
    },
  );
}
