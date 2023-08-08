import 'package:firebase/firebase.dart';

import '../../domain/entity/settings.dart';
import '../../domain/entity/user.dart';
import 'gender_mapper.dart';

User mapUserFromDto({required UserDto userDto, required Settings settings}) =>
    User(
      accountType:
          userDto.clientIds != null ? AccountType.coach : AccountType.runner,
      id: userDto.id,
      gender: mapGenderFromDto(userDto.gender),
      name: userDto.name,
      surname: userDto.surname,
      email: userDto.email,
      settings: settings,
      coachId: userDto.coachId,
      clientIds: userDto.clientIds,
    );
