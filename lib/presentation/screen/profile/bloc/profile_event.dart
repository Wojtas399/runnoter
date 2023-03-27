import 'package:equatable/equatable.dart';

import '../../../../domain/model/user.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileEventInitialize extends ProfileEvent {
  const ProfileEventInitialize();
}

class ProfileEventEmailUpdated extends ProfileEvent {
  final String? email;

  const ProfileEventEmailUpdated({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];
}

class ProfileEventUserUpdated extends ProfileEvent {
  final User? user;

  const ProfileEventUserUpdated({
    required this.user,
  });

  @override
  List<Object?> get props => [
        user,
      ];
}

class ProfileEventUpdateUsername extends ProfileEvent {
  final String username;

  const ProfileEventUpdateUsername({
    required this.username,
  });

  @override
  List<Object> get props => [
        username,
      ];
}

class ProfileEventUpdateSurname extends ProfileEvent {
  final String surname;

  const ProfileEventUpdateSurname({
    required this.surname,
  });

  @override
  List<Object> get props => [
        surname,
      ];
}

class ProfileEventUpdateEmail extends ProfileEvent {
  final String newEmail;
  final String password;

  const ProfileEventUpdateEmail({
    required this.newEmail,
    required this.password,
  });

  @override
  List<Object> get props => [
        newEmail,
        password,
      ];
}

class ProfileEventUpdatePassword extends ProfileEvent {
  final String newPassword;
  final String currentPassword;

  const ProfileEventUpdatePassword({
    required this.newPassword,
    required this.currentPassword,
  });

  @override
  List<Object> get props => [
        newPassword,
        currentPassword,
      ];
}
