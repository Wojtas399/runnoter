import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'u1';
  const Gender gender = Gender.male;
  const String name = 'Jack';
  const String surname = 'Gadovsky';
  const String coachId = 'c1';
  const List<String> clientIds = ['r1', 'r2'];

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'coachId': coachId,
        'clientIds': clientIds
      };
      const UserDto expectedDto = UserDto(
        id: id,
        gender: gender,
        name: name,
        surname: surname,
        coachId: coachId,
        clientIds: clientIds,
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
        coachId: coachId,
        clientIds: clientIds,
      );
      final Map<String, dynamic> expectedJson = {
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'coachId': coachId,
        'clientIds': clientIds,
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
        'coachId': coachId,
        'clientIds': clientIds,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        name: name,
        surname: surname,
        coachId: coachId,
        clientIds: clientIds,
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
        'coachId': coachId,
        'clientIds': clientIds,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        gender: gender,
        surname: surname,
        coachId: coachId,
        clientIds: clientIds,
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
        'coachId': coachId,
        'clientIds': clientIds,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        gender: gender,
        name: name,
        coachId: coachId,
        clientIds: clientIds,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'coach id is null, '
    'should not include coach id in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'clientIds': clientIds,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        gender: gender,
        name: name,
        surname: surname,
        clientIds: clientIds,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'coach id as null set to true, '
    'should include coach id param with null value',
    () {
      final Map<String, dynamic> expectedJson = {
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'coachId': null,
        'clientIds': clientIds,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        gender: gender,
        name: name,
        surname: surname,
        coachId: coachId,
        coachIdAsNull: true,
        clientIds: clientIds,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'clientIds is null, '
    'should not include clientIds in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'coachId': coachId,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        gender: gender,
        name: name,
        surname: surname,
        coachId: coachId,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'clientIds as null set to true, '
    'should include clientIds param with null value',
    () {
      final Map<String, dynamic> expectedJson = {
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'coachId': coachId,
        'clientIds': null,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        gender: gender,
        name: name,
        surname: surname,
        coachId: coachId,
        clientIds: clientIds,
        clientIdsAsNull: true,
      );

      expect(json, expectedJson);
    },
  );
}
