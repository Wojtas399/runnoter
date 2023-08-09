import 'package:runnoter/domain/additional_model/run_status.dart';

RunStatusDone createRunStatusDone({
  double coveredDistanceInKm = 0.0,
  Pace avgPace = const Pace(minutes: 0, seconds: 0),
  int avgHeartRate = 1,
  MoodRate moodRate = MoodRate.mr1,
  String? comment,
}) =>
    RunStatusDone(
      coveredDistanceInKm: coveredDistanceInKm,
      avgPace: avgPace,
      avgHeartRate: avgHeartRate,
      moodRate: moodRate,
      comment: comment,
    );

RunStatusAborted createRunStatusAborted({
  double coveredDistanceInKm = 0.0,
  Pace avgPace = const Pace(minutes: 0, seconds: 0),
  int avgHeartRate = 1,
  MoodRate moodRate = MoodRate.mr1,
  String? comment,
}) =>
    RunStatusAborted(
      coveredDistanceInKm: coveredDistanceInKm,
      avgPace: avgPace,
      avgHeartRate: avgHeartRate,
      moodRate: moodRate,
      comment: comment,
    );
