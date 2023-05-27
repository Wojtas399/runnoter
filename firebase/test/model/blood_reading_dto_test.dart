import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'br1';
  const String userId = 'u1';
  final BloodReadingDto readingDto = BloodReadingDto(
    id: id,
    userId: userId,
    date: DateTime(2023, 5, 2),
    parameterDtos: const [
      BloodReadingParameterDto(
        parameter: BloodParameter.wbc,
        readingValue: 4.45,
      ),
      BloodReadingParameterDto(
        parameter: BloodParameter.ferritin,
        readingValue: 54.1,
      ),
    ],
  );
  Map<String, dynamic> readingJson = {
    'date': '2023-05-02',
    'readings': [
      {
        'parameter': 'wbc',
        'readingValue': 4.45,
      },
      {
        'parameter': 'ferritin',
        'readingValue': 54.1,
      },
    ],
  };

  test(
    'from json, '
    'should map json to dto',
    () {
      final BloodReadingDto dto = BloodReadingDto.fromJson(
        id: id,
        userId: userId,
        json: readingJson,
      );

      expect(dto, readingDto);
    },
  );

  test(
    'to json, '
    'should map dto to json',
    () {
      final Map<String, dynamic> json = readingDto.toJson();

      expect(json, readingJson);
    },
  );
}
