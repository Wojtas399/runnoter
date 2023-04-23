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

  void verifyMappingToFirebase(
    MoodRate moodRate,
    firebase.MoodRate expectedFirebaseMoodRate,
  ) {
    final firebaseMoodRate = mapMoodRateToFirebase(moodRate);

    expect(firebaseMoodRate, expectedFirebaseMoodRate);
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

  test(
    'map mood rate to firebase, '
    'MoodRate.mr1 should be mapped to firebase MoodRate.mr1',
    () {
      verifyMappingToFirebase(MoodRate.mr1, firebase.MoodRate.mr1);
    },
  );

  test(
    'map mood rate to firebase, '
    'MoodRate.mr2 should be mapped to firebase MoodRate.mr2',
    () {
      verifyMappingToFirebase(MoodRate.mr2, firebase.MoodRate.mr2);
    },
  );

  test(
    'map mood rate to firebase, '
    'MoodRate.mr3 should be mapped to firebase MoodRate.mr3',
    () {
      verifyMappingToFirebase(MoodRate.mr3, firebase.MoodRate.mr3);
    },
  );

  test(
    'map mood rate to firebase, '
    'MoodRate.mr4 should be mapped to firebase MoodRate.mr4',
    () {
      verifyMappingToFirebase(MoodRate.mr4, firebase.MoodRate.mr4);
    },
  );

  test(
    'map mood rate to firebase, '
    'MoodRate.mr5 should be mapped to firebase MoodRate.mr5',
    () {
      verifyMappingToFirebase(MoodRate.mr5, firebase.MoodRate.mr5);
    },
  );

  test(
    'map mood rate to firebase, '
    'MoodRate.mr6 should be mapped to firebase MoodRate.mr6',
    () {
      verifyMappingToFirebase(MoodRate.mr6, firebase.MoodRate.mr6);
    },
  );

  test(
    'map mood rate to firebase, '
    'MoodRate.mr7 should be mapped to firebase MoodRate.mr7',
    () {
      verifyMappingToFirebase(MoodRate.mr7, firebase.MoodRate.mr7);
    },
  );

  test(
    'map mood rate to firebase, '
    'MoodRate.mr8 should be mapped to firebase MoodRate.mr8',
    () {
      verifyMappingToFirebase(MoodRate.mr8, firebase.MoodRate.mr8);
    },
  );

  test(
    'map mood rate to firebase, '
    'MoodRate.mr9 should be mapped to firebase MoodRate.mr9',
    () {
      verifyMappingToFirebase(MoodRate.mr9, firebase.MoodRate.mr9);
    },
  );

  test(
    'map mood rate to firebase, '
    'MoodRate.mr10 should be mapped to firebase MoodRate.mr10',
    () {
      verifyMappingToFirebase(MoodRate.mr10, firebase.MoodRate.mr10);
    },
  );
}
