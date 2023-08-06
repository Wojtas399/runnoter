import 'package:firebase/firebase.dart';

import '../../domain/entity/settings.dart';
import '../../domain/entity/user.dart';
import 'gender_mapper.dart';

User mapUserFromDto({required UserDto userDto, required Settings settings}) {
  return userDto.idsOfRunners == null
      ? Runner(
          id: userDto.id,
          gender: mapGenderFromDto(userDto.gender),
          name: userDto.name,
          surname: userDto.surname,
          settings: settings,
          coachId: userDto.coachId,
        )
      : Coach(
          id: userDto.id,
          gender: mapGenderFromDto(userDto.gender),
          name: userDto.name,
          surname: userDto.surname,
          settings: settings,
          coachId: userDto.coachId,
          idsOfRunners: userDto.idsOfRunners!,
        );
}
