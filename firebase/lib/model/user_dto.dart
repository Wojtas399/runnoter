import 'package:equatable/equatable.dart';

enum Gender { male, female }

class UserDto extends Equatable {
  final String id;
  final Gender gender;
  final String name;
  final String surname;
  final String email;
  final String? coachId;
  final List<String>? clientIds;

  const UserDto({
    required this.id,
    required this.gender,
    required this.name,
    required this.surname,
    required this.email,
    this.coachId,
    this.clientIds,
  });

  @override
  List<Object?> get props => [
        id,
        gender,
        name,
        surname,
        email,
        coachId,
        clientIds,
      ];

  UserDto.fromJson(
    String id,
    Map<String, dynamic>? json,
  ) : this(
          id: id,
          gender: Gender.values.byName(json?[_genderField]),
          name: json?[_nameField],
          surname: json?[_surnameField],
          email: json?[_emailField],
          coachId: json?[coachIdField],
          clientIds: (json?[_clientIdsField] as List?)
              ?.map((e) => e.toString())
              .toList(),
        );

  Map<String, dynamic> toJson() => {
        _genderField: gender.name,
        _nameField: name,
        _surnameField: surname,
        _emailField: email,
        coachIdField: coachId,
        _clientIdsField: clientIds,
      };
}

Map<String, dynamic> createUserJsonToUpdate({
  Gender? gender,
  String? name,
  String? surname,
  String? email,
  String? coachId,
  bool coachIdAsNull = false,
  List<String>? clientIds,
  bool clientIdsAsNull = false,
}) =>
    {
      if (gender != null) _genderField: gender.name,
      if (name != null) _nameField: name,
      if (surname != null) _surnameField: surname,
      if (email != null) _emailField: email,
      if (coachIdAsNull)
        coachIdField: null
      else if (coachId != null)
        coachIdField: coachId,
      if (clientIdsAsNull)
        _clientIdsField: null
      else if (clientIds != null)
        _clientIdsField: clientIds,
    };

const String _genderField = 'gender';
const String _nameField = 'name';
const String _surnameField = 'surname';
const String _emailField = 'email';
const String coachIdField = 'coachId';
const String _clientIdsField = 'clientIds';
