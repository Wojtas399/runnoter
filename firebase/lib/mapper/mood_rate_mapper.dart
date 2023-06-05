import '../model/run_status_dto.dart';

MoodRate mapMoodRateFromNumber(int number) {
  return MoodRate.values[number - 1];
}
