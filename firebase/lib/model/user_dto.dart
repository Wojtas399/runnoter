part of firebase;

class UserDto extends Equatable {
  final String id;
  final String name;
  final String surname;

  const UserDto({
    required this.id,
    required this.name,
    required this.surname,
  });

  @override
  List<Object> get props => [
        id,
        name,
        surname,
      ];

  UserDto.fromJson(
    String id,
    Map<String, dynamic>? json,
  ) : this(
          id: id,
          name: json?[_UserFields.name],
          surname: json?[_UserFields.surname],
        );

  Map<String, dynamic> toJson() {
    return {
      _UserFields.name: name,
      _UserFields.surname: surname,
    };
  }
}

Map<String, dynamic> createUserDtoJsonToUpdate({
  String? name,
  String? surname,
}) {
  return {
    if (name != null) _UserFields.name: name,
    if (surname != null) _UserFields.surname: surname,
  };
}

class _UserFields {
  static const String name = 'name';
  static const String surname = 'surname';
}
