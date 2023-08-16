import 'package:firebase/firebase.dart' as firebase;

import '../../domain/additional_model/activity_status.dart';

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

firebase.MoodRate mapMoodRateToFirebase(MoodRate moodRate) {
  switch (moodRate) {
    case MoodRate.mr1:
      return firebase.MoodRate.mr1;
    case MoodRate.mr2:
      return firebase.MoodRate.mr2;
    case MoodRate.mr3:
      return firebase.MoodRate.mr3;
    case MoodRate.mr4:
      return firebase.MoodRate.mr4;
    case MoodRate.mr5:
      return firebase.MoodRate.mr5;
    case MoodRate.mr6:
      return firebase.MoodRate.mr6;
    case MoodRate.mr7:
      return firebase.MoodRate.mr7;
    case MoodRate.mr8:
      return firebase.MoodRate.mr8;
    case MoodRate.mr9:
      return firebase.MoodRate.mr9;
    case MoodRate.mr10:
      return firebase.MoodRate.mr10;
  }
}
