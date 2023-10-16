import 'package:equatable/equatable.dart';

import '../model/entity.dart';

enum AccountType { coach, runner }

enum Gender { male, female }

class User extends Entity {
  final AccountType accountType;
  final Gender gender;
  final String name;
  final String surname;
  final String email;
  final DateTime dateOfBirth;
  final UserSettings settings;
  final String? coachId;

  const User({
    required super.id,
    required this.accountType,
    required this.gender,
    required this.name,
    required this.surname,
    required this.email,
    required this.dateOfBirth,
    required this.settings,
    this.coachId,
  });

  @override
  List<Object?> get props => [
        id,
        gender,
        name,
        surname,
        email,
        dateOfBirth,
        settings,
        coachId,
      ];
}

class UserSettings extends Equatable {
  final ThemeMode themeMode;
  final Language language;
  final DistanceUnit distanceUnit;
  final PaceUnit paceUnit;

  const UserSettings({
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
