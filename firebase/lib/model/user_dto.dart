import 'package:equatable/equatable.dart';

import '../mapper/account_type_mapper.dart';

enum AccountType { runner, coach }

enum Gender { male, female }

class UserDto extends Equatable {
  final String id;
  final AccountType accountType;
  final Gender gender;
  final String name;
  final String surname;
  final String email;
  final String? coachId;

  const UserDto({
    required this.id,
    required this.accountType,
    required this.gender,
    required this.name,
    required this.surname,
    required this.email,
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
        coachId,
      ];

  UserDto.fromJson(
    String id,
    Map<String, dynamic>? json,
  ) : this(
          id: id,
          accountType: mapAccountTypeFromStr(json?[_accountTypeField]),
          gender: Gender.values.byName(json?[_genderField]),
          //TODO: Write function to map gender type
          name: json?[_nameField],
          surname: json?[_surnameField],
          email: json?[_emailField],
          coachId: json?[coachIdField],
        );

  Map<String, dynamic> toJson() => {
        _accountTypeField: mapAccountTypeToStr(accountType),
        _genderField: gender.name,
        _nameField: name,
        _surnameField: surname,
        _emailField: email,
        coachIdField: coachId,
      };
}

Map<String, dynamic> createUserJsonToUpdate({
  AccountType? accountType,
  Gender? gender,
  String? name,
  String? surname,
  String? email,
  String? coachId,
  bool coachIdAsNull = false,
}) =>
    {
      if (accountType != null)
        _accountTypeField: mapAccountTypeToStr(accountType),
      if (gender != null) _genderField: gender.name,
      if (name != null) _nameField: name,
      if (surname != null) _surnameField: surname,
      if (email != null) _emailField: email,
      if (coachIdAsNull)
        coachIdField: null
      else if (coachId != null)
        coachIdField: coachId,
    };

const String _accountTypeField = 'accountType';
const String _genderField = 'gender';
const String _nameField = 'name';
const String _surnameField = 'surname';
const String _emailField = 'email';
const String coachIdField = 'coachId';
