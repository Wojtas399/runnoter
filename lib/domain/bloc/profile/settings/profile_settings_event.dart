part of 'profile_settings_bloc.dart';

abstract class ProfileSettingsEvent extends Equatable {
  const ProfileSettingsEvent();

  @override
  List<Object> get props => [];
}

class ProfileSettingsEventInitialize extends ProfileSettingsEvent {
  const ProfileSettingsEventInitialize();
}

class ProfileSettingsEventUserUpdated extends ProfileSettingsEvent {
  final User? user;

  const ProfileSettingsEventUserUpdated({
    required this.user,
  });

  @override
  List<Object> get props => [];
}
