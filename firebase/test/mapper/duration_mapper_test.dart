import 'package:firebase/mapper/duration_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Duration duration = Duration(
    hours: 1,
    minutes: 45,
    seconds: 20,
  );
  const String durationStr = '1:45:20';

  test(
    'map duration from string, '
    'should map duration from string format to duration model',
    () {
      final Duration mappedModel = mapDurationFromString(durationStr);

      expect(mappedModel, duration);
    },
  );

  test(
    'map duration to string, '
    'should map duration from duration model to string format',
    () {
      final String str = mapDurationToString(duration);

      expect(str, durationStr);
    },
  );
}
