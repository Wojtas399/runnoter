import '../model/workout_dto.dart';

AdditionalWorkout mapAdditionalWorkoutFromString(String additionalWorkout) {
  return AdditionalWorkout.values.byName(additionalWorkout);
}
