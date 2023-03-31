import 'package:firebase/firebase.dart';

import '../../domain/model/user.dart';
import 'settings_mapper.dart';

User mapUserFromDtoModel({
  required UserDto userDto,
  required AppearanceSettingsDto appearanceSettingsDto,
  required WorkoutSettingsDto workoutSettingsDto,
}) {
  return User(
    id: userDto.id,
    name: userDto.name,
    surname: userDto.surname,
    settings: mapSettingsFromDb(
      appearanceSettingsDto: appearanceSettingsDto,
      workoutSettingsDto: workoutSettingsDto,
    ),
  );
}
