part of 'profile_settings_bloc.dart';

abstract class ProfileSettingsEvent extends Equatable {
  const ProfileSettingsEvent();

  @override
  List<Object> get props => [];
}

class ProfileSettingsEventInitialize extends ProfileSettingsEvent {
  const ProfileSettingsEventInitialize();
}

class ProfileSettingsEventUpdateThemeMode extends ProfileSettingsEvent {
  final ThemeMode newThemeMode;

  const ProfileSettingsEventUpdateThemeMode({
    required this.newThemeMode,
  });
}

class ProfileSettingsEventUpdateLanguage extends ProfileSettingsEvent {
  final Language newLanguage;

  const ProfileSettingsEventUpdateLanguage({
    required this.newLanguage,
  });
}

class ProfileSettingsEventUpdateDistanceUnit extends ProfileSettingsEvent {
  final DistanceUnit newDistanceUnit;

  const ProfileSettingsEventUpdateDistanceUnit({
    required this.newDistanceUnit,
  });
}

class ProfileSettingsEventUpdatePaceUnit extends ProfileSettingsEvent {
  final PaceUnit newPaceUnit;

  const ProfileSettingsEventUpdatePaceUnit({
    required this.newPaceUnit,
  });
}
