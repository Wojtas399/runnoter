import '../firebase.dart';

MoodRate mapMoodRateFromNumber(int number) {
  return MoodRate.values[number - 1];
}
