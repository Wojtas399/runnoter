import '../../domain/model/workout_status.dart';

extension MoodRateFormatter on MoodRate {
  String toUIFormat() {
    int number = MoodRate.values.indexOf(this) + 1;
    return '$number/10';
  }
}
