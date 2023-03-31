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

  factory UserDto.fromJson(
    String id,
    Map<String, dynamic>? json,
  ) {
    return UserDto(
      id: id,
      name: json?[_FireUserFields.name],
      surname: json?[_FireUserFields.surname],
    );
  }

  Map<String, Object?> toJson() {
    return {
      _FireUserFields.name: name,
      _FireUserFields.surname: surname,
    };
  }
}

Map<String, Object> createUserDtoJsonToUpdate({
  String? name,
  String? surname,
}) {
  return {
    if (name != null) _FireUserFields.name: name,
    if (surname != null) _FireUserFields.surname: surname,
  };
}

class _FireUserFields {
  static const String name = 'name';
  static const String surname = 'surname';
}
