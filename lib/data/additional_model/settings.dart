import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final ThemeMode themeMode;
  final Language language;
  final DistanceUnit distanceUnit;
  final PaceUnit paceUnit;

  const Settings({
    required this.themeMode,
    required this.language,
    required this.distanceUnit,
    required this.paceUnit,
  });

  @override
  List<Object> get props => [themeMode, language, distanceUnit, paceUnit];
}

enum ThemeMode { dark, light, system }

enum Language { polish, english, system }

enum DistanceUnit { kilometers, miles }

enum PaceUnit {
  minutesPerKilometer,
  minutesPerMile,
  kilometersPerHour,
  milesPerHour
}
