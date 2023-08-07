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
    'ids of runners are null, '
    'should map firebase dto model to runner model',
    () {
      const userDto = firebase.UserDto(
        id: userId,
        gender: firebaseGender,
        name: name,
        surname: surname,
        coachId: coachId,
      );
      const User expectedUser = Runner(
        id: userId,
        gender: gender,
        name: name,
        surname: surname,
        settings: settings,
        coachId: coachId,
      );

      final User user = mapUserFromDto(userDto: userDto, settings: settings);

      expect(user, expectedUser);
    },
  );

  test(
    'map user from dto, '
    'clientIds is not null, '
    'should map firebase dto model to coach model',
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
      const User expectedUser = Coach(
        id: userId,
        gender: gender,
        name: name,
        surname: surname,
        settings: settings,
        coachId: coachId,
        clientIds: clientIds,
      );

      final User user = mapUserFromDto(userDto: userDto, settings: settings);

      expect(user, expectedUser);
    },
  );
}
