import 'package:equatable/equatable.dart';

enum Gender {
  male,
  female,
}

class UserDto extends Equatable {
  final String id;
  final Gender gender;
  final String name;
  final String surname;

  const UserDto({
    required this.id,
    required this.gender,
    required this.name,
    required this.surname,
  });

  @override
  List<Object> get props => [
        id,
        gender,
        name,
        surname,
      ];

  UserDto.fromJson(
    String id,
    Map<String, dynamic>? json,
  ) : this(
          id: id,
          gender: Gender.values.byName(json?[_genderField]),
          name: json?[_nameField],
          surname: json?[_surnameField],
        );

  Map<String, dynamic> toJson() {
    return {
      _genderField: gender.name,
      _nameField: name,
      _surnameField: surname,
    };
  }
}

Map<String, dynamic> createUserJsonToUpdate({
  Gender? gender,
  String? name,
  String? surname,
}) =>
    {
      if (gender != null) _genderField: gender.name,
      if (name != null) _nameField: name,
      if (surname != null) _surnameField: surname,
    };

const String _genderField = 'gender';
const String _nameField = 'name';
const String _surnameField = 'surname';
