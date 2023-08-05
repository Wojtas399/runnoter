import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'u1';
  const Gender gender = Gender.male;
  const String name = 'Jack';
  const String surname = 'Gadovsky';

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'gender': gender.name,
        'name': name,
        'surname': surname,
      };
      const UserDto expectedDto = UserDto(
        id: id,
        gender: gender,
        name: name,
        surname: surname,
      );

      final UserDto dto = UserDto.fromJson(id, json);

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      const UserDto dto = UserDto(
        id: id,
        gender: gender,
        name: name,
        surname: surname,
      );
      final Map<String, dynamic> expectedJson = {
        'gender': gender.name,
        'name': name,
        'surname': surname,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'gender is null, '
    'should not include gender in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'name': name,
        'surname': surname,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        name: name,
        surname: surname,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'name is null, '
    'should not include name in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'gender': gender.name,
        'surname': surname,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        gender: gender,
        surname: surname,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'surname is null, '
    'should not include surname in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'gender': gender.name,
        'name': name,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        gender: gender,
        name: name,
      );

      expect(json, expectedJson);
    },
  );
}
