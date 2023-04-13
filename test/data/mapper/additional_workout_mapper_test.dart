import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/additional_workout_mapper.dart';
import 'package:runnoter/domain/model/workout.dart';

void main() {
  test(
    'map additional workout from firebase, '
    'firebase additional workout stretching type should be mapped to domain additional workout stretching type',
    () {
      const firebaseAdditionalWorkout = firebase.AdditionalWorkout.stretching;
      const expectedAdditionalWorkout = AdditionalWorkout.stretching;

      final additionalWorkout = mapAdditionalWorkoutFromFirebase(
        firebaseAdditionalWorkout,
      );

      expect(additionalWorkout, expectedAdditionalWorkout);
    },
  );

  test(
    'map additional workout from firebase, '
    'firebase additional workout strengthening type should be mapped to domain additional workout strengthening type',
    () {
      const firebaseAdditionalWorkout =
          firebase.AdditionalWorkout.strengthening;
      const expectedAdditionalWorkout = AdditionalWorkout.strengthening;

      final additionalWorkout = mapAdditionalWorkoutFromFirebase(
        firebaseAdditionalWorkout,
      );

      expect(additionalWorkout, expectedAdditionalWorkout);
    },
  );
}
