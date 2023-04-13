import 'package:firebase/firebase.dart' as firebase;

import '../../domain/model/workout.dart';

AdditionalWorkout mapAdditionalWorkoutFromFirebase(
  firebase.AdditionalWorkout additionalWorkout,
) {
  switch (additionalWorkout) {
    case firebase.AdditionalWorkout.stretching:
      return AdditionalWorkout.stretching;
    case firebase.AdditionalWorkout.strengthening:
      return AdditionalWorkout.strengthening;
  }
}
