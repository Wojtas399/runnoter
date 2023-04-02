import 'package:equatable/equatable.dart';

import '../../../../domain/model/user.dart';

abstract class ProfileIdentitiesEvent extends Equatable {
  const ProfileIdentitiesEvent();

  @override
  List<Object?> get props => [];
}

class ProfileIdentitiesEventInitialize extends ProfileIdentitiesEvent {
  const ProfileIdentitiesEventInitialize();
}

class ProfileIdentitiesEventEmailUpdated extends ProfileIdentitiesEvent {
  final String? email;

  const ProfileIdentitiesEventEmailUpdated({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];
}

class ProfileIdentitiesEventUserUpdated extends ProfileIdentitiesEvent {
  final User? user;

  const ProfileIdentitiesEventUserUpdated({
    required this.user,
  });

  @override
  List<Object?> get props => [
        user,
      ];
}

class ProfileIdentitiesEventUpdateUsername extends ProfileIdentitiesEvent {
  final String username;

  const ProfileIdentitiesEventUpdateUsername({
    required this.username,
  });

  @override
  List<Object> get props => [
        username,
      ];
}

class ProfileIdentitiesEventUpdateSurname extends ProfileIdentitiesEvent {
  final String surname;

  const ProfileIdentitiesEventUpdateSurname({
    required this.surname,
  });

  @override
  List<Object> get props => [
        surname,
      ];
}

class ProfileIdentitiesEventUpdateEmail extends ProfileIdentitiesEvent {
  final String newEmail;
  final String password;

  const ProfileIdentitiesEventUpdateEmail({
    required this.newEmail,
    required this.password,
  });

  @override
  List<Object> get props => [
        newEmail,
        password,
      ];
}

class ProfileIdentitiesEventUpdatePassword extends ProfileIdentitiesEvent {
  final String newPassword;
  final String currentPassword;

  const ProfileIdentitiesEventUpdatePassword({
    required this.newPassword,
    required this.currentPassword,
  });

  @override
  List<Object> get props => [
        newPassword,
        currentPassword,
      ];
}

class ProfileIdentitiesEventDeleteAccount extends ProfileIdentitiesEvent {
  final String password;

  const ProfileIdentitiesEventDeleteAccount({
    required this.password,
  });

  @override
  List<Object> get props => [
        password,
      ];
}
