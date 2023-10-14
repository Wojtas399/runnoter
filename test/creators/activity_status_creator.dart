import 'package:runnoter/data/additional_model/activity_status.dart';

ActivityStatusDone createActivityStatusDone({
  double coveredDistanceInKm = 0.0,
  Pace avgPace = const Pace(minutes: 0, seconds: 0),
  int avgHeartRate = 1,
  MoodRate moodRate = MoodRate.mr1,
  String? comment,
}) =>
    ActivityStatusDone(
      coveredDistanceInKm: coveredDistanceInKm,
      avgPace: avgPace,
      avgHeartRate: avgHeartRate,
      moodRate: moodRate,
      comment: comment,
    );

ActivityStatusAborted createActivityStatusAborted({
  double coveredDistanceInKm = 0.0,
  Pace avgPace = const Pace(minutes: 0, seconds: 0),
  int avgHeartRate = 1,
  MoodRate moodRate = MoodRate.mr1,
  String? comment,
}) =>
    ActivityStatusAborted(
      coveredDistanceInKm: coveredDistanceInKm,
      avgPace: avgPace,
      avgHeartRate: avgHeartRate,
      moodRate: moodRate,
      comment: comment,
    );
