import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/data/mapper/user_mapper.dart';

void main() {
  const String userId = 'u1';
  const firebase.Gender firebaseGender = firebase.Gender.male;
  const Gender gender = Gender.male;
  const String name = 'name';
  const String surname = 'surname';
  const String email = 'email@example.com';
  final DateTime dateOfBirth = DateTime(2023, 1, 10);
  const String coachId = 'c1';
  const UserSettings settings = UserSettings(
    themeMode: ThemeMode.dark,
    language: Language.english,
    distanceUnit: DistanceUnit.kilometers,
    paceUnit: PaceUnit.minutesPerKilometer,
  );

  test(
    'map user from dto, '
    'should map dto model to domain model',
    () {
      final firebase.UserDto userDto = firebase.UserDto(
        id: userId,
        accountType: firebase.AccountType.runner,
        gender: firebaseGender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
      );
      final User expectedUser = User(
        id: userId,
        accountType: AccountType.runner,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        settings: settings,
        coachId: coachId,
      );

      final User user = mapUserFromDto(
        userDto: userDto,
        userSettings: settings,
      );

      expect(user, expectedUser);
    },
  );

  test(
    'map user to dto, '
    'should map domain model to dto model',
    () {
      final User user = User(
        id: userId,
        accountType: AccountType.runner,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        settings: settings,
        coachId: coachId,
      );
      final firebase.UserDto expectedUserDto = firebase.UserDto(
        id: userId,
        accountType: firebase.AccountType.runner,
        gender: firebaseGender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
      );

      final firebase.UserDto userDto = mapUserToDto(user: user);

      expect(userDto, expectedUserDto);
    },
  );
}
