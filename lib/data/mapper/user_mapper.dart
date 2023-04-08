import 'package:firebase/firebase.dart';

import '../../domain/model/user.dart';
import 'settings_mapper.dart';

User mapUserFromDto({
  required UserDto userDto,
  required AppearanceSettingsDto appearanceSettingsDto,
  required WorkoutSettingsDto workoutSettingsDto,
}) {
  return User(
    id: userDto.id,
    name: userDto.name,
    surname: userDto.surname,
    settings: mapSettingsFromDto(
      appearanceSettingsDto: appearanceSettingsDto,
      workoutSettingsDto: workoutSettingsDto,
    ),
  );
}
