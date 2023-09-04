import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'u1';
  const AccountType accountType = AccountType.runner;
  const Gender gender = Gender.male;
  const String name = 'Jack';
  const String surname = 'Gadovsky';
  const String email = 'email@example.com';
  final DateTime dateOfBirth = DateTime(2023, 1, 10);
  const String dateOfBirthStr = '2023-01-10';
  const String coachId = 'c1';

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'accountType': accountType.name,
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'email': email,
        'dateOfBirth': dateOfBirthStr,
        'coachId': coachId,
      };
      final UserDto expectedDto = UserDto(
        id: id,
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
      );

      final UserDto dto = UserDto.fromJson(userId: id, json: json);

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final UserDto dto = UserDto(
        id: id,
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
      );
      final Map<String, dynamic> expectedJson = {
        'accountType': accountType.name,
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'email': email,
        'dateOfBirth': dateOfBirthStr,
        'coachId': coachId,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'account type is null, '
    'should not include account type in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'email': email,
        'dateOfBirth': dateOfBirthStr,
        'coachId': coachId,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'gender is null, '
    'should not include gender in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'accountType': accountType.name,
        'name': name,
        'surname': surname,
        'email': email,
        'dateOfBirth': dateOfBirthStr,
        'coachId': coachId,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        accountType: accountType,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
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
        'accountType': accountType.name,
        'gender': gender.name,
        'surname': surname,
        'email': email,
        'dateOfBirth': dateOfBirthStr,
        'coachId': coachId,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        accountType: accountType,
        gender: gender,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
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
        'accountType': accountType.name,
        'gender': gender.name,
        'name': name,
        'email': email,
        'dateOfBirth': dateOfBirthStr,
        'coachId': coachId,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        accountType: accountType,
        gender: gender,
        name: name,
        email: email,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'email is null, '
    'should not include email in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'accountType': accountType.name,
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'dateOfBirth': dateOfBirthStr,
        'coachId': coachId,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'dateOfBirth is null, '
    'should not include dateOfBirth in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'accountType': accountType.name,
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'email': email,
        'coachId': coachId,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        coachId: coachId,
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
        'accountType': accountType.name,
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'email': email,
        'dateOfBirth': dateOfBirthStr,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
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
        'accountType': accountType.name,
        'gender': gender.name,
        'name': name,
        'surname': surname,
        'email': email,
        'dateOfBirth': dateOfBirthStr,
        'coachId': null,
      };

      final Map<String, dynamic> json = createUserJsonToUpdate(
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
        coachIdAsNull: true,
      );

      expect(json, expectedJson);
    },
  );
}
