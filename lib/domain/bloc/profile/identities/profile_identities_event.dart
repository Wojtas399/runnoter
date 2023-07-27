part of 'profile_identities_bloc.dart';

abstract class ProfileIdentitiesEvent {
  const ProfileIdentitiesEvent();
}

class ProfileIdentitiesEventInitialize extends ProfileIdentitiesEvent {
  const ProfileIdentitiesEventInitialize();
}

class ProfileIdentitiesEventUpdateGender extends ProfileIdentitiesEvent {
  final Gender gender;

  const ProfileIdentitiesEventUpdateGender({required this.gender});
}

class ProfileIdentitiesEventUpdateUsername extends ProfileIdentitiesEvent {
  final String username;

  const ProfileIdentitiesEventUpdateUsername({required this.username});
}

class ProfileIdentitiesEventUpdateSurname extends ProfileIdentitiesEvent {
  final String surname;

  const ProfileIdentitiesEventUpdateSurname({required this.surname});
}

class ProfileIdentitiesEventUpdateEmail extends ProfileIdentitiesEvent {
  final String newEmail;

  const ProfileIdentitiesEventUpdateEmail({required this.newEmail});
}

class ProfileIdentitiesEventUpdatePassword extends ProfileIdentitiesEvent {
  final String newPassword;

  const ProfileIdentitiesEventUpdatePassword({required this.newPassword});
}

class ProfileIdentitiesEventDeleteAccount extends ProfileIdentitiesEvent {
  const ProfileIdentitiesEventDeleteAccount();
}
