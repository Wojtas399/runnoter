import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/user_mapper.dart';
import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/entity/user.dart';

void main() {
  const String userId = 'u1';
  const firebase.Gender firebaseGender = firebase.Gender.male;
  const Gender gender = Gender.male;
  const String name = 'name';
  const String surname = 'surname';
  const String coachId = 'c1';
  const Settings settings = Settings(
    themeMode: ThemeMode.dark,
    language: Language.english,
    distanceUnit: DistanceUnit.kilometers,
    paceUnit: PaceUnit.minutesPerKilometer,
  );

  test(
    'map user from dto, '
    'clientIds param is null, '
    'should map firebase dto model to user model with account type runner',
    () {
      const userDto = firebase.UserDto(
        id: userId,
        gender: firebaseGender,
        name: name,
        surname: surname,
        coachId: coachId,
      );
      const User expectedUser = User(
        id: userId,
        accountType: AccountType.runner,
        gender: gender,
        name: name,
        surname: surname,
        email: '',
        settings: settings,
        coachId: coachId,
      );

      final User user = mapUserFromDto(userDto: userDto, settings: settings);

      expect(user, expectedUser);
    },
  );

  test(
    'map user from dto, '
    'clientIds param is not null, '
    'should map firebase dto model to user model with account type coach',
    () {
      const List<String> clientIds = ['r1', 'r2'];
      const userDto = firebase.UserDto(
        id: userId,
        gender: firebaseGender,
        name: name,
        surname: surname,
        coachId: coachId,
        clientIds: clientIds,
      );
      const User expectedUser = User(
        id: userId,
        accountType: AccountType.coach,
        gender: gender,
        name: name,
        surname: surname,
        email: '',
        settings: settings,
        coachId: coachId,
        clientIds: clientIds,
      );

      final User user = mapUserFromDto(userDto: userDto, settings: settings);

      expect(user, expectedUser);
    },
  );
}
