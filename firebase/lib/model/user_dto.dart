import 'package:equatable/equatable.dart';

import '../mapper/account_type_mapper.dart';
import '../mapper/date_mapper.dart';
import '../mapper/gender_mapper.dart';

enum AccountType { runner, coach }

enum Gender { male, female }

class UserDto extends Equatable {
  final String id;
  final AccountType accountType;
  final Gender gender;
  final String name;
  final String surname;
  final String email;
  final DateTime dateOfBirth;
  final String? coachId;

  const UserDto({
    required this.id,
    required this.accountType,
    required this.gender,
    required this.name,
    required this.surname,
    required this.email,
    required this.dateOfBirth,
    this.coachId,
  });

  @override
  List<Object?> get props => [
        id,
        accountType,
        gender,
        name,
        surname,
        email,
        dateOfBirth,
        coachId,
      ];

  UserDto.fromJson({
    required String userId,
    required Map<String, dynamic>? json,
  }) : this(
          id: userId,
          accountType: mapAccountTypeFromStr(json?[accountTypeField]),
          gender: mapGenderFromString(json?[_genderField]),
          name: json?[nameField],
          surname: json?[surnameField],
          email: json?[emailField],
          dateOfBirth: mapDateTimeFromString(json?[dateOfBirthField]),
          coachId: json?[coachIdField],
        );

  Map<String, dynamic> toJson() => {
        accountTypeField: mapAccountTypeToStr(accountType),
        _genderField: mapGenderToString(gender),
        nameField: name,
        surnameField: surname,
        emailField: email,
        dateOfBirthField: mapDateTimeToString(dateOfBirth),
        coachIdField: coachId,
      };
}

Map<String, dynamic> createUserJsonToUpdate({
  AccountType? accountType,
  Gender? gender,
  String? name,
  String? surname,
  String? email,
  DateTime? dateOfBirth,
  String? coachId,
  bool coachIdAsNull = false,
}) =>
    {
      if (accountType != null)
        accountTypeField: mapAccountTypeToStr(accountType),
      if (gender != null) _genderField: mapGenderToString(gender),
      if (name != null) nameField: name,
      if (surname != null) surnameField: surname,
      if (email != null) emailField: email,
      if (dateOfBirth != null)
        dateOfBirthField: mapDateTimeToString(dateOfBirth),
      if (coachIdAsNull)
        coachIdField: null
      else if (coachId != null)
        coachIdField: coachId,
    };

const String accountTypeField = 'accountType';
const String _genderField = 'gender';
const String nameField = 'name';
const String surnameField = 'surname';
const String emailField = 'email';
const String dateOfBirthField = 'dateOfBirth';
const String coachIdField = 'coachId';
