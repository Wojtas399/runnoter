import '../model/activity_status_dto.dart';

MoodRate mapMoodRateFromNumber(int number) => MoodRate.values[number - 1];
