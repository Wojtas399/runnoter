import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/time_mapper.dart';
import 'package:runnoter/domain/entity/competition.dart';

void main() {
  const int hour = 2;
  const int minute = 45;
  const int second = 30;
  const Time time = Time(hour: hour, minute: minute, second: second);
  const TimeDto timeDto = TimeDto(hour: hour, minute: minute, second: second);

  test(
    'map time from dto, '
    'should map time from dto to domain model',
    () {
      final Time domainModel = mapTimeFromDto(timeDto);

      expect(domainModel, time);
    },
  );

  test(
    'map time to dto, '
    'should map time from domain to dto model',
    () {
      final TimeDto dto = mapTimeToDto(time);

      expect(dto, timeDto);
    },
  );
}
