import 'package:firebase/model/pace_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const int minutes = 5;
  const int seconds = 35;
  const PaceDto paceDto = PaceDto(
    minutes: minutes,
    seconds: seconds,
  );
  final Map<String, dynamic> paceJson = {
    'minutes': 5,
    'seconds': 35,
  };

  test(
    'from json, '
    'should map json to dto model',
    () {
      final PaceDto dto = PaceDto.fromJson(paceJson);

      expect(dto, paceDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final Map<String, dynamic> json = paceDto.toJson();

      expect(json, paceJson);
    },
  );
}
