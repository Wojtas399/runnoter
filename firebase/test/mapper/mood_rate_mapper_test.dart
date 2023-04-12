import 'package:firebase/firebase.dart';
import 'package:firebase/mapper/mood_rate_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map mood rate from number, '
    'number 1 should be mapped to mr1 type',
    () {
      const int number = 1;
      const MoodRate expectedMoodRate = MoodRate.mr1;

      final MoodRate moodRate = mapMoodRateFromNumber(number);

      expect(moodRate, expectedMoodRate);
    },
  );

  test(
    'map mood rate from number, '
    'number 2 should be mapped to mr2 type',
    () {
      const int number = 2;
      const MoodRate expectedMoodRate = MoodRate.mr2;

      final MoodRate moodRate = mapMoodRateFromNumber(number);

      expect(moodRate, expectedMoodRate);
    },
  );

  test(
    'map mood rate from number, '
    'number 3 should be mapped to mr3 type',
    () {
      const int number = 3;
      const MoodRate expectedMoodRate = MoodRate.mr3;

      final MoodRate moodRate = mapMoodRateFromNumber(number);

      expect(moodRate, expectedMoodRate);
    },
  );

  test(
    'map mood rate from number, '
    'number 4 should be mapped to mr4 type',
    () {
      const int number = 4;
      const MoodRate expectedMoodRate = MoodRate.mr4;

      final MoodRate moodRate = mapMoodRateFromNumber(number);

      expect(moodRate, expectedMoodRate);
    },
  );

  test(
    'map mood rate from number, '
    'number 5 should be mapped to mr5 type',
    () {
      const int number = 5;
      const MoodRate expectedMoodRate = MoodRate.mr5;

      final MoodRate moodRate = mapMoodRateFromNumber(number);

      expect(moodRate, expectedMoodRate);
    },
  );

  test(
    'map mood rate from number, '
    'number 6 should be mapped to mr6 type',
    () {
      const int number = 6;
      const MoodRate expectedMoodRate = MoodRate.mr6;

      final MoodRate moodRate = mapMoodRateFromNumber(number);

      expect(moodRate, expectedMoodRate);
    },
  );

  test(
    'map mood rate from number, '
    'number 7 should be mapped to mr7 type',
    () {
      const int number = 7;
      const MoodRate expectedMoodRate = MoodRate.mr7;

      final MoodRate moodRate = mapMoodRateFromNumber(number);

      expect(moodRate, expectedMoodRate);
    },
  );

  test(
    'map mood rate from number, '
    'number 8 should be mapped to mr8 type',
    () {
      const int number = 8;
      const MoodRate expectedMoodRate = MoodRate.mr8;

      final MoodRate moodRate = mapMoodRateFromNumber(number);

      expect(moodRate, expectedMoodRate);
    },
  );

  test(
    'map mood rate from number, '
    'number 9 should be mapped to mr9 type',
    () {
      const int number = 9;
      const MoodRate expectedMoodRate = MoodRate.mr9;

      final MoodRate moodRate = mapMoodRateFromNumber(number);

      expect(moodRate, expectedMoodRate);
    },
  );

  test(
    'map mood rate from number, '
    'number 10 should be mapped to mr10 type',
    () {
      const int number = 10;
      const MoodRate expectedMoodRate = MoodRate.mr10;

      final MoodRate moodRate = mapMoodRateFromNumber(number);

      expect(moodRate, expectedMoodRate);
    },
  );
}
