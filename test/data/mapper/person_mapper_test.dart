import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/person_mapper.dart';
import 'package:runnoter/data/model/person.dart';
import 'package:runnoter/data/model/user.dart';

import '../../creators/user_dto_creator.dart';

void main() {
  const String id = 'u1';
  const firebase.AccountType dtoAccountType = firebase.AccountType.coach;
  const AccountType accountType = AccountType.coach;
  const firebase.Gender dtoGender = firebase.Gender.male;
  const Gender gender = Gender.male;
  const String name = 'name';
  const String surname = 'surname';
  const String email = 'email@example.com';
  final DateTime dateOfBirth = DateTime(2003, 1, 10);
  const String coachId = 'c1';

  test(
    'map person from user dto, '
    'should map UserDto model to domain UserBasicInfo model',
    () {
      final firebase.UserDto userDto = createUserDto(
        id: id,
        accountType: dtoAccountType,
        gender: dtoGender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
      );
      final Person expectedPerson = Person(
        id: id,
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
      );

      final Person person = mapPersonFromUserDto(userDto);

      expect(person, expectedPerson);
    },
  );
}
