import 'package:equatable/equatable.dart';

abstract class ProfileSettingsEvent extends Equatable {
  const ProfileSettingsEvent();

  @override
  List<Object> get props => [];
}

class ProfileSettingsEventInitialize extends ProfileSettingsEvent {
  const ProfileSettingsEventInitialize();
}
