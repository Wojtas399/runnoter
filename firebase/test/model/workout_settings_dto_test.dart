import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String userId = 'u1';
  const DistanceUnit distanceUnit = DistanceUnit.kilometers;
  const PaceUnit paceUnit = PaceUnit.minutesPerKilometer;
  const WorkoutSettingsDto workoutSettingsDto = WorkoutSettingsDto(
    userId: userId,
    distanceUnit: distanceUnit,
    paceUnit: paceUnit,
  );
  final Map<String, dynamic> workoutSettingsJson = {
    'distanceUnit': distanceUnit.name,
    'paceUnit': paceUnit.name,
  };

  test(
    'from json, '
    'should map json to dto model',
    () {
      final WorkoutSettingsDto dto = WorkoutSettingsDto.fromJson(
        userId,
        workoutSettingsJson,
      );

      expect(dto, workoutSettingsDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final Map<String, dynamic> json = workoutSettingsDto.toJson();

      expect(json, workoutSettingsJson);
    },
  );
}
