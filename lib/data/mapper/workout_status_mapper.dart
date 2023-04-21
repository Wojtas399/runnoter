import 'package:firebase/firebase.dart';

import '../../domain/model/workout_status.dart';
import 'mood_rate_mapper.dart';
import 'pace_mapper.dart';

WorkoutStatus mapWorkoutStatusFromFirebase(WorkoutStatusDto workoutStatusDto) {
  if (workoutStatusDto is WorkoutStatusPendingDto) {
    return const WorkoutStatusPending();
  } else if (workoutStatusDto is WorkoutStatusDoneDto) {
    return WorkoutStatusDone(
      coveredDistanceInKm: workoutStatusDto.coveredDistanceInKilometers,
      avgPace: mapPaceFromFirebase(workoutStatusDto.avgPace),
      avgHeartRate: workoutStatusDto.avgHeartRate,
      moodRate: mapMoodRateFromFirebase(workoutStatusDto.moodRate),
      comment: workoutStatusDto.comment,
    );
  } else if (workoutStatusDto is WorkoutStatusFailedDto) {
    return WorkoutStatusFailed(
      coveredDistanceInKm: workoutStatusDto.coveredDistanceInKilometers,
      avgPace: mapPaceFromFirebase(workoutStatusDto.avgPace),
      avgHeartRate: workoutStatusDto.avgHeartRate,
      moodRate: mapMoodRateFromFirebase(workoutStatusDto.moodRate),
      comment: workoutStatusDto.comment,
    );
  } else {
    throw '[WorkoutStatusMapper] Unknown workout status';
  }
}