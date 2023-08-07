import 'package:equatable/equatable.dart';

enum Gender { male, female }

class UserDto extends Equatable {
  final String id;
  final Gender gender;
  final String name;
  final String surname;
  final String? coachId;
  final List<String>? idsOfRunners;

  const UserDto({
    required this.id,
    required this.gender,
    required this.name,
    required this.surname,
    this.coachId,
    this.idsOfRunners,
  });

  @override
  List<Object?> get props => [
        id,
        gender,
        name,
        surname,
        coachId,
        idsOfRunners,
      ];

  UserDto.fromJson(
    String id,
    Map<String, dynamic>? json,
  ) : this(
          id: id,
          gender: Gender.values.byName(json?[_genderField]),
          name: json?[_nameField],
          surname: json?[_surnameField],
          coachId: json?[_coachIdField],
          idsOfRunners: (json?[_idsOfRunnersField] as List?)
              ?.map((e) => e.toString())
              .toList(),
        );

  Map<String, dynamic> toJson() => {
        _genderField: gender.name,
        _nameField: name,
        _surnameField: surname,
        _coachIdField: coachId,
        _idsOfRunnersField: idsOfRunners,
      };
}

Map<String, dynamic> createUserJsonToUpdate({
  Gender? gender,
  String? name,
  String? surname,
  String? coachId,
  bool coachIdAsNull = false,
  List<String>? idsOfRunners,
  bool idsOfRunnersAsNull = false,
}) =>
    {
      if (gender != null) _genderField: gender.name,
      if (name != null) _nameField: name,
      if (surname != null) _surnameField: surname,
      if (coachIdAsNull)
        _coachIdField: null
      else if (coachId != null)
        _coachIdField: coachId,
      if (idsOfRunnersAsNull)
        _idsOfRunnersField: null
      else if (idsOfRunners != null)
        _idsOfRunnersField: idsOfRunners,
    };

const String _genderField = 'gender';
const String _nameField = 'name';
const String _surnameField = 'surname';
const String _coachIdField = 'coachId';
const String _idsOfRunnersField = 'idsOfRunners';
