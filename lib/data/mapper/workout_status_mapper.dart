import 'package:firebase/firebase.dart';

import '../../domain/model/workout_status.dart';
import 'mood_rate_mapper.dart';
import 'pace_mapper.dart';

WorkoutStatus mapWorkoutStatusFromFirebase(WorkoutStatusDto workoutStatusDto) {
  if (workoutStatusDto is WorkoutStatusPendingDto) {
    return const WorkoutStatusPending();
  } else if (workoutStatusDto is WorkoutStatusDoneDto) {
    return WorkoutStatusDone(
      coveredDistanceInKm: workoutStatusDto.coveredDistanceInKm,
      avgPace: mapPaceFromFirebase(workoutStatusDto.avgPaceDto),
      avgHeartRate: workoutStatusDto.avgHeartRate,
      moodRate: mapMoodRateFromFirebase(workoutStatusDto.moodRate),
      comment: workoutStatusDto.comment,
    );
  } else if (workoutStatusDto is WorkoutStatusAbortedDto) {
    return WorkoutStatusAborted(
      coveredDistanceInKm: workoutStatusDto.coveredDistanceInKm,
      avgPace: mapPaceFromFirebase(workoutStatusDto.avgPaceDto),
      avgHeartRate: workoutStatusDto.avgHeartRate,
      moodRate: mapMoodRateFromFirebase(workoutStatusDto.moodRate),
      comment: workoutStatusDto.comment,
    );
  } else if (workoutStatusDto is WorkoutStatusUndoneDto) {
    return const WorkoutStatusUndone();
  } else {
    throw '[WorkoutStatusMapper] Unknown workout status dto';
  }
}

WorkoutStatusDto mapWorkoutStatusToFirebase(WorkoutStatus workoutStatus) {
  if (workoutStatus is WorkoutStatusPending) {
    return const WorkoutStatusPendingDto();
  } else if (workoutStatus is WorkoutStatusDone) {
    return WorkoutStatusDoneDto(
      coveredDistanceInKm: workoutStatus.coveredDistanceInKm,
      avgPaceDto: mapPaceToFirebase(workoutStatus.avgPace),
      avgHeartRate: workoutStatus.avgHeartRate,
      moodRate: mapMoodRateToFirebase(workoutStatus.moodRate),
      comment: workoutStatus.comment,
    );
  } else if (workoutStatus is WorkoutStatusAborted) {
    return WorkoutStatusAbortedDto(
      coveredDistanceInKm: workoutStatus.coveredDistanceInKm,
      avgPaceDto: mapPaceToFirebase(workoutStatus.avgPace),
      avgHeartRate: workoutStatus.avgHeartRate,
      moodRate: mapMoodRateToFirebase(workoutStatus.moodRate),
      comment: workoutStatus.comment,
    );
  } else if (workoutStatus is WorkoutStatusUndone) {
    return const WorkoutStatusUndoneDto();
  } else {
    throw '[WorkoutStatusMapper] Unknown workout status';
  }
}
