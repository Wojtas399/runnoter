import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String userId = 'u1';
  const DistanceUnit distanceUnit = DistanceUnit.kilometers;
  const PaceUnit paceUnit = PaceUnit.minutesPerKilometer;

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'distanceUnit': distanceUnit.name,
        'paceUnit': paceUnit.name,
      };
      const WorkoutSettingsDto expectedDto = WorkoutSettingsDto(
        userId: userId,
        distanceUnit: distanceUnit,
        paceUnit: paceUnit,
      );

      final WorkoutSettingsDto dto = WorkoutSettingsDto.fromJson(userId, json);

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      const WorkoutSettingsDto dto = WorkoutSettingsDto(
        userId: userId,
        distanceUnit: distanceUnit,
        paceUnit: paceUnit,
      );
      final Map<String, dynamic> expectedJson = {
        'distanceUnit': distanceUnit.name,
        'paceUnit': paceUnit.name,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'distance unit is null, '
    'should not include distance unit in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'paceUnit': paceUnit.name,
      };

      final Map<String, dynamic> json = createWorkoutSettingsJsonToUpdate(
        paceUnit: paceUnit,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'pace unit is null, '
    'should not include pace unit in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'distanceUnit': distanceUnit.name,
      };

      final Map<String, dynamic> json = createWorkoutSettingsJsonToUpdate(
        distanceUnit: distanceUnit,
      );

      expect(json, expectedJson);
    },
  );
}
