part of 'profile_identities_bloc.dart';

abstract class ProfileIdentitiesEvent {
  const ProfileIdentitiesEvent();
}

class ProfileIdentitiesEventInitialize extends ProfileIdentitiesEvent {
  const ProfileIdentitiesEventInitialize();
}

class ProfileIdentitiesEventUpdateUsername extends ProfileIdentitiesEvent {
  final String username;

  const ProfileIdentitiesEventUpdateUsername({
    required this.username,
  });
}

class ProfileIdentitiesEventUpdateSurname extends ProfileIdentitiesEvent {
  final String surname;

  const ProfileIdentitiesEventUpdateSurname({
    required this.surname,
  });
}

class ProfileIdentitiesEventUpdateEmail extends ProfileIdentitiesEvent {
  final String newEmail;
  final String password;

  const ProfileIdentitiesEventUpdateEmail({
    required this.newEmail,
    required this.password,
  });
}

class ProfileIdentitiesEventUpdatePassword extends ProfileIdentitiesEvent {
  final String newPassword;
  final String currentPassword;

  const ProfileIdentitiesEventUpdatePassword({
    required this.newPassword,
    required this.currentPassword,
  });
}

class ProfileIdentitiesEventDeleteAccount extends ProfileIdentitiesEvent {
  final String password;

  const ProfileIdentitiesEventDeleteAccount({
    required this.password,
  });
}
