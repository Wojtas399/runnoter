import 'package:firebase/mapper/additional_workout_mapper.dart';
import 'package:firebase/model/workout_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map additional workout from string, '
    'stretching should be mapped to AdditionalWorkout.stretching type',
    () {
      const String strAdditionalWorkout = 'stretching';
      const AdditionalWorkout expectedAdditionalWorkout =
          AdditionalWorkout.stretching;

      final AdditionalWorkout additionalWorkout =
          mapAdditionalWorkoutFromString(strAdditionalWorkout);

      expect(additionalWorkout, expectedAdditionalWorkout);
    },
  );

  test(
    'map additional workout from string, '
    'strengthening should be mapped to AdditionalWorkout.strengthening type',
    () {
      const String strAdditionalWorkout = 'strengthening';
      const AdditionalWorkout expectedAdditionalWorkout =
          AdditionalWorkout.strengthening;

      final AdditionalWorkout additionalWorkout =
          mapAdditionalWorkoutFromString(strAdditionalWorkout);

      expect(additionalWorkout, expectedAdditionalWorkout);
    },
  );
}
