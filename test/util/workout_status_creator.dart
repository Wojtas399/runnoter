import 'package:runnoter/domain/entity/workout_status.dart';

WorkoutStatusDone createWorkoutStatusDone({
  double coveredDistanceInKm = 0.0,
  Pace avgPace = const Pace(minutes: 0, seconds: 0),
  int avgHeartRate = 1,
  MoodRate moodRate = MoodRate.mr1,
  String? comment,
}) =>
    WorkoutStatusDone(
      coveredDistanceInKm: coveredDistanceInKm,
      avgPace: avgPace,
      avgHeartRate: avgHeartRate,
      moodRate: moodRate,
      comment: comment,
    );

WorkoutStatusAborted createWorkoutStatusAborted({
  double coveredDistanceInKm = 0.0,
  Pace avgPace = const Pace(minutes: 0, seconds: 0),
  int avgHeartRate = 1,
  MoodRate moodRate = MoodRate.mr1,
  String? comment,
}) =>
    WorkoutStatusAborted(
      coveredDistanceInKm: coveredDistanceInKm,
      avgPace: avgPace,
      avgHeartRate: avgHeartRate,
      moodRate: moodRate,
      comment: comment,
    );
