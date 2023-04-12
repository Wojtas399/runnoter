import '../firebase.dart';

AdditionalWorkout mapAdditionalWorkoutFromString(String additionalWorkout) {
  return AdditionalWorkout.values.byName(additionalWorkout);
}
