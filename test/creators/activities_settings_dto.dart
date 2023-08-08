import 'package:firebase/firebase.dart';

ActivitiesSettingsDto createActivitiesSettingsDto({
  String userId = '',
  DistanceUnit distanceUnit = DistanceUnit.kilometers,
  PaceUnit paceUnit = PaceUnit.minutesPerKilometer,
}) =>
    ActivitiesSettingsDto(
      userId: userId,
      distanceUnit: distanceUnit,
      paceUnit: paceUnit,
    );
