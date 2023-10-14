import '../../data/additional_model/settings.dart';

extension PaceUnitFormatter on PaceUnit {
  String toUIFormat() => switch (this) {
        PaceUnit.minutesPerKilometer => 'min/km',
        PaceUnit.minutesPerMile => 'min/mil',
        PaceUnit.kilometersPerHour => 'km/h',
        PaceUnit.milesPerHour => 'mil/h',
      };
}
