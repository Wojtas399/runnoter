import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/pace_mapper.dart';
import 'package:runnoter/domain/model/workout_status.dart';

void main() {
  test(
    'map pace from dto, '
    'should map pace dto model to domain model',
    () {
      const int minutes = 5;
      const int seconds = 30;
      const PaceDto dto = PaceDto(
        minutes: minutes,
        seconds: seconds,
      );
      const Pace expectedPace = Pace(
        minutes: minutes,
        seconds: seconds,
      );

      final Pace pace = mapPaceFromDto(dto);

      expect(pace, expectedPace);
    },
  );
}
