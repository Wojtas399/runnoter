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
  const appearanceSettingsDto = firebase.AppearanceSettingsDto(
    userId: userId,
    themeMode: firebase.ThemeMode.dark,
    language: firebase.Language.english,
  );
  const workoutSettingsDto = firebase.WorkoutSettingsDto(
    userId: userId,
    distanceUnit: firebase.DistanceUnit.kilometers,
    paceUnit: firebase.PaceUnit.minutesPerKilometer,
  );
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

      final User user = mapUserFromDto(
        userDto: userDto,
        appearanceSettingsDto: appearanceSettingsDto,
        workoutSettingsDto: workoutSettingsDto,
      );

      expect(user, expectedUser);
    },
  );

  test(
    'map user from dto, '
    'ids of runners are not null, '
    'should map firebase dto model to coach model',
    () {
      const List<String> idsOfRunners = ['r1', 'r2'];
      const userDto = firebase.UserDto(
        id: userId,
        gender: firebaseGender,
        name: name,
        surname: surname,
        coachId: coachId,
        idsOfRunners: idsOfRunners,
      );
      const User expectedUser = Coach(
        id: userId,
        gender: gender,
        name: name,
        surname: surname,
        settings: settings,
        coachId: coachId,
        idsOfRunners: idsOfRunners,
      );

      final User user = mapUserFromDto(
        userDto: userDto,
        appearanceSettingsDto: appearanceSettingsDto,
        workoutSettingsDto: workoutSettingsDto,
      );

      expect(user, expectedUser);
    },
  );
}
