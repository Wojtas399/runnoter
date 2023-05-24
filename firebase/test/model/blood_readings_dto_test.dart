import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'br1';
  const String userId = 'u1';
  final BloodReadingsDto readingsDto = BloodReadingsDto(
    id: id,
    userId: userId,
    date: DateTime(2023, 5, 2),
    readingDtos: const [
      BloodParameterReadingDto(
        parameter: BloodParameter.wbc,
        readingValue: 4.45,
      ),
      BloodParameterReadingDto(
        parameter: BloodParameter.ferritin,
        readingValue: 54.1,
      ),
    ],
  );
  Map<String, dynamic> readingsJson = {
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
      final BloodReadingsDto dto = BloodReadingsDto.fromJson(
        id: id,
        userId: userId,
        json: readingsJson,
      );

      expect(dto, readingsDto);
    },
  );

  test(
    'to json, '
    'should map dto to json',
    () {
      final Map<String, dynamic> json = readingsDto.toJson();

      expect(json, readingsJson);
    },
  );
}
