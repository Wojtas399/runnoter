part of firebase;

class UserDto {
  final String? name;
  final String? surname;

  const UserDto({
    required this.name,
    required this.surname,
  });

  factory UserDto.fromJson(
    Map<String, dynamic>? json,
  ) {
    return UserDto(
      name: json?[_FireUserFields.name],
      surname: json?[_FireUserFields.surname],
    );
  }

  Map<String, Object?> toJson() {
    return {
      if (name != null) _FireUserFields.name: name,
      if (surname != null) _FireUserFields.surname: surname,
    };
  }
}

class _FireUserFields {
  static const String name = 'name';
  static const String surname = 'surname';
}
