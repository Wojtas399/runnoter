import 'package:firebase/model/dto/user_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String name = 'Jack';
  const String surname = 'Gadovsky';

  test(
    'from firestore, should map json to dto model',
    () {
      const String id = 'u1';
      final Map<String, dynamic> json = {
        'name': name,
        'surname': surname,
      };
      const UserDto expectedUserDto = UserDto(
        id: id,
        name: name,
        surname: surname,
      );

      final UserDto userDto = UserDto.fromJson(id, json);

      expect(userDto.name, expectedUserDto.name);
      expect(userDto.surname, expectedUserDto.surname);
    },
  );

  test(
    'to json, should map dto model to json',
    () {
      const UserDto userDto = UserDto(
        id: 'u1',
        name: name,
        surname: surname,
      );
      final Map<String, dynamic> expectedJson = {
        'name': name,
        'surname': surname,
      };

      final Map<String, dynamic> json = userDto.toJson();

      expect(json, expectedJson);
    },
  );
}
