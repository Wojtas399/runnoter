import 'package:firebase/model/time_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const TimeDto timeDto = TimeDto(
    hour: 2,
    minute: 45,
    second: 30,
  );
  const String timeStr = '02:45:30';

  test(
    'from string, '
    'should map string to dto model',
    () {
      final dto = TimeDto.fromString(timeStr);

      expect(dto, timeDto);
    },
  );

  test(
    'to string, '
    'should map dto model to string',
    () {
      final str = timeDto.toString();

      expect(str, timeStr);
    },
  );
}
