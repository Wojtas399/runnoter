import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/user_mapper.dart';
import 'package:runnoter/domain/additional_model/settings.dart';
import 'package:runnoter/domain/entity/user.dart';

void main() {
  const String userId = 'u1';
  const firebase.Gender firebaseGender = firebase.Gender.male;
  const Gender gender = Gender.male;
  const String name = 'name';
  const String surname = 'surname';
  const String email = 'email@example.com';
  const String coachId = 'c1';
  const Settings settings = Settings(
    themeMode: ThemeMode.dark,
    language: Language.english,
    distanceUnit: DistanceUnit.kilometers,
    paceUnit: PaceUnit.minutesPerKilometer,
  );

  test(
    'map user from dto, '
    'should map firebase dto model to domain model',
    () {
      const userDto = firebase.UserDto(
        id: userId,
        accountType: firebase.AccountType.runner,
        gender: firebaseGender,
        name: name,
        surname: surname,
        email: email,
        coachId: coachId,
      );
      final User expectedUser = User(
        id: userId,
        accountType: AccountType.runner,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: DateTime(2023), //TODO: Implement date of birth
        settings: settings,
        coachId: coachId,
      );

      final User user = mapUserFromDto(userDto: userDto, settings: settings);

      expect(user, expectedUser);
    },
  );
}
