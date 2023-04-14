import 'package:equatable/equatable.dart';

import '../mapper/distance_unit_mapper.dart';
import '../mapper/pace_unit_mapper.dart';

class WorkoutSettingsDto extends Equatable {
  final String userId;
  final DistanceUnit distanceUnit;
  final PaceUnit paceUnit;

  const WorkoutSettingsDto({
    required this.userId,
    required this.distanceUnit,
    required this.paceUnit,
  });

  @override
  List<Object> get props => [
        userId,
        distanceUnit,
        paceUnit,
      ];

  WorkoutSettingsDto.fromJson(
    String userId,
    Map<String, dynamic>? json,
  ) : this(
          userId: userId,
          distanceUnit: mapDistanceUnitFromStringToEnum(
            json?[_WorkoutSettingsField.distanceUnit.name],
          ),
          paceUnit: mapPaceUnitFromStringToEnum(
            json?[_WorkoutSettingsField.paceUnit.name],
          ),
        );

  Map<String, dynamic> toJson() {
    return {
      _WorkoutSettingsField.distanceUnit.name: distanceUnit.name,
      _WorkoutSettingsField.paceUnit.name: paceUnit.name,
    };
  }
}

enum PaceUnit {
  minutesPerKilometer,
  minutesPerMile,
  kilometersPerHour,
  milesPerHour
}

enum DistanceUnit {
  kilometers,
  miles,
}

Map<String, dynamic> createWorkoutSettingsJsonToUpdate({
  DistanceUnit? distanceUnit,
  PaceUnit? paceUnit,
}) {
  return {
    if (distanceUnit != null)
      _WorkoutSettingsField.distanceUnit.name: distanceUnit.name,
    if (paceUnit != null) _WorkoutSettingsField.paceUnit.name: paceUnit.name,
  };
}

enum _WorkoutSettingsField {
  distanceUnit,
  paceUnit;
}
