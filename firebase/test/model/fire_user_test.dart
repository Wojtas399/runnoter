import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String name = 'Jack';
  const String surname = 'Gadovsky';

  test(
    "from firestore, should map json to fire user model",
    () {
      final Map<String, dynamic> json = {
        'name': name,
        'surname': surname,
      };
      const UserDto expectedUserDto = UserDto(
        name: name,
        surname: surname,
      );

      final UserDto userDto = UserDto.fromJson(json);

      expect(userDto.name, expectedUserDto.name);
      expect(userDto.surname, expectedUserDto.surname);
    },
  );

  test(
    "from firestore, name param doesn't exist in json, should set name as null",
    () {
      final Map<String, dynamic> json = {
        'surname': surname,
      };
      const UserDto expectedUserDto = UserDto(
        name: null,
        surname: surname,
      );

      final UserDto userDto = UserDto.fromJson(json);

      expect(userDto.name, null);
      expect(userDto.surname, expectedUserDto.surname);
    },
  );

  test(
    "from firestore, surname param doesn't exist in json, should set surname as null",
    () {
      final Map<String, dynamic> json = {
        'name': name,
      };
      const UserDto expectedUserDto = UserDto(
        name: name,
        surname: null,
      );

      final UserDto userDto = UserDto.fromJson(json);

      expect(userDto.name, expectedUserDto.name);
      expect(userDto.surname, null);
    },
  );

  test(
    "to json, should map fire user model to json",
    () {
      const UserDto userDto = UserDto(
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

  test(
    "to json, name is null, should not add name to json",
    () {
      const UserDto userDto = UserDto(
        name: null,
        surname: surname,
      );
      final Map<String, dynamic> expectedJson = {
        'surname': surname,
      };

      final Map<String, dynamic> json = userDto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    "to json, surname is null, should not add surname to json",
    () {
      const UserDto userDto = UserDto(
        name: name,
        surname: null,
      );
      final Map<String, dynamic> expectedJson = {
        'name': name,
      };

      final Map<String, dynamic> json = userDto.toJson();

      expect(json, expectedJson);
    },
  );
}
