import 'package:firebase/firebase.dart';

import '../../domain/model/workout_status.dart';
import 'mood_rate_mapper.dart';
import 'pace_mapper.dart';

WorkoutStatus mapWorkoutStatusFromFirebase(WorkoutStatusDto workoutStatusDto) {
  if (workoutStatusDto is WorkoutStatusPendingDto) {
    return const WorkoutStatusPending();
  } else if (workoutStatusDto is WorkoutStatusCompletedDto) {
    return WorkoutStatusCompleted(
      coveredDistanceInKm: workoutStatusDto.coveredDistanceInKilometers,
      avgPace: mapPaceFromFirebase(workoutStatusDto.avgPace),
      avgHeartRate: workoutStatusDto.avgHeartRate,
      moodRate: mapMoodRateFromFirebase(workoutStatusDto.moodRate),
      comment: workoutStatusDto.comment,
    );
  } else if (workoutStatusDto is WorkoutStatusUncompletedDto) {
    return WorkoutStatusUncompleted(
      coveredDistanceInKm: workoutStatusDto.coveredDistanceInKilometers,
      avgPace: mapPaceFromFirebase(workoutStatusDto.avgPace),
      avgHeartRate: workoutStatusDto.avgHeartRate,
      moodRate: mapMoodRateFromFirebase(workoutStatusDto.moodRate),
      comment: workoutStatusDto.comment,
    );
  } else {
    throw '[WorkoutStatusMapper] Unknown workout status dto';
  }
}

WorkoutStatusDto mapWorkoutStatusToFirebase(WorkoutStatus workoutStatus) {
  if (workoutStatus is WorkoutStatusPending) {
    return const WorkoutStatusPendingDto();
  } else if (workoutStatus is WorkoutStatusCompleted) {
    return WorkoutStatusCompletedDto(
      coveredDistanceInKilometers: workoutStatus.coveredDistanceInKm,
      avgPace: mapPaceToFirebase(workoutStatus.avgPace),
      avgHeartRate: workoutStatus.avgHeartRate,
      moodRate: mapMoodRateToFirebase(workoutStatus.moodRate),
      comment: workoutStatus.comment,
    );
  } else if (workoutStatus is WorkoutStatusUncompleted) {
    return WorkoutStatusUncompletedDto(
      coveredDistanceInKilometers: workoutStatus.coveredDistanceInKm,
      avgPace: mapPaceToFirebase(workoutStatus.avgPace),
      avgHeartRate: workoutStatus.avgHeartRate,
      moodRate: mapMoodRateToFirebase(workoutStatus.moodRate),
      comment: workoutStatus.comment,
    );
  } else {
    throw '[WorkoutStatusMapper] Unknown workout status';
  }
}
