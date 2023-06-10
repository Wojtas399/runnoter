import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/user_mapper.dart';
import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/entity/user.dart';

void main() {
  test(
    'map user from dto',
    () {
      const userDto = firebase.UserDto(
        id: 'u1',
        name: 'name',
        surname: 'surname',
      );
      const appearanceSettingsDto = firebase.AppearanceSettingsDto(
        userId: 'u1',
        themeMode: firebase.ThemeMode.dark,
        language: firebase.Language.english,
      );
      const workoutSettingsDto = firebase.WorkoutSettingsDto(
        userId: 'u1',
        distanceUnit: firebase.DistanceUnit.kilometers,
        paceUnit: firebase.PaceUnit.minutesPerKilometer,
      );
      const User expectedUser = User(
        id: 'u1',
        name: 'name',
        surname: 'surname',
        settings: Settings(
          themeMode: ThemeMode.dark,
          language: Language.english,
          distanceUnit: DistanceUnit.kilometers,
          paceUnit: PaceUnit.minutesPerKilometer,
        ),
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
