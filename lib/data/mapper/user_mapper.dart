import 'package:firebase/firebase.dart';

import '../../domain/entity/user.dart';
import 'gender_mapper.dart';
import 'settings_mapper.dart';

User mapUserFromDto({
  required UserDto userDto,
  required AppearanceSettingsDto appearanceSettingsDto,
  required WorkoutSettingsDto workoutSettingsDto,
}) {
  return userDto.idsOfRunners == null
      ? Runner(
          id: userDto.id,
          gender: mapGenderFromDto(userDto.gender),
          name: userDto.name,
          surname: userDto.surname,
          settings: mapSettingsFromDto(
            appearanceSettingsDto: appearanceSettingsDto,
            workoutSettingsDto: workoutSettingsDto,
          ),
          coachId: userDto.coachId,
        )
      : Coach(
          id: userDto.id,
          gender: mapGenderFromDto(userDto.gender),
          name: userDto.name,
          surname: userDto.surname,
          settings: mapSettingsFromDto(
            appearanceSettingsDto: appearanceSettingsDto,
            workoutSettingsDto: workoutSettingsDto,
          ),
          coachId: userDto.coachId,
          idsOfRunners: userDto.idsOfRunners!,
        );
}
