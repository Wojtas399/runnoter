import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final BloodReadingsDto readingsDto = BloodReadingsDto(
    userId: 'u1',
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
    'userId': 'u1',
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
      final BloodReadingsDto dto = BloodReadingsDto.fromJson(readingsJson);

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
