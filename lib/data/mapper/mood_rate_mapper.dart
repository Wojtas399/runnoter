import 'package:firebase/firebase.dart' as firebase;

import '../../domain/model/workout_status.dart';

MoodRate mapMoodRateFromFirebase(firebase.MoodRate firebaseMoodRate) {
  switch (firebaseMoodRate) {
    case firebase.MoodRate.mr1:
      return MoodRate.mr1;
    case firebase.MoodRate.mr2:
      return MoodRate.mr2;
    case firebase.MoodRate.mr3:
      return MoodRate.mr3;
    case firebase.MoodRate.mr4:
      return MoodRate.mr4;
    case firebase.MoodRate.mr5:
      return MoodRate.mr5;
    case firebase.MoodRate.mr6:
      return MoodRate.mr6;
    case firebase.MoodRate.mr7:
      return MoodRate.mr7;
    case firebase.MoodRate.mr8:
      return MoodRate.mr8;
    case firebase.MoodRate.mr9:
      return MoodRate.mr9;
    case firebase.MoodRate.mr10:
      return MoodRate.mr10;
  }
}
