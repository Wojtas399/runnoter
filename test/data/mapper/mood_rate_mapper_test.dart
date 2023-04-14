import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/mood_rate_mapper.dart';
import 'package:runnoter/domain/model/workout_status.dart';

void main() {
  void verifyMappingFromFirebase(
    firebase.MoodRate firebaseMoodRate,
    MoodRate expectedMoodRate,
  ) {
    final MoodRate moodRate = mapMoodRateFromFirebase(firebaseMoodRate);

    expect(moodRate, expectedMoodRate);
  }

  test(
    'map mood rate from firebase, '
    'firebase MoodRate.mr1 should be mapped to domain MoodRate.mr1',
    () {
      verifyMappingFromFirebase(firebase.MoodRate.mr1, MoodRate.mr1);
    },
  );

  test(
    'map mood rate from firebase, '
    'firebase MoodRate.mr2 should be mapped to domain MoodRate.mr2',
    () {
      verifyMappingFromFirebase(firebase.MoodRate.mr2, MoodRate.mr2);
    },
  );

  test(
    'map mood rate from firebase, '
    'firebase MoodRate.mr3 should be mapped to domain MoodRate.mr3',
    () {
      verifyMappingFromFirebase(firebase.MoodRate.mr3, MoodRate.mr3);
    },
  );

  test(
    'map mood rate from firebase, '
    'firebase MoodRate.mr4 should be mapped to domain MoodRate.mr4',
    () {
      verifyMappingFromFirebase(firebase.MoodRate.mr4, MoodRate.mr4);
    },
  );

  test(
    'map mood rate from firebase, '
    'firebase MoodRate.mr5 should be mapped to domain MoodRate.mr5',
    () {
      verifyMappingFromFirebase(firebase.MoodRate.mr5, MoodRate.mr5);
    },
  );

  test(
    'map mood rate from firebase, '
    'firebase MoodRate.mr6 should be mapped to domain MoodRate.mr6',
    () {
      verifyMappingFromFirebase(firebase.MoodRate.mr6, MoodRate.mr6);
    },
  );

  test(
    'map mood rate from firebase, '
    'firebase MoodRate.mr7 should be mapped to domain MoodRate.mr7',
    () {
      verifyMappingFromFirebase(firebase.MoodRate.mr7, MoodRate.mr7);
    },
  );

  test(
    'map mood rate from firebase, '
    'firebase MoodRate.mr8 should be mapped to domain MoodRate.mr8',
    () {
      verifyMappingFromFirebase(firebase.MoodRate.mr8, MoodRate.mr8);
    },
  );

  test(
    'map mood rate from firebase, '
    'firebase MoodRate.mr9 should be mapped to domain MoodRate.mr9',
    () {
      verifyMappingFromFirebase(firebase.MoodRate.mr9, MoodRate.mr9);
    },
  );

  test(
    'map mood rate from firebase, '
    'firebase MoodRate.mr10 should be mapped to domain MoodRate.mr10',
    () {
      verifyMappingFromFirebase(firebase.MoodRate.mr10, MoodRate.mr10);
    },
  );
}
