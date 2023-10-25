import 'package:firebase/firebase.dart';

UserDto createUserDto({
  String id = '',
  AccountType accountType = AccountType.runner,
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  String email = '',
  DateTime? dateOfBirth,
  String? coachId,
}) =>
    UserDto(
      id: id,
      accountType: accountType,
      gender: gender,
      name: name,
      surname: surname,
      email: email,
      dateOfBirth: dateOfBirth ?? DateTime(2023),
      coachId: coachId,
    );
